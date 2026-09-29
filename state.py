#!/usr/bin/env python3
"""state.py — cross-session memory for hunting: hosts, endpoints, params, and
findings, with deduplication. So the agent never re-works or re-reports, and
"what's new since last run" is answerable (that's where recurring income on a
program comes from).

DB: .bbstate.db (SQLite) in the working dir, or $BB_STATE.

Usage:
    python3 state.py add-host example.com sub.example.com
    python3 state.py add-endpoint https://x/api/v1/users GET 200
    python3 state.py add-param https://x/search q
    python3 state.py seen <signature>            # exit 0 if already recorded
    python3 state.py finding SSRF https://x/fetch url "blind ssrf via url="
    python3 state.py report <finding_id> H1-123456
    python3 state.py stats
    python3 state.py new-since 2026-09-01        # findings added since date
Signature for dedup is computed as sha1(class|normalised-endpoint|param).
"""
import sys, os, sqlite3, hashlib, time, re
from urllib.parse import urlsplit, urlunsplit

DB = os.environ.get("BB_STATE", ".bbstate.db")


def conn():
    c = sqlite3.connect(DB)
    c.executescript("""
    CREATE TABLE IF NOT EXISTS hosts(host TEXT PRIMARY KEY, first_seen TEXT);
    CREATE TABLE IF NOT EXISTS endpoints(url TEXT, method TEXT, status INT,
        first_seen TEXT, PRIMARY KEY(url, method));
    CREATE TABLE IF NOT EXISTS params(url TEXT, param TEXT, first_seen TEXT,
        PRIMARY KEY(url, param));
    CREATE TABLE IF NOT EXISTS findings(id INTEGER PRIMARY KEY AUTOINCREMENT,
        sig TEXT UNIQUE, class TEXT, endpoint TEXT, param TEXT, note TEXT,
        status TEXT DEFAULT 'candidate', report_id TEXT, created TEXT);
    """)
    return c


def norm(url):
    try:
        s = urlsplit(url)
        path = re.sub(r"/\d+", "/{id}", s.path)          # collapse numeric ids
        return urlunsplit((s.scheme, s.netloc, path, "", ""))
    except Exception:
        return url


def sig(cls, endpoint, param):
    raw = f"{cls.lower()}|{norm(endpoint)}|{(param or '').lower()}"
    return hashlib.sha1(raw.encode()).hexdigest()[:16]


def now():
    return time.strftime("%Y-%m-%d %H:%M:%S")


def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    c = conn(); cmd = sys.argv[1]
    if cmd == "add-host":
        for h in sys.argv[2:]:
            c.execute("INSERT OR IGNORE INTO hosts VALUES(?,?)", (h, now()))
    elif cmd == "add-endpoint":
        url, method = sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else "GET"
        status = int(sys.argv[4]) if len(sys.argv) > 4 else 0
        c.execute("INSERT OR IGNORE INTO endpoints VALUES(?,?,?,?)",
                  (url, method, status, now()))
    elif cmd == "add-param":
        c.execute("INSERT OR IGNORE INTO params VALUES(?,?,?)",
                  (sys.argv[2], sys.argv[3], now()))
    elif cmd == "add-hosts-stdin":                       # bulk: one process for N hosts
        rows = [(h, now()) for h in (l.strip() for l in sys.stdin) if h]
        c.executemany("INSERT OR IGNORE INTO hosts VALUES(?,?)", rows)
        print(f"added/ignored {len(rows)} hosts")
    elif cmd == "add-endpoints-stdin":                   # bulk: URLs on stdin, one method/status
        method = sys.argv[2] if len(sys.argv) > 2 else "GET"
        status = int(sys.argv[3]) if len(sys.argv) > 3 else 0
        rows = [(u, method, status, now()) for u in (l.strip() for l in sys.stdin) if u]
        c.executemany("INSERT OR IGNORE INTO endpoints VALUES(?,?,?,?)", rows)
        print(f"added/ignored {len(rows)} endpoints")
    elif cmd == "seen":
        s = sys.argv[2]
        row = c.execute("SELECT 1 FROM findings WHERE sig=?", (s,)).fetchone()
        print("SEEN" if row else "NEW"); sys.exit(0 if row else 1)
    elif cmd == "finding":
        cls, endpoint = sys.argv[2], sys.argv[3]
        param = sys.argv[4] if len(sys.argv) > 4 else ""
        note = sys.argv[5] if len(sys.argv) > 5 else ""
        s = sig(cls, endpoint, param)
        try:
            c.execute("INSERT INTO findings(sig,class,endpoint,param,note,created)"
                      " VALUES(?,?,?,?,?,?)", (s, cls, endpoint, param, note, now()))
            fid = c.execute("SELECT id FROM findings WHERE sig=?", (s,)).fetchone()[0]
            print(f"RECORDED id={fid} sig={s}")
        except sqlite3.IntegrityError:
            print(f"DUPLICATE sig={s} (already recorded)")
    elif cmd == "report":
        c.execute("UPDATE findings SET status='reported', report_id=? WHERE id=?",
                  (sys.argv[3], sys.argv[2]))
        print(f"finding {sys.argv[2]} -> reported as {sys.argv[3]}")
    elif cmd == "new-since":
        for r in c.execute("SELECT id,class,endpoint,status,created FROM findings"
                           " WHERE created>=? ORDER BY created", (sys.argv[2],)):
            print(r)
    elif cmd == "stats":
        for t in ("hosts", "endpoints", "params", "findings"):
            n = c.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
            print(f"{t:10} {n}")
    else:
        print(__doc__); sys.exit(1)
    c.commit(); c.close()


if __name__ == "__main__":
    main()
