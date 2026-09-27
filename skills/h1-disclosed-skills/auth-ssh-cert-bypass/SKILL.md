---
name: auth-ssh-cert-bypass
description: Authentication bypass via SSH certificates / trust-on-first-use flaws — mis-issued or overly-broad SSH certs grant access as any user. Teaches auditing SSH cert CA/principal trust.
sources: hackerone_public
report_count: 1
---

# Auth Bypass via SSH Certificates

**Report**: GitHub — "Authentication bypass on gist.github.com through SSH Certificates" (#1901040, $10,000).

## Why it matters (the new lesson)
SSH certificate authentication trusts a CA to sign certs with `principals` (usernames). If the CA is too permissive (signs arbitrary principals, or `validPrincipals` isn't checked, or an attacker can obtain a cert for a wildcard/`*` principal), they can `ssh` as any user — including service/`git` accounts with privileged access. This bypasses password/2FA entirely.

## How it works
1. Attacker obtains a cert (or causes one to be issued) with `principals=*` or a target username.
2. `ssh -i user-cert git@gist.github.com` → accepted as the target user.

## How to hunt for it
1. Identify SSH cert endpoints / trust config (`TrustedUserCAKeys`, `AuthorizedPrincipalsFile`).
2. Check if you can request certs for arbitrary `principals`, or whether `validPrincipals` is enforced.
3. Test connecting with a crafted cert for other users.

## Payloads / flow
```
ssh-keygen -s ca -I attacker -n victim -V +1d attacker.pub   (if CA is weak/exposed)
ssh -i attacker-cert git@target
```

## Fix
Restrict `validPrincipals` to the authenticated user; enforce at CA issuance; least-privilege service accounts; short validity.
