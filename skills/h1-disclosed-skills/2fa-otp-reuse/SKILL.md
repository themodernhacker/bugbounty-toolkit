---
name: 2fa-otp-reuse
description: Reusable OTP / no replay protection on 2FA codes → replay attacks. Teaches verifying that one-time codes are truly single-use and time/attempt-bound.
sources: hackerone_public
report_count: 1
---

# 2FA OTP Reuse (no replay protection)

**Report**: HackerOne — "Improper Authentication — 2FA OTP reusable" (#2529780).

## Why it matters (the new lesson)
TOTP/HOTP codes must be single-use and time-bounded. If the server accepts a code that was already used (or is outside its window, or after it "expired"), an attacker who captures one code can replay it repeatedly → 2FA bypass. Test reuse, window, and expiration.

## How it works
```
POST /2fa/verify { code: "<intercepted valid OTP>" }  → 200
POST /2fa/verify { code: "<same OTP again>" }         → 200  (BUG: should be 401)
```

## How to hunt for it
1. Complete 2FA once; replay the *same* OTP in a second request.
2. Test an OTP just outside its time window (old code).
3. Test the OTP on a different endpoint/session (code not bound to the auth attempt).

## Payloads / flow
Intercept a valid OTP; resend it after success; try it for a different user/session.

## Fix
Mark codes consumed on first use (single-use, server-side); bind code to session/user + attempt; enforce time window; reject replays.
