#!/usr/bin/env bash
# hunt.sh — scope-gated recon pipeline that sets up a target workspace and runs
# passive + active recon, logging everything into state.py. Safe to re-run
# (idempotent via anew). It does NOT run intrusive exploitation tools in bulk —
# sqlmap/nmap-service/dalfox-active etc. are driven per-endpoint during the hunt
# phase (see HUNTING_RUNBOOK.md), where they belong.
#
# Usage:
#   bash hunt.sh <apex-domain> [--ports] [--nuclei] [--shots]
#     <apex>     e.g. acme.com   (must be in scope.txt — set it first)
#     --ports    add an nmap top-ports service scan on live hosts (louder)
#     --nuclei   run nuclei with safe/default templates on live hosts
#     --shots    gowitness screenshots of live hosts
#
# Prereqs: scope set ->  python3 scope.py add "*.acme.com"
# PATH must include ~/go/bin ~/.local/bin (see TOOL_INVENTORY.md).
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO"
APEX="${1:?usage: hunt.sh <apex-domain> [--ports] [--nuclei] [--shots]}"; shift || true
DO_PORTS=0; DO_NUCLEI=0; DO_SHOTS=0
for a in "$@"; do case "$a" in
  --ports) DO_PORTS=1;; --nuclei) DO_NUCLEI=1;; --shots) DO_SHOTS=1;;
esac; done

have(){ command -v "$1" >/dev/null 2>&1; }
W="work/$APEX"; mkdir -p "$W"
export BB_STATE="$REPO/.bbstate.db"
RL=15   # global politeness rate limit (req/s) — tune per program RoE

echo "==[ hunt: $APEX ]=================================================="
# 0) scope gate — refuse if apex not in scope
if ! python3 scope.py check "https://$APEX" >/dev/null 2>&1; then
  echo "!! $APEX is not in scope.txt. Add it first:  python3 scope.py add \"*.$APEX\""
  exit 2
fi
echo "[scope] $APEX confirmed in scope"

# 1) PASSIVE subdomain enumeration ---------------------------------------------
echo "[1/6] passive subdomain enumeration"
: > "$W/subs.raw"
bash crtname.sh "$APEX"                      2>/dev/null | anew -q "$W/subs.raw" || true
have subfinder    && subfinder -silent -d "$APEX"        2>/dev/null | anew -q "$W/subs.raw" || true
have assetfinder  && assetfinder --subs-only "$APEX"     2>/dev/null | anew -q "$W/subs.raw" || true
have amass        && amass enum -passive -d "$APEX" -silent 2>/dev/null | anew -q "$W/subs.raw" || true
have github-subdomains && [ -f ~/tools/.github_tokens ] && \
     github-subdomains -d "$APEX" -t ~/tools/.github_tokens 2>/dev/null | anew -q "$W/subs.raw" || true
# keep only in-scope
python3 scope.py filter < "$W/subs.raw" | sort -u > "$W/subs.txt"
echo "     $(wc -l < "$W/subs.txt") in-scope subdomains"

# 2) RESOLVE + LIVE HTTP probe -------------------------------------------------
echo "[2/6] resolve + probe"
if have dnsx;  then dnsx -silent < "$W/subs.txt" > "$W/resolved.txt" 2>/dev/null || cp "$W/subs.txt" "$W/resolved.txt"; else cp "$W/subs.txt" "$W/resolved.txt"; fi
if have httpx; then
  httpx -silent -rl "$RL" -title -tech-detect -status-code -o "$W/live.txt" < "$W/resolved.txt" 2>/dev/null || true
  awk '{print $1}' "$W/live.txt" | sed -E 's#^https?://##' | sort -u > "$W/live-hosts.txt"
else
  cp "$W/resolved.txt" "$W/live-hosts.txt"; cp "$W/resolved.txt" "$W/live.txt"
fi
echo "     $(wc -l < "$W/live-hosts.txt") live hosts"
# log hosts to state
python3 state.py add-hosts-stdin < "$W/live-hosts.txt" >/dev/null 2>&1 || true

