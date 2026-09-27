---
name: sso-email-confirmation-bypass
description: Email-confirmation bypass in SSO/partner flows → full privilege escalation to any tenant/owner. Teaches the classic "bypass email verification in SSO to claim a tenant" attack.
sources: hackerone_public
report_count: 3
---

# Email Confirmation Bypass → Privilege Escalation via SSO

**Reports**: Shopify — "Email Confirmation Bypass in myshop.myshopify.com → Full Privilege Escalation to Any Shop Owner via Shopify SSO" (#791775); Part II (#796808); your-store.myshopify.com (#910300).

## Why it matters (the new lesson)
Multi-tenant SSO often grants access based on the email *domain* or a role claim set at signup. If you can sign up with a target's email (or an unconfirmed email that later gets confirmed, or a manipulated identity claim) and bypass the confirmation step, you become an admin/owner of a tenant you don't own. Email verification is frequently the *only* barrier — and it's frequently bypassable.

## How it works
1. Sign up with a target-tenant email, or an unverified email.
2. Bypass the confirmation (race, unverified-state access, SSO auto-link, `?confirmed=1`, token reuse, flow skip).
3. SSO maps the now-"confirmed" email to an existing tenant → admin access.

## How to hunt for it
1. Map SSO signup → email confirmation → tenant/role assignment.
2. Test skipping/replaying/racing confirmation; try signing up with unconfirmed then accessing protected SSO resources.
3. Check if unverified emails are auto-linked/auto-confirmed on first SSO login.

## Payloads / flow
Signup with `email=victim+attacker@...` or a variant, skip confirmation, trigger SSO, observe role.

## Fix
Confirm email before granting tenant/role; bind role to verified identity claim; don't auto-link on unverified email; re-verify on every privilege grant.
