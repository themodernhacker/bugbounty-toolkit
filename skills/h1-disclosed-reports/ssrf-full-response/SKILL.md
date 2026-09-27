---
name: ssrf-full-response
description: "Full-response SSRF" where the fetched body is returned to the attacker — turning SSRF from blind into a read primitive over internal HTTP. Teaches how to identify and maximize full-read SSRF via URL fetchers and proxies.
sources: hackerone_public
report_count: 1
---

# Full-Response (Read) SSRF

**Report**: Dropbox — "Full Response SSRF via Google Drive" (hackerone.com/reports/1406938), and "Full read SSRF in www.evernote.com (AWS metadata + LFI)" (Evernote #1189367).

## Why it matters (the new lesson)
Most SSRF is "blind" (connection made, response hidden). If the fetched content is returned (proxy-like feature, image/pdf renderer, "preview" that echoes body), you get a **full-read SSRF**: you can read internal HTTP responses, cloud metadata, and even local files (`file://`), which is far more valuable and directly escalates to credential/secret theft.

## How it works
A "fetch this URL and show the result" feature (doc import, thumbnail service, link unfurl, "load image from URL") returns the remote body. Point it at metadata endpoints and read the keys inline.

## How to hunt for it
1. Find URL-fetch features and check whether the response body comes back in the page/API response.
2. If yes → test `http://169.254.169.254/...`, `http://metadata.google.internal/...`, `file:///etc/passwd`, and internal endpoints.
3. Chain: read creds → use creds against internal/admin API.

## Payloads
```
http://169.254.169.254/latest/meta-data/          # list
http://169.254.169.254/latest/meta-data/iam/security-credentials/<role>
file:///etc/passwd
file:///proc/self/environ
http://localhost:8080/actuator/env
```

## Fix
Never return fetched bodies to the user; block internal/link-local/file schemes; egress allowlist.
