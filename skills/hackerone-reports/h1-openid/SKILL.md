---
name: h1-openid
description: OpenID Connect flaws: real-world techniques and chains distilled from 29 disclosed HackerOne reports (top bounty $10,500). Use when hunting openid connect flaws for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-oauth.
source: reddelexc/hackerone-reports
report_count: 29
top_bounty: 10500
---

# OpenID Connect flaws — disclosed-report playbook (H1)

Distilled from **29** disclosed HackerOne reports for this class (top bounty **$10,500**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-oauth` skill for the hunting methodology.

## How to hunt
- ID token validation: signature, iss/aud/exp, alg confusion (see hunt-jwt-crypto).
- Nonce/state handling; PKCE downgrade; discovery/JWKS spoofing.
- Chain to ATO via forged/replayed ID token.

## Patterns in the wild (from report titles)

`saml` ×15 · `bypass` ×11 · `internal` ×3 · `oauth` ×2 · `rce` ×2 · `redirect` ×2

## Top disclosed reports

- [Email Confirmation Bypass in myshop.myshopify.com that Leads to Full Privilege Escalation to Any Shop Owner by Taking Advantage of the Shopify SSO](https://hackerone.com/reports/791775) — Shopify, $0 · 1917↑
- [Able to Takeover Merchants Accounts Even They Have Already Setup SSO, After Bypassing the Email Confirmation](https://hackerone.com/reports/796956) — Shopify, $0 · 310↑
- [Ability to DOS any organization's SSO and open up the door to account takeovers](https://hackerone.com/reports/976603) — Superhuman (formerly Grammarly), $10,500 · 259↑
- [Stealing SSO Login Tokens (snappublisher.snapchat.com)](https://hackerone.com/reports/265943) — Snapchat, $7,500 · 244↑
- [HackerOne SAML signup domain enforcement bypass results in unauthorized access to HackerOne PullRequest organization](https://hackerone.com/reports/2101076) — HackerOne, $0 · 228↑
- [SAML Signature verification bypass allows logging into any user (with specific conditions)](https://hackerone.com/reports/2579939) — GitHub, $0 · 196↑
- [Insecure Zendesk SSO implementation by generating JWT client-side](https://hackerone.com/reports/638635) — Trint Ltd, $0 · 102↑
- [SAML Authentication Bypass on uchat.uberinternal.com](https://hackerone.com/reports/223014) — Uber, $8,500 · 87↑
- [Twitter SSO allows unverified e-mail registration, leads to Slack and social media hijacks](https://hackerone.com/reports/235139) — Zendesk, $0 · 70↑
- [ID4me feature of OpenID connect app available even when disabled](https://hackerone.com/reports/2376929) — Nextcloud, $0 · 66↑
- [[auth2.zomato.com] Reflected XSS at `oauth2/fallbacks/error` | ORY Hydra an OAuth 2.0 and OpenID Connect Provider](https://hackerone.com/reports/456333) — Eternal, $0 · 51↑
- [(HackerOne SSO-SAML) Login CSRF, Open Redirect, and Self-XSS Possible Exploitation](https://hackerone.com/reports/171398) — HackerOne, $0 · 44↑
- [Authentication bypass on JetPack SSO manager - Allows to access the administration panel of wordpress without user interaction](https://hackerone.com/reports/2037902) — Automattic, $0 · 41↑
- [Authentication Bypass via XML Signature Wrapping in SAML SSO](https://hackerone.com/reports/3827674) — Rocket.Chat, $0 · 38↑
- [Accidental Access to Programs Information via SAML Login](https://hackerone.com/reports/438306) — HackerOne, $0 · 34↑
- [SAML Response Reuse on hackerone.com/users/saml/auth](https://hackerone.com/reports/888930) — HackerOne, $0 · 26↑
- [Ability to enumerate private programs using SAML](https://hackerone.com/reports/167828) — HackerOne, $0 · 24↑
- [████ discloses valid Airbnb SSO login names via Google Search Results](https://hackerone.com/reports/161659) — Airbnb, $0 · 21↑
- [Limited Open redirection using SSO-SAML](https://hackerone.com/reports/178345) — HackerOne, $0 · 19↑
- [SSO bypass in zendesk using trint organization able to leak internal ticket information](https://hackerone.com/reports/734936) — Trint Ltd, $0 · 16↑
- [SAML authentication bypass](https://hackerone.com/reports/812064) — Rocket.Chat, $0 · 15↑
- [SSO through odnoklassniki uses http rather than https](https://hackerone.com/reports/703759) — Bumble, $150 · 14↑
- [[rev-app.informatica.com] - XXE via SAML](https://hackerone.com/reports/106865) — Informatica, $0 · 12↑
- [SSO Authentication Bypass](https://hackerone.com/reports/168108) — New Relic, $0 · 12↑
- [Update php-saml library to 2.10.5](https://hackerone.com/reports/213789) — Nextcloud, $0 · 8↑
- [Configuration and/or source code files on uchat-staging.uberinternal.com can be viewed without OneLogin SSO Authentication](https://hackerone.com/reports/298990) — Uber, $0 · 6↑
- [Открытое перенапровление на OpenID](https://hackerone.com/reports/241484) — Mail.ru, $0 · 5↑
- [SAML authentication bypass through unauthenticated `addSamlProvider` Meteor Call](https://hackerone.com/reports/1049375) — Rocket.Chat, $0 · 5↑
- [SSO Provider Credential Cache (logged out of Google/GitHub, could still log into Courier)](https://hackerone.com/reports/880730) — Courier, $0 · 1↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
