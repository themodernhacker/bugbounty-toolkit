#!/usr/bin/env bash
# setup.sh — idempotent install of the bug-bounty toolset for Kali Linux.
# Safe to re-run: skips anything already installed. Logs to ./setup.log.
# Paths are $HOME-based (override the base with BB_PREFIX=/some/dir).
set -u
export DEBIAN_FRONTEND=noninteractive

# --- paths (Kali, user home) -------------------------------------------------
PREFIX="${BB_PREFIX:-$HOME}"
export PATH="$PREFIX/go/bin:$PREFIX/.local/bin:$PREFIX/.cargo/bin:/usr/local/bin:/usr/bin:$PATH"
TOOLS="$PREFIX/tools"
WORDLISTS="$PREFIX/wordlists"
GF_DIR="$PREFIX/.gf"
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGFILE="$REPO/setup.log"
mkdir -p "$PREFIX/go/bin" "$TOOLS" "$WORDLISTS" "$GF_DIR"
exec >> "$LOGFILE" 2>&1

# use sudo only when not already root
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"

echo "=== setup start $(date) (prefix=$PREFIX) ==="

have() { command -v "$1" >/dev/null 2>&1; }
gi() { # gi <name> <import-path>
  local name="$1" pkg="$2"
  have "$name" && { echo "[skip] $name"; return; }
  echo "[install] $name"
  go install "$pkg" || echo "[FAIL] $name"
}
clone() { # clone <url> <dest>
  [ -d "$2" ] && { echo "[skip] $2"; return; }
  echo "[clone] $2"
  git clone --depth 1 "$1" "$2" || echo "[FAIL] $2"
}

# --- 1) apt system packages ---
$SUDO apt-get update -y
$SUDO apt-get install -y --no-install-recommends \
  git curl wget jq python3 python3-pip python3-venv pipx unzip \
  massdns dnsutils bind9-dnsutils \
  whatweb wafw00f \
  feroxbuster wfuzz gobuster \
  nikto wpscan sqlmap \
  nmap masscan hydra \
  exiftool httpie awscli \
  seclists \
  jadx apktool dex2jar

if ! have go; then
  echo "[!] go missing — install with: $SUDO apt-get install -y golang-go (or from golang.org)"
fi

# --- 2) Go tools (projectdiscovery + core) ---
gi subfinder github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
gi amass github.com/owasp-amass/amass/v4/...@master
gi assetfinder github.com/tomnomnom/assetfinder@latest
gi findomain github.com/findomain/findomain@latest
gi haktrails github.com/hakluke/haktrails@latest
gi chaos github.com/projectdiscovery/chaos-client/cmd/chaos@latest
gi shuffledns github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
gi puredns github.com/d3mondev/puredns/v2@latest
gi dnsx github.com/projectdiscovery/dnsx/cmd/dnsx@latest
gi alterx github.com/projectdiscovery/alterx/cmd/alterx@latest
gi naabu github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
gi nuclei github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
gi httpx github.com/projectdiscovery/httpx/cmd/httpx@latest
gi katana github.com/projectdiscovery/katana/cmd/katana@latest
gi uncover github.com/projectdiscovery/uncover/cmd/uncover@latest
gi mapcidr github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
gi cdncheck github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest
gi tlsx github.com/projectdiscovery/tlsx/cmd/tlsx@latest
gi asnmap github.com/projectdiscovery/asnmap/cmd/asnmap@latest
gi interactsh-client github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest
gi cloudlist github.com/projectdiscovery/cloudlist/cmd/cloudlist@latest

# --- 3) Go tools (URL discovery / crawling) ---
gi gau github.com/lc/gau/v2/cmd/gau@latest
gi waybackurls github.com/tomnomnom/waybackurls@latest
gi getJS github.com/003random/getJS@latest
gi hakrawler github.com/hakluke/hakrawler@latest
gi gospider github.com/jaeles-project/gospider@latest
gi httprobe github.com/tomnomnom/httprobe@latest

# --- 4) Go tools (fuzzing / utils / injection) ---
gi ffuf github.com/ffuf/ffuf/v2@latest
gi meg github.com/tomnomnom/meg@latest
gi gron github.com/tomnomnom/gron@latest
gi fff github.com/tomnomnom/fff@latest
gi unfurl github.com/tomnomnom/unfurl@latest
gi anew github.com/tomnomnom/anew@latest
gi qsreplace github.com/tomnomnom/qsreplace@latest
gi gf github.com/tomnomnom/gf@latest
gi html-tool github.com/tomnomnom/hacks/html-tool@latest
gi anti-burl github.com/tomnomnom/hacks/anti-burl@latest
gi Gxss github.com/KathanP19/Gxss@latest
gi kxss github.com/hahwul/kxss@latest
gi dalfox github.com/hahwul/dalfox/v2@latest
gi crlfuzz github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest
gi gitleaks github.com/zricethezav/gitleaks/v8@latest
gi subzy github.com/PentestPad/subzy@latest

