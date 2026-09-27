---
name: csrf-token-validation-bypass
description: CSRF protection bypasses — missing/blank token, token not tied to session, validation disabled, and framework misconfig. Teaches the systematic method for defeating CSRF tokens.
sources: hackerone_public
report_count: 1
---

# CSRF Token Validation Bypass

**Reports**: GitHub — "CSRF protection bypass in GitHub Enterprise management console" (hackerone.com/reports/1497169, high, $10,000); Stripe — "CSRF token validation system disabled on Stripe Dashboard" (#1483327).

## Why it matters (the new lesson)
CSRF is "dead" only if the token is actually validated. The most common high-impact findings are **bypasses**: the token isn't checked, isn't tied to the session, is disabled on specific endpoints, or is absent. Systematically defeating token logic is a repeatable, high-payout technique.

## How it works — bypass checklist
1. **Omit the token entirely** — many endpoints accept requests with no token.
2. **Blank / null**: `csrf_token=` or `csrf_token=null`.
3. **Not session-bound**: submit your own token for the victim's action (token from your account).
4. **Token reuse / not single-use**: replay the same token repeatedly.
5. **Method switch**: POST→GET, or `_method=GET` override.
6. **Header vs cookie mismatch**: some apps only check the *presence* of a header, not its value.
7. **Validation disabled**: feature flags / per-endpoint config (Stripe's case).

## How to hunt for it
1. Capture a state-changing request (password/email change, add collaborator, link account).
2. Run each bypass; confirm the action still executes.
3. For frameworks, look for "CSRF disabled" config or wildcard route exemptions.

## Tooling
Burp Repeater + Intruder; `CSRF` PoC generator; compare token binding across two accounts.

## Fix
Token must be per-session, unguessable, required on all state-changing routes (all methods), and validated server-side with constant-time compare.
