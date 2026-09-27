---
name: smuggling-http2
description: HTTP/2 request smuggling (H2.CL / H2.TE) where a downgrade to HTTP/1.1 at the back-end creates a desync. Teaches HTTP/2-specific smuggling — the modern, still-underreported variant.
sources: hackerone_public
report_count: 1
---

# HTTP/2 Request Smuggling (H2 downgrade desync)

**Report**: Basecamp — "HTTP request smuggling via HTTP/2" (hackerone.com/reports/1211724). Related: Cloudflare Transform-Rules hex-escape HRS (#1478633), Node.js CR-to-hyphen (#922597), Tomcat CVE-2024-21733 (#2327341).

## Why it matters (the new lesson)
HTTP/2 has no `Content-Length`/`Transfer-Encoding` ambiguity, but front-ends that downgrade H2 → H1/1 can *reinstate* CL from the H2 `content-length` pseudo-header, creating H2.CL or H2.TE desyncs that classic CL/TE scanners miss. This is a high-value, under-hunted class.

## How it works
- **H2.CL**: attacker sends H2 with a `content-length` smaller than the body → front-end forwards the leftover bytes as the next request's prefix.
- **H2.TE**: attacker sends a `transfer-encoding: chunked` header over H2; if the back-end honors it, the body is re-chunked.

## How to hunt for it
1. Confirm the front-end speaks H2 but back-end is H1 (downgrade).
2. Send H2 requests with mismatched `content-length` vs body, or inject `transfer-encoding`.
3. Detect desync via timeouts, an injected request that 404s, or a poisoned `:path`/`Host`.
4. Escalate to session/cookie theft (see ato-request-smuggling skill).

## Tooling
- Burp MCP `send_http2_request` (pseudoHeaders + headers + requestBody).
- `http2smugl`, Burp HTTP/2 support, `smuggler.py`.

## Fix
Don't downgrade H2→H1 permissively; reject `content-length`/`transfer-encoding` mismatches; strip H1 framing headers when forwarding H2.
