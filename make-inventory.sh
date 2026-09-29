#!/usr/bin/env bash
# make-inventory.sh — verify which bug-bounty tools are actually on PATH and
# rewrite the "Verified presence" section of TOOL_INVENTORY.md with FOUND (path)
# / MISSING for each. Run after installing new tools.
#
#   bash make-inventory.sh
#
# It checks command -v across your current PATH. Make sure PATH includes your
# tool dirs first (this script exports the standard ones for you).
set -uo pipefail

export PATH="$PATH:$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.foundry/bin:/usr/local/bin:/usr/bin"
INV="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/TOOL_INVENTORY.md"

# Binaries that live on PATH (checked with command -v)
BINS=(
  # toolchains
  go python3 pip3 pipx node npm npx git curl wget jq ruby cargo rustc uv uvx
  # recon: subdomains/dns
  subfinder amass assetfinder findomain chaos github-subdomains gitlab-subdomains
  github-endpoints puredns shuffledns massdns dnsx dnsvalidator dnstake gotator
  alterx subwiz enumerepo analyticsrelationships hakip2host mapcidr asnmap cdncheck
  hakoriginfinder smap subzy crt
  # recon: http/crawl/screens
  httpx httprobe anti-burl tlsx wappalyzer favirecon csprecon katana hakrawler
  gospider gau urlfinder waybackurls waymore gowitness VhostFinder misconfig-mapper
  inscope dsieve unfurl
  # ports/net
  naabu nmap masscan brutespray interactsh-client notify grpcurl
  # content/params/fuzz
  ffuf gobuster dirsearch feroxbuster kr arjun p1radup gf qsreplace uro urless anew
  meg fff gron html-tool cent
  # js/secrets
  getJS subjs jsluice linkfinder xnLinkFinder secretfinder mantra sourcemapper
  roboxtractor trufflehog gitleaks ghleaks gitdorks_go porch-pirate postleaksNg
  # vuln classes
  nuclei vulnx dalfox kxss Gxss xsstrike crlfuzz sqlmap ghauri commix TInjA
  corsy openredirex toxicache nomore403 gopherus second-order shortscan nikto wpscan
  # api/graphql
  kiterunner openapi redocly graphqlmap gqlspection graphql-path-enum sj
  # auth/tokens
  jwt_tool jws
  # cloud
  cloudlist cloud_enum s3scanner aws az docker wafw00f
  # mobile/binary
  jadx apktool objection frida frida-trace frida-ps exiftool
  # web3
  slither solc solc-select forge cast anvil
  # frameworks/utils
  bbot interlace testssl.sh httpie prettier js-beautify
)

# Cloned tools under ~/tools that are run by path, not a PATH binary
declare -A PATHTOOLS=(
  [SSTImap]="$HOME/tools/SSTImap/sstimap.py"
  [ParamSpider]="$HOME/tools/ParamSpider/paramspider.py"
  [XSStrike]="$HOME/tools/XSStrike/xsstrike.py"
  [LinkFinder]="$HOME/tools/LinkFinder/linkfinder.py"
  [SecretFinder]="$HOME/tools/SecretFinder/SecretFinder.py"
  [Corsy]="$HOME/tools/Corsy/corsy.py"
  [Photon]="$HOME/tools/Photon/photon.py"
  [reconftw]="$HOME/tools/reconftw/reconftw.sh"
  [reconftw_ai]="$HOME/tools/reconftw_ai"
  [kiterunner_repo]="$HOME/tools/kiterunner"
  [param-miner]="$HOME/tools/param-miner"
  [msftrecon]="$HOME/tools/msftrecon"
  [Gopherus]="$HOME/tools/Gopherus/gopherus.py"
  [dorks_hunter]="$HOME/tools/dorks_hunter"
  [Gf-Patterns]="$HOME/tools/Gf-Patterns"
)

TMP="$(mktemp)"
found=0; missing=0
{
  echo "## Verified presence"
  echo "_Generated $(date -u '+%Y-%m-%d %H:%M UTC') by make-inventory.sh_"
  echo
  echo "### On PATH"
  for b in $(printf '%s\n' "${BINS[@]}" | sort -u); do
    p="$(command -v "$b" 2>/dev/null || true)"
    if [ -n "$p" ]; then echo "- [x] \`$b\` → $p"; found=$((found+1));
    else echo "- [ ] \`$b\` — MISSING"; missing=$((missing+1)); fi
  done
  echo
  echo "### Cloned repos (run by path)"
  for name in "${!PATHTOOLS[@]}"; do
    path="${PATHTOOLS[$name]}"
    if [ -e "$path" ]; then echo "- [x] \`$name\` → $path";
    else echo "- [ ] \`$name\` — MISSING ($path)"; fi
  done | sort
  echo
  echo "_Summary: $found on-PATH tools found, $missing missing._"
} > "$TMP"

# Replace everything from the "## Verified presence" marker to EOF in the inventory
if grep -q '^## Verified presence' "$INV"; then
  sed -i '/^## Verified presence/,$d' "$INV"
fi
cat "$TMP" >> "$INV"
rm -f "$TMP"
echo "[ok] Updated $INV  ($found found, $missing missing on PATH)"
echo "Tip: anything MISSING you actually want, ask Claude Code to install it:"
echo "     go install / pipx install / apt-get install / git clone into ~/tools"
