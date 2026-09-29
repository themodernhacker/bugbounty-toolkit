# Bug Bounty Tool Inventory (Kali, user home)

## PATH setup (run first in any new session)
User dirs go FIRST so `~/go/bin/httpx` (ProjectDiscovery) wins over Kali's
`/usr/bin/httpx` (a Python HTTP client; the security build is `httpx-toolkit`):
```bash
export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH"
export TOOLS="$HOME/tools"; export WORDLISTS="$HOME/wordlists"
```

## Go binaries — ~/go/bin/
subfinder chaos uncover httpx katana naabu dnsx shuffledns mapcidr cdncheck tlsx
alterx asnmap interactsh-client nuclei amass assetfinder findomain haktrails
puredns gau waybackurls getJS hakrawler gospider httprobe ffuf meg gron fff
unfurl anew qsreplace gf html-tool anti-burl Gxss kxss dalfox crlfuzz gitleaks
subzy cloudlist kr caido-mcp-server

## System tools — /usr/bin (apt)
nmap masscan sqlmap whatweb wafw00f nikto wpscan amass massdns dig host nslookup
gobuster feroxbuster wfuzz dirsearch hydra commix msfconsole searchsploit
enum4linux smbclient onesixtyone tcpdump tshark hashcat exiftool httpie aws
jadx apktool strings objdump radare2 gdb gcc jq curl wget git ruby java
john=/usr/sbin/john ; dex2jar=d2j-dex2jar.sh
(prefer ~/go/bin/httpx over /usr/bin/httpx)

## Python tools — ~/.local/bin (pipx)
arjun paramspider uro waymore xsstrike dnsgen bbot censys shodan
impacket: secretsdump.py ntlmrelayx.py mimikatz.py getTGT.py getST.py smbexec.py wmiexec.py psexec.py
pwntools: pwn checksec ROPgadget shellcraft ; scapy ; ldapdomaindump

## npm/global — /usr/local/bin
js-beautify html-beautify css-beautify prettier esparse esvalidate swagger-cli postman trufflehog

## Cloned repos — ~/tools/
Corsy Gopherus GraphQLmap LinkFinder OpenRedireX ParamSpider Photon S3Scanner
SecretFinder xnLinkFinder XSStrike jwt_tool waybackrobots xsshunter
blind-ssrf-chains can-i-take-over-xyz cloud_enum github-dorks reconftw axiom

## Wordlists
~/wordlists/OneListForAll  ~/wordlists/PayloadsAllTheThings  ~/wordlists/fuzzdb
/usr/share/seclists  /usr/share/wordlists/rockyou.txt.gz (gunzip first)  /usr/share/dirb/wordlists

## gf patterns — ~/.gf
debug_logic idor img-traversal interestingEXT interestingparams interestingsubs
jsvar lfi rce redirect sqli ssrf ssti xss

## Burp MCP
Cross-container: Host 172.17.0.1:9876 (Docker gateway). Fallback client:
`python3 burp_client.py <tool> [json]` (in this repo). Same-host: 127.0.0.1:9876.
Handshake: Host: localhost:9876 + Origin: http://localhost:9876 -> GET / -> SSE
sessionId -> POST /?sessionId=<id>. Full wiring: ROUTER.md §C.

## API keys (installed but need config)
subfinder->~/.config/subfinder/provider-config.yaml ; uncover->~/.config/uncover/
chaos->env CHAOS_KEY ; haktrails->SecurityTrails key ; shodan init <key> ;
censys configure ; aws configure ; nuclei -update-templates (first run)
