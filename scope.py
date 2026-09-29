#!/usr/bin/env python3
"""scope.py — enforced scope guard. Every recon/fuzz wrapper calls this before
firing at a host, so 'stay in scope' is code, not a vibe.

Scope file (default ./scope.txt), one rule per line:
    example.com            # apex (also matches *.example.com)
    *.api.example.com      # explicit wildcard
    203.0.113.0/24         # CIDR
    !dev.example.com       # exclusion (out of scope) — checked first
Lines starting with # are comments.

Usage:
    python3 scope.py check https://sub.example.com/path   # exit 0 in-scope, 2 out
    python3 scope.py filter < hosts.txt                   # print only in-scope
    python3 scope.py add "*.example.com"                  # append a rule
"""
import sys, os, re, ipaddress
from urllib.parse import urlparse

SCOPE_FILE = os.environ.get("BB_SCOPE", "scope.txt")


def host_of(s):
    s = s.strip()
    if not s:
        return None
    if "://" not in s:
        s = "//" + s
    h = urlparse(s).hostname or ""
    return h.lower() or None


def load_rules(path):
    inc, exc, cidrs = [], [], []
    if not os.path.exists(path):
        return inc, exc, cidrs
    for line in open(path):
        line = line.split("#", 1)[0].strip()
        if not line:
            continue
        neg = line.startswith("!")
        rule = line[1:].strip() if neg else line
        try:
            net = ipaddress.ip_network(rule, strict=False)
            (exc if neg else inc).append(("cidr", net))
            continue
        except ValueError:
            pass
        (exc if neg else inc).append(("host", rule.lower()))
    return inc, exc, cidrs


def rule_matches(kind, val, host):
    if kind == "cidr":
        try:
            return ipaddress.ip_address(host) in val
        except ValueError:
            return False
    # host rule: support leading *. and bare apex (apex also covers subdomains)
    if val.startswith("*."):
        base = val[2:]
        return host == base or host.endswith("." + base)
    return host == val or host.endswith("." + val)


def in_scope(target):
    host = host_of(target)
    if not host:
        return False
    inc, exc, _ = load_rules(SCOPE_FILE)
    for kind, val in exc:                       # exclusions win
        if rule_matches(kind, val, host):
            return False
    for kind, val in inc:
        if rule_matches(kind, val, host):
            return True
    return False


def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    cmd = sys.argv[1]
    if cmd == "check":
        t = sys.argv[2]
        if in_scope(t):
            print(f"IN-SCOPE  {host_of(t)}"); sys.exit(0)
        print(f"OUT-OF-SCOPE  {host_of(t)}  (refusing)"); sys.exit(2)
    elif cmd == "filter":
        for line in sys.stdin:
            if in_scope(line):
                sys.stdout.write(line)
    elif cmd == "add":
        raw = sys.argv[2].strip()
        neg = raw.startswith("!")
        body = raw[1:].strip() if neg else raw
        wild = body.startswith("*.")
        core = body[2:] if wild else body
        try:
            ipaddress.ip_network(core, strict=False)   # CIDR — keep as-is
            rule = body
        except ValueError:
            h = host_of(core)                          # strips scheme/path if a URL was pasted
            if not h:
                sys.exit(f"not a valid host/CIDR: {raw}")
            rule = ("*." + h) if wild else h
        rule = ("!" if neg else "") + rule
        with open(SCOPE_FILE, "a") as f:
            f.write(rule + "\n")
        print(f"added to {SCOPE_FILE}: {rule}")
    else:
        print(__doc__); sys.exit(1)


if __name__ == "__main__":
    main()
