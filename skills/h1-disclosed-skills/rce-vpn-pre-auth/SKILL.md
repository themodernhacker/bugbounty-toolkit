---
name: rce-vpn-pre-auth
description: Pre-auth RCE on SSL VPN / Pulse Secure / Fortinet devices via known CVEs. Teaches targeting VPN gateways and matching device fingerprints to known RCE CVEs.
sources: hackerone_public
report_count: 1
---

# Pre-Auth RCE on VPN Gateways

**Report**: X (Twitter) — "Potential pre-auth RCE on Twitter VPN" (#591295, $20,160). Related: Uber SSL VPN pre-auth RCE (#540242).

## Why it matters (the new lesson)
Perimeter VPN/SSL-VPN devices (Pulse Secure, Fortinet, Citrix, Cisco AnyConnect, Ivanti) are internet-facing and riddled with pre-auth RCEs (path traversal → file read → RCE). One vulnerable gateway = full network access. These are some of the highest-payout and most impactful bugs in a scope.

## How it works
- Pulse Secure: CVE-2019-11510 (pre-auth arbitrary file read) → `/etc/passwd`, `cacerts` → RCE chain.
- Fortinet: CVE-2018-13379 (path traversal → VPN creds), CVE-2022-42475 (heap overflow).
- Citrix: CVE-2019-19781 (path traversal → RCE).

## How to hunt for it
1. Fingerprint VPN devices (title, `/dana-na/`, `/remote/login`, `/vpn/index.html`, headers, favicon).
2. Match to CVE list; test the known pre-auth read/RCE payloads.
3. Verify without causing damage; report with full chain.

## Payloads / tools
```
GET /dana-na/../dana-na/auth/url_default/welcome.cgi  (Pulse)
GET /remote/fgt_lang?lang=/../../../..//////////etc/passwd  (Fortinet)
```
Nuclei `cves/` templates; `pulse-exploit`, `citrix` metasploit modules.

## Fix
Patch immediately; MFA on VPN; restrict to IP allowlists; monitor for exploitation.
