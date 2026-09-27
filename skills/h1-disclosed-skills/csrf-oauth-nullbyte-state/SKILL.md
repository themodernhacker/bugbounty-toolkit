---
name: csrf-oauth-nullbyte-state
description: One-click account takeover via OAuth CSRF bypass using a null byte in the state parameter. Teaches state-parameter CSRF in OAuth flows and null-byte/validation-mismatch tricks.
sources: hackerone_public
report_count: 1
---

# 1-Click ATO via OAuth CSRF (null byte in `state`)

**Report**: Logitech — "One Click Account takeover using OAuth CSRF bypass by adding Null byte %00 in state parameter on www.streamlabs.com" (hackerone.com/reports/1046630, medium, $200, CSRF).

## Why it matters (the new lesson)
OAuth flows use `state` to prevent CSRF (binding the authorization to the initiating session). If the provider validates `state` but the *consuming app* compares it loosely (or truncates at a null byte / has a parsing mismatch), you can force a victim to authorize your account → login CSRF → account linking takeover.

## How it works
1. Attacker starts OAuth, captures their own `state`.
2. Crafts a link with `state=<validstate>%00<attacker>` (or `&state=` duplication / case / encoding variant).
3. Victim clicks; provider accepts (sees valid prefix), app binds to attacker's session → victim's account linked to attacker.

## How to hunt for it
1. Map OAuth/social login; note how `state` is generated and validated on callback.
2. Test `state` variants: `%00`, duplicate `state=`, `state=a&state=b`, case, URL-encoding, unicode.
3. Confirm the callback binds to the *attacker's* session instead of the victim's.

## Payloads
```
state=valid%00attacker
state=valid&state=attacker
state=Valid (case change)
```

## Fix
Generate cryptographically random, server-stored `state`; compare with constant-time exact match (no truncation); reject extra/null bytes.
