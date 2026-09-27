#!/bin/bash
echo "===== IDENTITY / OS ====="
id; whoami; uname -a
cat /etc/os-release 2>/dev/null | grep -E '^(NAME|VERSION|ID)=' 
echo
echo "===== TOOLCHAINS ====="
for t in go python3 pip3 pip pipx node npm npx git curl wget make gcc jq ruby gem java cargo rustc; do
  p=$(command -v $t 2>/dev/null)
  if [ -n "$p" ]; then echo "FOUND  $t -> $p ($($t --version 2>&1 | head -1))"; else echo "MISSING $t"; fi
done
echo
echo "===== GO ENV ====="
go env GOPATH GOBIN GOPROXY GO111MODULE 2>/dev/null
echo
echo "===== APT / SUDO ====="
command -v apt-get >/dev/null && echo "apt-get: FOUND" || echo "apt-get: MISSING"
sudo -n true 2>/dev/null && echo "sudo: passwordless OK" || echo "sudo: NOT available (running as root?)"
echo
echo "===== NETWORK ====="
curl -s -o /dev/null -w "github.com -> %{http_code}\n" --max-time 8 https://github.com || echo "github.com unreachable"
curl -s -o /dev/null -w "proxy.golang.org -> %{http_code}\n" --max-time 8 https://proxy.golang.org || echo "goproxy unreachable"
curl -s -o /dev/null -w "pypi.org -> %{http_code}\n" --max-time 8 https://pypi.org || echo "pypi unreachable"
curl -s -o /dev/null -w "registry.npmjs.org -> %{http_code}\n" --max-time 8 https://registry.npmjs.org || echo "npm unreachable"
echo
echo "===== EXISTING TOOLS CHECK ====="
for t in subfinder chaos uncover httpx katana naabu dnsx shuffledns mapcidr cdncheck tlsx alterx asnmap wappalyzer interactsh nuclei vulnx assetfinder waybackurls gf anew unfurl qsreplace httprobe dnsgen meg gron fff amass findomain haktrails puredns massdns gau getJS hakrawler gospider ffuf gobuster feroxbuster wfuzz dirsearch arjun paramspider uro dalfox kxss Gxss xsstrike sqlmap ghauri jwt-tool nmap whatweb wafw00f nikto wpscan seclists masscan hydra jaeles bbot; do
  p=$(command -v $t 2>/dev/null)
  if [ -n "$p" ]; then echo "FOUND  $t -> $p"; fi
done
echo "(end of existing tools list)"
echo
echo "===== WORDLISTS / DIRS ====="
ls -d /usr/share/seclists /usr/share/wordlists ~/tools ~/BugBounty /work 2>/dev/null
echo
echo "===== DISK / MEM ====="
df -h / | tail -1; free -h | head -2
