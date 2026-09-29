---
name: h1-oauth
description: OAuth / OIDC misconfiguration: real-world techniques and chains distilled from 82 disclosed HackerOne reports (top bounty $4,000). Use when hunting oauth / oidc misconfiguration for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-oauth.
source: reddelexc/hackerone-reports
report_count: 82
top_bounty: 4000
---

# OAuth / OIDC misconfiguration — disclosed-report playbook (H1)

Distilled from **82** disclosed HackerOne reports for this class (top bounty **$4,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-oauth` skill for the hunting methodology.

## How to hunt
- redirect_uri validation: prefix/suffix/regex bypass, open-redirect chain to code theft.
- state parameter: CSRF, null-byte, missing; scope escalation; leaking code in Referer.
- Account-link CSRF; IdP confusion; token audience misuse.
- Prove auth-code/token theft leading to ATO.

## Patterns in the wild (from report titles)

`oauth` ×84 · `redirect` ×21 · `token` ×19 · `bypass` ×9 · `leak` ×8 · `csrf` ×7 · `account takeover` ×6 · `api` ×4 · `ato` ×2 · `race` ×2 · `disclosure` ×2

## Top disclosed reports

- [Shopify Stocky App OAuth Misconfiguration](https://hackerone.com/reports/740989) — Shopify, $0 · 527↑
- [Chained Bugs to Leak Victim's Uber's FB Oauth Token](https://hackerone.com/reports/202781) — Uber, $0 · 427↑
- [Insufficient OAuth callback validation which leads to Periscope account takeover](https://hackerone.com/reports/110293) — X / xAI, $0 · 276↑
- [OAuth `redirect_uri` bypass using IDN homograph attack resulting in user's access token leakage](https://hackerone.com/reports/861940) — Semrush, $0 · 265↑
- [Ability to bypass email verification for OAuth grants results in accounts takeovers on 3rd parties](https://hackerone.com/reports/922456) — GitLab, $3,000 · 257↑
- [Stealing Users OAuth authorization code via redirect_uri](https://hackerone.com/reports/1861974) — pixiv, $2,000 · 252↑
- [Unauthenticated blind SSRF in OAuth Jira authorization controller](https://hackerone.com/reports/398799) — GitLab, $4,000 · 238↑
- [Stealing Facebook OAuth Code Through Screenshot viewer](https://hackerone.com/reports/488269) — Rockstar Games, $0 · 200↑
- [Referer Leakage Vulnerability in  socialclub.rockstargames.com/crew/ leads to FB'S OAuth token theft.](https://hackerone.com/reports/787160) — Rockstar Games, $0 · 112↑
- [User account compromised authentication bypass via oauth token impersonation](https://hackerone.com/reports/739321) — Picsart, $0 · 101↑
- [Misconfigured oauth leads to Pre account takeover](https://hackerone.com/reports/1074047) — Bumble, $0 · 89↑
- [Incorrect details on OAuth permissions screen allows DMs to be read without permission](https://hackerone.com/reports/434763) — X / xAI, $2,940 · 80↑
- [Forced OAuth authorization using button ID in hash and holding space](https://hackerone.com/reports/2649615) — LinkedIn, $0 · 79↑
- [OAuth redirect uri validation bypass for :proxima_first_party_sync apps](https://hackerone.com/reports/3588801) — GitHub, $0 · 77↑
- [CSRF on Periscope Web OAuth authorization endpoint](https://hackerone.com/reports/215381) — X / xAI, $0 · 74↑
- [Facebook OAuth Code Theft through referer leakage on support.rockstargames.com](https://hackerone.com/reports/482743) — Rockstar Games, $0 · 71↑
- [Open Redirect Vulnerability in OAuth Flow Leading to Potential Phishing Attack](https://hackerone.com/reports/3099816) — Lichess, $0 · 70↑
- [Stealing Users OAuth Tokens through redirect_uri parameter](https://hackerone.com/reports/665651) — GSA Bounty, $750 · 67↑
- [Double Clickjacking Attack on WakaTime OAuth Authorization Flow at https://wakatime.com/oauth/authorize](https://hackerone.com/reports/3287060) — WakaTime, $0 · 57↑
- [Race Conditions in OAuth 2 API implementations](https://hackerone.com/reports/55140) — Internet Bug Bounty, $0 · 51↑
- [[auth2.zomato.com] Reflected XSS at `oauth2/fallbacks/error` | ORY Hydra an OAuth 2.0 and OpenID Connect Provider](https://hackerone.com/reports/456333) — Eternal, $0 · 51↑
- [Mattermost Server OAuth Flow Cross-Site Scripting](https://hackerone.com/reports/1216203) — Mattermost, $900 · 44↑
- [Stealing Users OAUTH Tokens via redirect_uri](https://hackerone.com/reports/405100) — BOHEMIA INTERACTIVE a.s., $0 · 44↑
- [page.line.me Open Redirect Leading to OAuth Authorization Code Exposure and Access Token Compromise](https://hackerone.com/reports/3423013) — LY Corporation, $1,000 · 43↑
- [Oauth flow on the comments widget login can lead to the access code leakage](https://hackerone.com/reports/292783) — Ed, $0 · 43↑
- [Twitter iOS fails to validate server certificate and sends oauth token](https://hackerone.com/reports/168538) — X / xAI, $2,100 · 40↑
- [Ability to bypass social OAuth and take over any account [d2c-api]](https://hackerone.com/reports/729960) — Genasys Technologies, $0 · 40↑
- [Smuggle SocialClub's Facebook OAuth Code via Referer Leakage](https://hackerone.com/reports/342709) — Rockstar Games, $750 · 39↑
- [Gitlab Oauth Misconfiguration Lead To Account Takeover](https://hackerone.com/reports/541701) — Vercel, $0 · 39↑
- [Broken OAuth leads to change photo profile users .](https://hackerone.com/reports/642475) — Dropbox, $512 · 37↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
