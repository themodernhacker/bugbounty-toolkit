---
name: sso-jwt-client-side
description: SSO via JWT generated client-side (or signed with a weak/known key) → forge any user. Teaches auditing JWT-based SSO for `alg:none`, weak secrets, and client-side signing.
sources: hackerone_public
report_count: 1
---

# SSO via Client-Side / Weakly-Signed JWT

**Report**: Trint — "Insecure Zendesk SSO implementation by generating JWT client-side" (#638635).

## Why it matters (the new lesson)
SSO portals sometimes mint the JWT **in the browser** (or sign with a weak/hardcoded/known secret). If the secret ships client-side or the `alg` can be flipped to `none`/HS256-with-public-key, you can forge tokens for any user/role → complete SSO bypass. The JWT becomes a "write your own identity" primitive.

## How it works
1. Find the JWT secret in JS (`jwt.sign(..., 'SECRET')`), or a hardcoded key.
2. Re-sign a token with `sub`/`email`/`role` = victim-admin.
3. Or flip `alg` to `none` and strip the signature (if server accepts).

## How to hunt for it
1. Capture the SSO JWT; decode header/payload (jwt.io).
2. Test `alg:none`, `alg:HS256` with the public key, weak secret (`secret`, empty).
3. Grep JS for `jwt.sign`/`jsonwebtoken`/hardcoded keys.

## Payloads / tools
```
jwt_tool / jwttool -- crack, forge (none, HMAC)
{"alg":"none","typ":"JWT"}.{"sub":"admin"}.
```

## Fix
Mint tokens server-side; use strong secret/RS256; reject `none`/HS↔RS confusion; validate `sub`/`aud`/`exp`.
