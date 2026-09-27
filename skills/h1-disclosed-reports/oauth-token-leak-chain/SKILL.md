---
name: oauth-token-leak-chain
description: Chain of bugs to leak a victim's OAuth token (e.g. Referer leakage + a redirect + a login flow). Teaches chaining low-severity issues into full token theft / ATO.
sources: hackerone_public
report_count: 1
---

# OAuth token theft via chained bugs (Referer leak)

**Report**: Uber — "Chained Bugs to Leak Victim's Uber FB OAuth Token" (hackerone.com/reports/202781). Also Rockstar FB OAuth theft via screenshot/referer (#488269, #787160).

## Why it matters (the new lesson)
OAuth tokens leak in the `Referer` header when a page with the token in its URL loads any third-party resource or external link. Chaining an open redirect / mixed content / a resource-load with a token-bearing URL converts a "low" info leak into full account takeover.

## How it works
1. The OAuth callback URL contains `?code=...` (or `?access_token=...`).
2. The page served there loads an `<img>`/`<script>`/redirect to an attacker host — the browser sends the full URL (with token) in `Referer`.
3. Attacker reads the token from their logs → ATO.

## How to hunt for it
1. Trigger OAuth flows and watch where `code`/`token` appears in URLs.
2. On those pages, find any third-party resource load or redirect (open redirect, analytics, CDN) and check the `Referer` sent.
3. Also test `Referrer-Policy` and mixed content downgrades that strip it.

## Tooling
- Burp (watch Referer), browser devtools, collaborator to capture incoming Referer values.

## Fix
Use PKCE + token exchange (code → token via POST, never in URL); fragment-based response_type for implicit; `Referrer-Policy: no-referrer`; one-time, short-lived codes.