# 3) URL / endpoint collection -------------------------------------------------
echo "[3/6] crawl + historical URLs"
: > "$W/urls.raw"
if have httpx; then awk '{print $1}' "$W/live.txt" > "$W/live-urls.txt"; else sed 's#^#https://#' "$W/live-hosts.txt" > "$W/live-urls.txt"; fi
have katana      && katana -silent -rl "$RL" -jc -d 2 -list "$W/live-urls.txt" 2>/dev/null | anew -q "$W/urls.raw" || true
have gau         && gau --subs "$APEX"                    2>/dev/null | anew -q "$W/urls.raw" || true
have waybackurls && waybackurls "$APEX"                   2>/dev/null | anew -q "$W/urls.raw" || true
# in-scope + de-dupe noise
python3 scope.py filter < "$W/urls.raw" | { have uro && uro || cat; } | sort -u > "$W/urls.txt"
echo "     $(wc -l < "$W/urls.txt") in-scope URLs"

# 4) JS + params ---------------------------------------------------------------
echo "[4/6] JS + parameter mining"
grep -Ei '\.js(\?|$)' "$W/urls.txt" | sort -u > "$W/js.txt" || true
have getJS && getJS --complete --input "$W/live-urls.txt" 2>/dev/null | anew -q "$W/js.txt" || true
# gf pattern buckets for quick triage
if have gf; then
  mkdir -p "$W/gf"
  for pat in xss sqli ssrf ssti lfi rce redirect idor; do
    gf "$pat" < "$W/urls.txt" 2>/dev/null | sort -u > "$W/gf/$pat.txt" || true
  done
fi
# log endpoints with params
grep -E '\?[a-zA-Z0-9_]+=' "$W/urls.txt" | sort -u > "$W/params.txt" || true
head -500 "$W/params.txt" | python3 state.py add-endpoints-stdin GET 0 >/dev/null 2>&1 || true
echo "     $(wc -l < "$W/js.txt") JS files, $(wc -l < "$W/params.txt") param URLs"

# 5) OPTIONAL: nmap service scan (louder) --------------------------------------
if [ "$DO_PORTS" = 1 ] && have nmap; then
  echo "[5/6] nmap top-ports service scan (in-scope hosts)"
  nmap -Pn -T3 --top-ports 100 -sV -iL "$W/live-hosts.txt" -oN "$W/nmap.txt" 2>/dev/null || true
else echo "[5/6] nmap skipped (use --ports to enable)"; fi

# 6) OPTIONAL: nuclei --------------------------------------------------------
if [ "$DO_NUCLEI" = 1 ] && have nuclei; then
  echo "[6/6] nuclei (safe/default templates, rate-limited)"
  nuclei -silent -rl "$RL" -l "$W/live-urls.txt" \
    -severity low,medium,high,critical -o "$W/nuclei.txt" 2>/dev/null || true
  echo "     nuclei hits: $(wc -l < "$W/nuclei.txt" 2>/dev/null || echo 0)"
else echo "[6/6] nuclei skipped (use --nuclei to enable)"; fi

# optional screenshots
if [ "$DO_SHOTS" = 1 ] && have gowitness; then
  echo "[+] gowitness screenshots"
  gowitness scan file -f "$W/live-urls.txt" --screenshot-path "$W/shots" 2>/dev/null || true
fi

echo
echo "==[ done: $W ]=================================================="
echo "Artifacts:"
echo "  subs.txt live.txt urls.txt params.txt js.txt gf/*.txt"
[ "$DO_PORTS" = 1 ]  && echo "  nmap.txt"
[ "$DO_NUCLEI" = 1 ] && echo "  nuclei.txt"
python3 state.py stats
echo
echo "Next: open the gf/ buckets and params.txt, form hypotheses, and hunt each"
echo "surface manually through Burp/Caido using the class skills (see HUNTING_RUNBOOK.md)."
