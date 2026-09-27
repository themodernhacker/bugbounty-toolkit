# Bug Bounty Tool Inventory (Kali container)

## PATH setup (run first in any new chat)
export PATH="$PATH:/root/go/bin:/usr/local/go/bin:/opt/venv/bin:/root/.local/bin"

## Go binaries — /root/go/bin/
subfinder chaos uncover httpx katana naabu dnsx shuffledns mapcidr cdncheck tlsx
alterx asnmap interactsh-client nuclei amass assetfinder findomain haktrails
puredns gau waybackurls getJS hakrawler gospider httprobe ffuf meg gron fff
unfurl anew qsreplace gf html-tool anti-burl Gxss kxss dalfox crlfuzz gitleaks
subzy cloudlist kr

## System tools — /usr/bin (apt)
nmap masscan sqlmap whatweb wafw00f nikto wpscan amass massdns dig host nslookup
gobuster feroxbuster wfuzz dirsearch hydra commix msfconsole searchsploit
enum4linux smbclient onesixtyone tcpdump tshark hashcat exiftool httpie aws
jadx apktool strings objdump radare2 gdb gcc jq curl wget git ruby java
john=/usr/sbin/john ; dex2jar=d2j-dex2jar.sh

## Python tools — /opt/venv/bin
arjun paramspider uro waymore xsstrike dnsgen bbot censys shodan
impacket: secretsdump.py ntlmrelayx.py mimikatz.py getTGT.py getST.py smbexec.py wmiexec.py psexec.py
pwntools: pwn checksec ROPgadget shellcraft ; scapy ; ldapdomaindump

## npm/global — /usr/local/bin
js-beautify html-beautify css-beautify prettier esparse esvalidate swagger-cli postman trufflehog

## Cloned repos — /root/tools/
Corsy Gopherus GraphQLmap LinkFinder OpenRedireX ParamSpider Photon S3Scanner
SecretFinder xnLinkFinder XSStrike jwt_tool waybackrobots xsshunter
blind-ssrf-chains can-i-take-over-xyz cloud_enum github-dorks reconftw axiom

## Wordlists
/root/wordlists/OneListForAll  /root/wordlists/PayloadsAllTheThings  /root/wordlists/fuzzdb
/usr/share/seclists  /usr/share/wordlists/rockyou.txt.gz (gunzip first)  /usr/share/dirb/wordlists

## gf patterns — /root/.gf
debug_logic idor img-traversal interestingEXT interestingparams interestingsubs
jsvar lfi rce redirect sqli ssrf ssti xss

## Burp MCP
Host 172.17.0.1:9876 (Docker gateway). Client: /work/burp_client.py (27 tools).
Handshake: Host: localhost:9876 + Origin: http://localhost:9876 -> GET / -> SSE
sessionId -> POST /?sessionId=<id>.

## API keys (installed but need config)
subfinder->~/.config/subfinder/provider-config.yaml ; uncover->~/.config/uncover/
chaos->env CHAOS_KEY ; haktrails->SecurityTrails key ; shodan init <key> ;
censys configure ; aws configure ; nuclei -update-templates (first run)