# --- 5) Python tools (pipx) ---
for p in arjun uro bbot dnsgen shodan censys; do
  have "$p" && { echo "[skip] $p"; continue; }
  echo "[install] $p"
  pipx install "$p" || echo "[FAIL] $p"
done

# --- 6) trufflehog (official release installer) ---
if ! have trufflehog; then
  echo "[install] trufflehog"
  curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh \
    | $SUDO sh -s -- -b /usr/local/bin || echo "[FAIL] trufflehog"
fi

# --- 7) kiterunner (clone + build) ---
if ! have kr; then
  echo "[install] kiterunner"
  clone https://github.com/assetnote/kiterunner.git "$TOOLS/kiterunner"
  (cd "$TOOLS/kiterunner" && go build -o "$PREFIX/go/bin/kr" ./cmd/kiterunner) || echo "[FAIL] kr build"
fi

# --- 8) clones / frameworks ---
clone https://github.com/1ndianl33t/Gf-Patterns.git "$TOOLS/Gf-Patterns"
clone https://github.com/devanshbatham/ParamSpider.git "$TOOLS/ParamSpider"
clone https://github.com/s0md3v/Photon.git "$TOOLS/Photon"
clone https://github.com/xnl-h4ck3r/xnLinkFinder.git "$TOOLS/xnLinkFinder"
clone https://github.com/GerbenJavado/LinkFinder.git "$TOOLS/LinkFinder"
clone https://github.com/m4ll0k/SecretFinder.git "$TOOLS/SecretFinder"
clone https://github.com/s0md3v/Corsy.git "$TOOLS/Corsy"
clone https://github.com/devanshbatham/OpenRedireX.git "$TOOLS/OpenRedireX"
clone https://github.com/swisskyrepo/GraphQLmap.git "$TOOLS/GraphQLmap"
clone https://github.com/ticarpi/jwt_tool.git "$TOOLS/jwt_tool"
clone https://github.com/initstring/cloud_enum.git "$TOOLS/cloud_enum"
clone https://github.com/sa7mon/S3Scanner.git "$TOOLS/S3Scanner"
clone https://github.com/techgaun/github-dorks.git "$TOOLS/github-dorks"
clone https://github.com/EdOverflow/can-i-take-over-xyz.git "$TOOLS/can-i-take-over-xyz"
clone https://github.com/assetnote/blind-ssrf-chains.git "$TOOLS/blind-ssrf-chains"
clone https://github.com/tarunkant/Gopherus.git "$TOOLS/Gopherus"
clone https://github.com/mhmdiaa/waybackrobots.git "$TOOLS/waybackrobots"
clone https://github.com/mandatoryprogrammer/xsshunter.git "$TOOLS/xsshunter"
clone https://github.com/s0md3v/XSStrike.git "$TOOLS/XSStrike"

# --- 9) wordlists ---
clone https://github.com/swisskyrepo/PayloadsAllTheThings.git "$WORDLISTS/PayloadsAllTheThings"
clone https://github.com/fuzzdb-project/fuzzdb.git "$WORDLISTS/fuzzdb"
clone https://github.com/six2dez/OneListForAll.git "$WORDLISTS/OneListForAll"

# --- 10) gf patterns + nuclei templates ---
cp -n "$TOOLS/Gf-Patterns"/*.json "$GF_DIR"/ 2>/dev/null || true
nuclei -update-templates 2>/dev/null || true

# --- 11) toolkit extras ---
# FastMCP for the openapi-to-mcp skill (turn a target's OpenAPI spec into tools)
pip install fastmcp httpx --break-system-packages 2>/dev/null || \
  pip3 install fastmcp httpx --break-system-packages 2>/dev/null || true
# scope.py / state.py are pure-Python (stdlib only) — just make everything executable
chmod +x "$REPO"/scope.py "$REPO"/state.py "$REPO"/*.sh 2>/dev/null || true
echo "[ok] fastmcp installed; scope.py/state.py + shell scripts marked executable"

echo "=== setup done $(date) ==="
echo
echo "Add to ~/.zshrc so tools stay on PATH (user dirs FIRST, so ~/go/bin/httpx"
echo "wins over Kali's /usr/bin/httpx python client):"
echo '  export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH"'
echo '  export TOOLS="$HOME/tools"'
echo '  export WORDLISTS="$HOME/wordlists"'
