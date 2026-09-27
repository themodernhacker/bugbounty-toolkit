---
name: cache-deception-pii
description: Web Cache Deception — force a CDN to cache a personalized page (with PII/CSRF tokens) under a static-looking URL, then read it back. Teaches the cache-key-vs-origin-routing mismatch.
sources: hackerone_public
report_count: 1
---

# Web Cache Deception (PII / CSRF token exposure)

**Report**: Shopify — "Shopify.com Web Cache Deception to leak PII and CSRF token" (hackerone.com/reports/1271944). Also Algolia PII (#1530066), Discourse ATO via cached CSRF (#260697).

## Why it matters (the new lesson)
If a CDN caches by URL *extension* (`.css`, `.js`, `.png`) but the origin routes by *path* ignoring the extension, you can request `https://target/account/profile.css` — the origin returns your **personalized** `/account/profile` page, and the CDN caches it as static. Anyone who hits that URL later reads your PII.

## How it works
1. Request a sensitive page with a static extension appended: `GET /account/profile.css`.
2. Origin ignores `.css` (or a delimiter like `;`, `%2e`, `?x`) and serves the real page; CDN caches it as static.
3. Fetch the same URL unauthenticated → cached personalized content is returned.

## How to hunt for it
1. Find sensitive pages (profile, settings, orders) behind a CDN.
2. Append `.css`/`.js`/`.png` and delimiters (`;`, `%3f`, `%2e`, `..;/`) and re-request anonymously.
3. Check `X-Cache: HIT` and whether your (victim) data appears.

## Payloads
```
/account/profile.css
/account/profile;/x.css
/account/profile%3f.css
/account/profile..;/x.css
```

## Fix
Disable caching for authenticated responses (`Cache-Control: private, no-store`); make origin respect extensions; `Vary: Cookie`; don't route on static-extension suffix.
