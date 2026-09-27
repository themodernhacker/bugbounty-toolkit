---
name: idor-account-recovery-bypass
description: Account takeover via authentication bypass in account-recovery flows — manipulating the identity used in password-reset/recovery to reset another user. Teaches auditing recovery/self-service flows.
sources: hackerone_public
report_count: 1
---

# ATO via Account-Recovery Auth Bypass

**Report**: TikTok — "Account Takeover via Authentication Bypass in TikTok Account Recovery" (#2443228, $12,000).

## Why it matters (the new lesson)
Password-reset / account-recovery is a parallel login path with a different (often weaker) trust model. If the recovery flow can be made to target a different account than the one authenticated (identifier confusion, token not bound to user, "recover by X" where X is attacker-controlled), it becomes a full ATO with no interaction.

## How it works
1. Recovery flow takes a phone/email/username to send a reset link.
2. Attacker manipulates the identifier (or reuses a token across accounts, or the token isn't bound to the account).
3. Attacker completes reset for the *victim's* account.

## How to hunt for it
1. Map recovery flows (email, SMS, security questions, trusted contacts, support).
2. Mutate the account identifier between request/verify steps.
3. Reuse a reset token for a different account; test token-binding and expiry.

## Payloads / flow
```
POST /recover {identifier: victim}  → token
POST /recover/verify {identifier: attacker, token: <victim's>}  → reset victim?
```

## Fix
Bind tokens to a single account + identifier; short expiry; verify identity out-of-band; rate-limit.
