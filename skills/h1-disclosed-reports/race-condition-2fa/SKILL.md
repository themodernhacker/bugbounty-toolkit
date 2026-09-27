---
name: race-condition-2fa
description: Bypass 2FA via a race condition (validate OTP while swapping to a known password / reusing an in-flight session). Teaches racing auth state-transitions for authentication bypass.
sources: hackerone_public
report_count: 1
---

# 2FA / auth bypass via race condition

**Report**: HackerOne — "Bypassing 2FA via race condition" (hackerone.com/reports/2598548). Also Snapchat otp/login+logout account switch (#921780), TFA disable-without-password (#783258).

## Why it matters (the new lesson)
2FA enforcement is often a sequence of steps whose ordering is racy. If you can complete two transitions concurrently (e.g. submit OTP while logging out/in, or change the verified factor while it's being checked), you bypass the step. Test *concurrent* auth-state transitions.

## How it works
Two parallel requests: one submitting an OTP / completing login, another swapping state (change email/phone, logout, bind new factor). The interleaving makes the server trust an unverified state.

## How to hunt for it
1. Map the 2FA/enrollment flow steps.
2. Identify the "commit" and the "change" operations.
3. Fire them concurrently (single-packet) and check whether you land in an authenticated/verified state without the real factor.

## Tooling
- `turbo intruder` (single-packet attack), Burp Intruder, Python threads.

## Fix
Enforce strict step ordering server-side with a state machine; complete the factor-change before reuse; atomic, non-racy session state.
