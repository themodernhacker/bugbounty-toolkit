---
name: 2fa-session-persist
description: Pre-2FA sessions remaining valid after MFA activation (no forced logout/expiry) → 2FA bypass. Teaches checking whether enabling 2FA revokes existing sessions.
sources: hackerone_public
report_count: 1
---

# 2FA Bypass: Old Sessions Stay Valid After Enabling MFA

**Report**: Superhuman (Grammarly) — "Previously created sessions remain valid after MFA activation" (#667739). Related: SideFX #2234736, Nextcloud #486693.

## Why it matters (the new lesson)
When a user enables 2FA, the app must **invalidate all existing sessions/tokens**; otherwise an attacker with a pre-stolen session cookie stays logged in — 2FA is cosmetic. The same flaw shows up after password reset (session should expire). Test the *transition* moments.

## How it works
1. Attacker has a victim's session cookie (or a device is compromised).
2. Victim enables 2FA — but the app doesn't revoke old sessions.
3. Attacker's cookie still works → full account access, 2FA never prompted.

## How to hunt for it
1. Open two sessions (S1, S2) for the same account.
2. Enable 2FA / change password / reset password from S1.
3. Confirm S2 still works without re-auth.

## Payloads / test flow
Enable 2FA → reuse the pre-2FA `session` cookie on a fresh request → observe 200 vs 401.

## Fix
Invalidate all sessions + refresh tokens on MFA enable/disable, password change, and reset; version sessions; short-lived tokens.
