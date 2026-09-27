---
name: ato-passwordless-signup
description: Change any user's password via a passwordless-signup endpoint that doesn't validate the account isn't already owned. Teaches account-claiming/id-confusion flaws in signup/passwordless flows.
sources: hackerone_public
report_count: 1
---

# ATO via passwordless-signup account claim

**Report**: Uber — "Change any Uber user's password via /rt/users/passwordless-signup" (hackerone.com/reports/143717). Related: OTP login/logout account-switch (Snapchat #921780), Shopify partner email-confirmation bypass (#300305).

## Why it matters (the new lesson)
Signup and "passwordless login" endpoints sometimes create or claim an account by identifier (email/phone) without verifying the caller actually controls it — or allow re-registering an existing account to bind your own credential. Test account-state-transition logic, not just classic reset flows.

## How it works
`POST /rt/users/passwordless-signup` with an existing victim's phone/email created a new session/credential for that identifier, or allowed resetting its password because the endpoint didn't distinguish "new" vs "existing" account ownership.

## How to hunt for it
1. Map signup, passwordless/OTP login, phone/email-change, and "login with X" endpoints.
2. Submit a victim identifier (or your own identifier that collides) and see if you can set a password/token for it.
3. Test identity-confusion: same email+phone, case/Unicode variants (`user@x.com` vs `USER@x.com`), `+alias`, unicode-normalization (IDN).

## Fix
Require proof-of-ownership for account creation/claim (verified email/phone); never reset credentials on signup; normalize identifiers consistently.
