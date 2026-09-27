---
name: open-redirect-regex-bypass
description: Open-redirect allowlist bypass via regex/domain-validation flaws (prefix/suffix matching, Unicode, path traversal) → 1-click ATO. Teaches the full set of redirect-validator bypass techniques.
sources: hackerone_public
report_count: 1
---

# Open Redirect via Regex/Domain-Validation Bypass → ATO

**Report**: Khan Academy — "1-Click Account Takeover via Open Redirect through Regex Bypass in Domain Validation" (hackerone.com/reports/3723458, critical).

## Why it matters (the new lesson)
Redirect validators usually check that the URL "starts with", "contains", or regex-matches the allowlisted domain. Every such check has a bypass — and if the redirect sits in an auth/OAuth flow, the bypass is an ATO. This is a *technique catalog*, not a single trick.

## How it works
Common allowlist checks and their bypasses:
| Check | Bypass |
|---|---|
| `startsWith('https://allowed.com')` | `https://allowed.com.evil.com`, `https://allowed.com@evil.com` |
| `contains('allowed.com')` | `https://evil.com/?x=allowed.com`, `https://allowed.com.evil.com` |
| regex `allowed\.com` | `allowed.com.evil.com` (missing `$` anchor) |
| exact host | `https://allowed.com//evil.com` (some parsers), `https://allowed.com%2f%2fevil.com` |
| protocol check | `//evil.com`, `https:/\/evil.com`, `https:evil.com`, `\evil.com` |
| path traversal | `https://allowed.com/../evil.com`, `https://allowed.com/%2e%2e/evil.com` |
| Unicode | ideographic full stop `。` (U+3002) in host, Cyrillic homographs |

## How to hunt for it
1. Find the redirect param; submit `https://allowed.com` to learn the validator's rule.
2. Fuzz the bypass catalog above; confirm the Location/redirect follows your domain.
3. If in an auth flow, demonstrate token delivery → ATO.

## Payloads (fuzz set)
```
https://allowed.com.evil.com
https://allowed.com@evil.com
https://evil.com/allowed.com
https://allowed.com//evil.com
https://allowed.com/..//evil.com
https://allowed.com。evil.com
//evil.com
https:\\evil.com
```

## Fix
Parse with a URL library, then **exact-match** the scheme+host (and port) against an allowlist; reject userinfo, backslash, non-ASCII hosts; use a 3xx to a known path only.
