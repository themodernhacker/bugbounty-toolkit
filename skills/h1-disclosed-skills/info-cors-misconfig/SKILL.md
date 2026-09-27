---
name: info-cors-misconfig
description: CORS misconfiguration → sensitive data exposure (reflected Origin, wildcard + credentials, null origin). Teaches detecting and exploiting permissive CORS.
sources: hackerone_public
report_count: 1
---

# CORS Misconfiguration → Sensitive Data Exposure

**Report**: U.S. DoD — "Bypassing CORS Misconfiguration Leads to Sensitive Exposure" (#768151).

## Why it matters (the new lesson)
CORS is an *opt-in* relaxation of the same-origin policy. Misconfigured CORS — echoing arbitrary `Origin` with `Access-Control-Allow-Credentials: true`, allowing `null` origin, or wildcard-with-credentials — lets a malicious page read a victim's authenticated API responses (PII, tokens). It's the classic "read other people's data from your browser" bug.

## How it works
1. Attacker page at `https://evil.com` issues `fetch('https://target/api/me', {credentials:'include'})` with `Origin: https://evil.com`.
2. Server responds `Access-Control-Allow-Origin: https://evil.com` + `Allow-Credentials: true` → browser delivers the response.

## How to hunt for it
1. Send `Origin: https://evil.com` (and `Origin: null`) to API endpoints; inspect CORS headers.
2. Check `Access-Control-Allow-Origin` reflection + `Access-Control-Allow-Credentials: true`.
3. Test `null` (sandboxed iframe), subdomain-prefix (`evil.target.com`), and wildcard `*` with credentials.

## Payloads / flow
```
Origin: https://evil.com          → ACAO: https://evil.com, ACAC: true  (VULN)
Origin: null                      → ACAO: null (VULN via sandboxed iframe)
```

## Fix
Allowlist exact origins; never reflect arbitrary Origin with credentials; don't use `null`/`*` with credentials.
