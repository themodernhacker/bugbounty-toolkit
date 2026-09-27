---
name: recon-dns-enum-zone-transfer
description: Subdomain enumeration and DNS zone transfer (AXFR) — the foundational recon step that surfaces the attack surface. Teaches passive+active subdomain discovery and misconfigured AXFR.
sources: hackerone_public
report_count: 1
---

# Subdomain Enumeration & DNS Zone Transfer

**Sources**: core recon technique; passive sources include crt.name, chaos, Shodan/Censys, wayback, GitHub.

## Why it matters (the new lesson)
Your attack surface = every subdomain. Subdomains host staging/legacy/internal services that are less hardened and more likely to be vulnerable. A misconfigured DNS server that allows **zone transfer (AXFR)** hands you the *complete* list in one query.

## How it works
```bash
# passive
subfinder -d target.com -all -o subs.txt
assetfinder --subs-only target.com | tee -a subs.txt
curl -s "https://crt.name/v1/search?apex=target.com" | tee -a subs.txt
amass enum -passive -d target.com
# active brute
shuffledns -d target.com -w wordlist.txt -r resolvers.txt -silent
# zone transfer attempt
dig axfr target.com @ns1.target.com
```

## How to hunt for it
1. Passive: subfinder/assetfinder/chaos/crt.name/amass → dedupe (`anew`).
2. Resolve: `dnsx -resp -a -cname` / `puredns resolve`; identify live hosts (`httpx`).
3. Zone transfer: enumerate NS, try `dig axfr @<each-ns> <domain>`.
4. Feed live hosts to nuclei/httpx; look for the soft spots (staging, dev, admin).

## Tooling
`subfinder`, `assetfinder`, `amass`, `chaos`, `crt.name`, `dnsx`, `shuffledns`/`puredns`, `massdns`, `httpx`, `katana`.

## Fix
Restrict AXFR to trusted secondary servers; monitor cert/CT logs; decommission unused subdomains; don't expose internal hostnames in certs.
