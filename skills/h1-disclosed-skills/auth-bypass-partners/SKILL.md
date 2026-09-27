---
name: auth-bypass-partners
description: Admin authentication bypass via a partner/SSO login path that trusts an attacker-controllable value. Teaches alternate-login-path and SSO trust-chain abuse for auth bypass.
sources: hackerone_public
report_count: 1
---

# Auth bypass via partner/SSO login path

**Report**: Shopify — "Shopify admin authentication bypass using partners.shopify.com" (hackerone.com/reports/270981). Related: GitHub SSH-certificate auth bypass (#1901040), TikTok recovery ATO (#2443228).

## Why it matters (the new lesson)
Applications expose multiple login paths (partner portal, SSO/OAuth, API tokens, SSH certs, "login with X"). A flaw in one path — trusting a spoofable parameter, a shared session, or a delegated identity — can grant access to the *main* admin. Map every auth entry point, not just the primary login form.

## How it works
The partner domain and main admin share a session/identity model. By crafting a request through the partner flow (or spoofing a partner-identity parameter), the attacker obtained an admin session on the primary store.

## How to hunt for it
1. Enumerate all login/authz entry points: `/login`, `/sso`, `/oauth`, partner portals, API token endpoints, "switch account", invite flows.
2. Look for cross-issuer trust: tokens/cookies issued by a partner accepted by admin; spoofable `account_id`/`shop_id`/`partner_id`; IDP misconfig.
3. Test identity spoofing across the trust boundary.

## Fix
Separate identity/issuers; validate the issuing domain + signature + audience; don't accept partner-issued tokens for admin scope.
