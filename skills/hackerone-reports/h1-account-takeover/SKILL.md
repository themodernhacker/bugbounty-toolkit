---
name: h1-account-takeover
description: Account Takeover: real-world techniques and chains distilled from 234 disclosed HackerOne reports (top bounty $35,000). Use when hunting account takeover for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-ato.
source: reddelexc/hackerone-reports
report_count: 234
top_bounty: 35000
---

# Account Takeover — disclosed-report playbook (H1)

Distilled from **234** disclosed HackerOne reports for this class (top bounty **$35,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-ato` skill for the hunting methodology.

## How to hunt
- Map every auth-state transition: password reset, email change, OAuth link, session, JWT.
- Password reset: host-header poisoning, token predictability, token leak via Referer, no-expiry/reuse.
- Chain low-sev primitives: open redirect at redirect_uri -> auth-code theft -> ATO.
- Prove takeover of a SECOND test account from the attacker's session; never touch real users.

## Patterns in the wild (from report titles)

`account takeover` ×224 · `csrf` ×31 · `ato` ×16 · `token` ×12 · `idor` ×11 · `leak` ×10 · `admin` ×9 · `bypass` ×8 · `api` ×8 · `stored` ×7 · `chain` ×7 · `oauth` ×7

## Top disclosed reports

- [Account takeover via leaked session cookie](https://hackerone.com/reports/745324) — HackerOne, $20,000 · 1640↑
- [Account Takeover via Password Reset without user interactions](https://hackerone.com/reports/2293343) — GitLab, $35,000 · 968↑
- [Mass account takeovers using HTTP Request Smuggling on https://slackb.com/ to steal session cookies](https://hackerone.com/reports/737140) — Slack, $0 · 868↑
- [Bypassing Digits origin validation which leads to account takeover](https://hackerone.com/reports/129873) — X / xAI, $0 · 618↑
- [Request smuggling on admin-official.line.me could lead to account takeover](https://hackerone.com/reports/740037) — LY Corporation, $0 · 564↑
- [Flickr Account Takeover using AWS Cognito API](https://hackerone.com/reports/1342088) — Flickr, $0 · 438↑
- [Full account takeover](https://hackerone.com/reports/314808) — Reverb.com, $0 · 411↑
- [Account Takeover worki.ru](https://hackerone.com/reports/744662) — Mail.ru, $1,700 · 391↑
- [CVE-2019-5765: 1-click HackerOne account takeover on all Android devices](https://hackerone.com/reports/563870) — Chrome, $0 · 375↑
- [[CSRF] TikTok Careers Portal Account Takeover](https://hackerone.com/reports/1010522) — TikTok, $0 · 366↑
- [Account TakeOver at my.33slona.ru](https://hackerone.com/reports/773519) — Mail.ru, $1,700 · 359↑
- [[cs.money] Open Redirect Leads to Account Takeover](https://hackerone.com/reports/905607) — CS Money, $0 · 356↑
- [yelp.com XSS ATO (via login keylogger, link Google account)](https://hackerone.com/reports/2010530) — Yelp, $0 · 323↑
- [Change any Uber user's password through /rt/users/passwordless-signup - Account Takeover (critical)](https://hackerone.com/reports/143717) — Uber, $0 · 310↑
- [Account takeover through the combination of cookie manipulation and XSS](https://hackerone.com/reports/534450) — Superhuman (formerly Grammarly), $0 · 291↑
- [Reflected XSS at https://pay.gold.razer.com escalated to account takeover](https://hackerone.com/reports/723060) — Razer, $750 · 287↑
- [[CRITICAL] 0-Click Account Takeover via Password Reset [AUTH-3243] /orchestrator/v1/password_reset/start](https://hackerone.com/reports/2831902) — Remitly, $0 · 285↑
- [Insufficient OAuth callback validation which leads to Periscope account takeover](https://hackerone.com/reports/110293) — X / xAI, $0 · 276↑
- [Ability to DOS any organization's SSO and open up the door to account takeovers](https://hackerone.com/reports/976603) — Superhuman (formerly Grammarly), $10,500 · 259↑
- [Singapore - Account Takeover via IDOR](https://hackerone.com/reports/876300) — Starbucks, $0 · 259↑
- [Mass Account Takeover at https://app.taxjar.com/ - No user Interaction](https://hackerone.com/reports/1581240) — Stripe, $0 · 252↑
- [Account Takeover using Linked Accounts due to lack of CSRF protection](https://hackerone.com/reports/463330) — Rockstar Games, $0 · 238↑
- [Account takeover of existing HackerOne accounts through SCIM provisioning](https://hackerone.com/reports/3178999) — HackerOne, $0 · 231↑
- [1 Click Account Takeover via Auth Token Theft on marketing.hostinger.com](https://hackerone.com/reports/3081691) — hostinger, $0 · 217↑
- [Account Takeover via Email ID Change and Forgot Password Functionality](https://hackerone.com/reports/1089467) — New Relic, $2,048 · 214↑
- [Account Takeover in Periscope TV](https://hackerone.com/reports/317476) — X / xAI, $0 · 212↑
- [IDOR when editing users leads to Account Takeover without User Interaction at CrowdSignal](https://hackerone.com/reports/915114) — Automattic, $0 · 202↑
- [Chaining Bugs: Leakage of CSRF token which leads to Stored XSS and Account Takeover (xs1.tribalwars.cash)](https://hackerone.com/reports/604120) — InnoGames, $1,100 · 186↑
- [1 click Account takeover via deeplink in [com.kayak.android]](https://hackerone.com/reports/1667998) — KAYAK, $0 · 173↑
- [Account Takeover via Authentication Bypass in TikTok Account Recovery](https://hackerone.com/reports/2443228) — TikTok, $12,000 · 171↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
