---
name: auth-otp-login-bypass
description: Login as any user via OTP logout/login flow abuse — the login state machine trusts OTP step without verifying it matches the initiating account. Teaches OTP/session-flow state manipulation.
sources: hackerone_public
report_count: 1
---

# Login As Any User via OTP logout/login

**Report**: Snapchat — "Improper Authentication — any user can login as other user with otp/logout & otp/login" (#921780).

## Why it matters (the new lesson)
Multi-step auth flows (OTP login, passwordless, device pairing) are state machines. If the final "authenticated" state doesn't verify that the OTP/step actually belonged to the *initiating* user (no binding between the challenge and the session), you can swap the target mid-flow: start login as victim, finish as yourself — or vice-versa. Authz-by-state-machine bugs are subtle and high-value.

## How it works
1. `POST /otp/logout` / `POST /otp/login` with a phone number → issues a challenge.
2. Change the phone/user identifier between steps; the flow completes for the *other* account.
3. Result: authenticated as an arbitrary user without their OTP.

## How to hunt for it
1. Map OTP/passwordless/phone login flows step by step.
2. Intercept and mutate the account identifier between steps; observe whose session results.
3. Test reusing/omitting the challenge, or swapping user IDs in the final verify.

## Payloads / flow
```
POST /otp/request {phone: victim}   → challenge
POST /otp/verify {phone: attacker, code: <attacker's>}  → logged in as victim?
```

## Fix
Bind each step (challenge id, phone, user) together in server-side state; never trust client-supplied identifiers mid-flow.
