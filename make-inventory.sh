#!/usr/bin/env bash
# make-inventory.sh — verify which tools from the inventory are actually on PATH.
# Prints [ok]/[MISSING] per tool and a summary; exit 0 always (it's a report).
# Run it after installing new tools to refresh your view of what's available.
set -u
PREFIX="${BB_PREFIX:-$HOME}"
export PATH="$PREFIX/go/bin:$PREFIX/.local/bin:$PREFIX/.cargo/bin:/usr/local/bin:/usr/bin:$PATH"

# Curated expected set (matches TOOL_INVENTORY.md). Add tools here as you install them.
GO_TOOLS="subfinder uncover httpx katana naabu dnsx shuffledns mapcidr cdncheck tlsx alterx asnmap interactsh-client nuclei amass assetfinder findomain puredns gau waybackurls hakrawler gospider httprobe ffuf meg gron unfurl anew qsreplace gf Gxss kxss dalfox crlfuzz gitleaks subzy caido-mcp-server"
SYS_TOOLS="nmap masscan sqlmap whatweb wafw00f nikto wpscan massdns dig gobuster feroxbuster wfuzz dirsearch hydra commix searchsploit enum4linux smbclient tshark hashcat exiftool httpie aws jadx apktool jq"
PY_TOOLS="arjun paramspider uro waymore xsstrike dnsgen bbot censys shodan"

present=0; missing=0; miss_list=""
check() {
  for t in $1; do
    if command -v "$t" >/dev/null 2>&1; then
      printf '  [ok]      %s\n' "$t"; present=$((present+1))
    else
      printf '  [MISSING] %s\n' "$t"; missing=$((missing+1)); miss_list="$miss_list $t"
    fi
  done
}

echo "== Go / ProjectDiscovery (~/go/bin) =="; check "$GO_TOOLS"
echo "== System (apt / /usr/bin) ==";          check "$SYS_TOOLS"
echo "== Python (pipx / ~/.local/bin) ==";     check "$PY_TOOLS"
echo
echo "present=$present missing=$missing"
[ -n "$miss_list" ] && echo "install missing with setup.sh, or: go install / pipx install / apt-get install —$miss_list"
exit 0
