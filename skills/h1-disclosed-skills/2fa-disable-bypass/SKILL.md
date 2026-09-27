---
name: 2fa-disable-bypass
description: Disabling or changing 2FA without re-authenticating (no password/OTP check) → permanent 2FA bypass. Teaches auditing the 2FA *management* endpoints, not just the login code.
sources: hackerone_public
report_count: 2
---

# 2FA Disable/Change without Password

**Reports**: HackerOne — "Password not checked when disabling 2FA" (#587910); Localize — "2FA can be disabled when logged in without confirming account password" (#783258). Related: HackerOne #1139535 (change 2FA secret without OTP).

## Why it matters (the new lesson)
2FA is only as strong as its *management* endpoints. If an attacker with a stolen (single-factor) session can disable 2FA, change the secret, or regenerate backup codes without re-entering the password or an OTP, 2FA offers no real protection. Audit disable/change/reset, not just login.

## How it works
```
POST /settings/2fa/disable   (no password, no OTP)  → 200
POST /settings/2fa/change-secret (no OTP)           → 200
```

## How to hunt for it
1. Enumerate 2FA endpoints: enable, disable, change, backup-codes, resync, reset.
2. With a valid (but no-MFA) session, call each without password/OTP.
3. Confirm the change persists and login no longer requires 2FA.

## Payloads
```
POST /api/2fa/disable {}
POST /api/2fa/change { secret: <attacker> }
```

## Fix
Require current password or fresh OTP for all 2FA management; step-up auth; notify on changes; verify ownership (email).
