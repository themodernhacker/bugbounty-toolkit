---
name: h1-auth
description: Authentication flaws: real-world techniques and chains distilled from 323 disclosed HackerOne reports (top bounty $20,160). Use when hunting authentication flaws for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-auth-bypass.
source: reddelexc/hackerone-reports
report_count: 323
top_bounty: 20160
---

# Authentication flaws — disclosed-report playbook (H1)

Distilled from **323** disclosed HackerOne reports for this class (top bounty **$20,160**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-auth-bypass` skill for the hunting methodology.

## How to hunt
- Trace the full login/SSO flow in the proxy; find every state check.
- SAML: signature stripping/XSW, comment injection; JWT: alg confusion, alg:none.
- Alternate-channel bypass (legacy endpoint, mobile API, XMLRPC) skipping SSO.
- Brute/rate-limit gaps on login and OTP; credential reuse from breaches (own accounts only).

## Patterns in the wild (from report titles)

`bypass` ×114 · `token` ×23 · `rce` ×21 · `admin` ×19 · `api` ×18 · `account takeover` ×11 · `pre-auth` ×11 · `redirect` ×9 · `disclosure` ×9 · `csrf` ×8 · `2fa` ×8 · `leak` ×8

## Top disclosed reports

- [Potential pre-auth RCE on Twitter VPN](https://hackerone.com/reports/591295) — X / xAI, $20,160 · 1243↑
- [Improper Authentication - any user can login as other user with otp/logout & otp/login](https://hackerone.com/reports/921780) — Snapchat, $0 · 969↑
- [Subdomain Takeover to Authentication bypass](https://hackerone.com/reports/335330) — Roblox, $0 · 782↑
- [[ RCE ] Through stopping the redirect in /admin/* the attacker able to bypass Authentication And Upload Malicious File](https://hackerone.com/reports/683957) — Mail.ru, $0 · 340↑
- [Shopify admin authentication bypass using partners.shopify.com](https://hackerone.com/reports/270981) — Shopify, $0 · 310↑
- [Bypass Password Authentication for updating email and phone number - Security Vulnerability](https://hackerone.com/reports/770504) — X / xAI, $0 · 287↑
- [Misuse of an authentication cookie combined with a path traversal on app.starbucks.com permitted access to restricted data](https://hackerone.com/reports/876295) — Starbucks, $0 · 239↑
- [Spring Actuator endpoints publicly available and broken authentication](https://hackerone.com/reports/838635) — LY Corporation, $12,500 · 234↑
- [1 Click Account Takeover via Auth Token Theft on marketing.hostinger.com](https://hackerone.com/reports/3081691) — hostinger, $0 · 217↑
- [Through blocking the redirect in /* the attacker able to bypass Authentication To see Sensitive Data sush as Game Keys , Emails ,..](https://hackerone.com/reports/736273) — Razer, $1,000 · 196↑
- [Authentication bypass on gist.github.com through SSH Certificates](https://hackerone.com/reports/1901040) — GitHub, $10,000 · 182↑
- [Authentication bypass on auth.uber.com via subdomain takeover of saostatic.uber.com](https://hackerone.com/reports/219205) — Uber, $0 · 182↑
- [Account Takeover via Authentication Bypass in TikTok Account Recovery](https://hackerone.com/reports/2443228) — TikTok, $12,000 · 171↑
- [Web Authentication Endpoint Credentials Brute-Force Vulnerability](https://hackerone.com/reports/127844) — HackerOne, $0 · 161↑
- [2-factor authentication can be disabled when logged in without confirming account password](https://hackerone.com/reports/783258) — Localize, $0 · 159↑
- [[c-api.city-mobil.ru] Client authentication bypass leads to information disclosure](https://hackerone.com/reports/772118) — Mail.ru, $0 · 143↑
- [Improper bot-authentication allows to impersonate any user when sending messages in a room](https://hackerone.com/reports/3329310) — Basecamp, $2,000 · 127↑
- [Incorrect param parsing in Digits web authentication](https://hackerone.com/reports/126522) — X / xAI, $0 · 126↑
- [Netlify Authentication Token Exposed in Public Mozilla CI Logs](https://hackerone.com/reports/2915647) — Mozilla, $0 · 123↑
- [RCE/LFI on test Jenkins instance due to improper authentication flow](https://hackerone.com/reports/258117) — Snapchat, $0 · 117↑
- [Authentication Bypass Leads To  Complete Account TakeveOver on ██████████](https://hackerone.com/reports/1709881) — MTN Group, $0 · 107↑
- [Admin Authentication Bypass Lead to Admin Account Takeover](https://hackerone.com/reports/1490470) — UPS VDP, $0 · 106↑
- [User account compromised authentication bypass via oauth token impersonation](https://hackerone.com/reports/739321) — Picsart, $0 · 101↑
- [Thailand - a small number of SMB CCTV footage backup servers were accessible without authentication.](https://hackerone.com/reports/417360) — Starbucks, $0 · 99↑
- [Complete authentication bypass to admin permissions](https://hackerone.com/reports/3564655) — Rocket.Chat, $0 · 99↑
- [Account Takeover via SMS Authentication Flow](https://hackerone.com/reports/1245762) — Zenly, $0 · 93↑
- [Account takeover w/o interaction for a user that doesn't have 2fa enabled via 2fa linking and improper auth at /api/2fa/verify](https://hackerone.com/reports/810880) — Helium, $0 · 92↑
- [POST /api/bitcoinWithdrawalFees returns financial data without authentication despite being documented as a USER OPERATION (private endpoint)](https://hackerone.com/reports/3676308) — CoinMate.io, $0 · 92↑
- [Improper Authentication Throttling Allows Attacker-Controlled Account Lockouts](https://hackerone.com/reports/3160210) — Lichess, $0 · 91↑
- [SAML Authentication Bypass on uchat.uberinternal.com](https://hackerone.com/reports/223014) — Uber, $8,500 · 87↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
