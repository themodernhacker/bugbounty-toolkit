---
name: h1-csrf
description: Cross-Site Request Forgery: real-world techniques and chains distilled from 476 disclosed HackerOne reports (top bounty $10,000). Use when hunting cross-site request forgery for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-csrf.
source: reddelexc/hackerone-reports
report_count: 476
top_bounty: 10000
---

# Cross-Site Request Forgery — disclosed-report playbook (H1)

Distilled from **476** disclosed HackerOne reports for this class (top bounty **$10,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-csrf` skill for the hunting methodology.

## How to hunt
- Find state-changing requests with no/again-usable anti-CSRF token.
- SameSite gaps: Lax sibling-subdomain, JSON via text/plain, GET-based mutations.
- Chain to email/password change -> ATO; test WebSocket CSRF (CSWSH).
- Prove cross-site execution from an attacker origin.

## Patterns in the wild (from report titles)

`csrf` ×460 · `token` ×72 · `bypass` ×32 · `account takeover` ×28 · `api` ×17 · `leak` ×9 · `stored` ×8 · `oauth` ×7 · `disclosure` ×7 · `ato` ×6 · `admin` ×6 · `rce` ×6

## Top disclosed reports

- [CSRF on connecting Paypal as Payment Provider](https://hackerone.com/reports/807924) — Shopify, $0 · 304↑
- [Account Takeover using Linked Accounts due to lack of CSRF protection](https://hackerone.com/reports/463330) — Rockstar Games, $0 · 238↑
- [Periscope android app deeplink leads to CSRF in follow action](https://hackerone.com/reports/583987) — X / xAI, $1,540 · 224↑
- [Chaining Bugs: Leakage of CSRF token which leads to Stored XSS and Account Takeover (xs1.tribalwars.cash)](https://hackerone.com/reports/604120) — InnoGames, $1,100 · 186↑
- [Improper CSRF token validation allows attackers to access victim's accounts linked to Hackerone](https://hackerone.com/reports/1727221) — HackerOne, $0 · 167↑
- [Site wide CSRF affecting both job seeker and Employer account on glassdoor.com](https://hackerone.com/reports/790061) — Glassdoor, $0 · 162↑
- [CSRF protection bypass in GitHub Enterprise management console](https://hackerone.com/reports/1497169) — GitHub, $10,000 · 151↑
- [Slack integration setup lacks CSRF protection](https://hackerone.com/reports/170552) — HackerOne, $2,500 · 149↑
- [CSRF leads to a stored self xss](https://hackerone.com/reports/323005) — Imgur, $0 · 145↑
- [Lack of CSRF header validation at https://g-mail.grammarly.com/profile](https://hackerone.com/reports/629892) — Superhuman (formerly Grammarly), $0 · 140↑
- [CSRF token validation system is disabled on Stripe Dashboard](https://hackerone.com/reports/1483327) — Stripe, $0 · 113↑
- [Cross-Site Request Forgery (CSRF) vulnerability on API endpoint allows account takeovers](https://hackerone.com/reports/419891) — Khan Academy, $0 · 111↑
- [Cross-Site Request Forgery](https://hackerone.com/reports/2041007) — ownCloud, $0 · 111↑
- [CSRF Vulnerability on https://signin.rockstargames.com/tpa/facebook/link/](https://hackerone.com/reports/474833) — Rockstar Games, $0 · 104↑
- [One Click Account takeover using Ouath CSRF bypass by adding Null byte %00 in state parameter on  www.streamlabs.com](https://hackerone.com/reports/1046630) — Logitech, $200 · 99↑
- [CSRF to HTML Injection in Comments](https://hackerone.com/reports/428019) — WordPress, $0 · 95↑
- [CSRF Account Takeover](https://hackerone.com/reports/1253462) — TikTok, $0 · 95↑
- [CSRF in Account Deletion feature (https://www.flickr.com/account/delete)](https://hackerone.com/reports/615448) — Flickr, $0 · 92↑
- [Account takeover at https://try.discourse.org due to no CSRF protection in connecting Yahoo account](https://hackerone.com/reports/423022) — Discourse, $0 · 88↑
- [[CRITICAL] Full account takeover using CSRF](https://hackerone.com/reports/235642) — X / xAI, $0 · 87↑
- [CSRF leads to Account takeover](https://hackerone.com/reports/2699029) — U.S. Dept Of Defense, $0 · 87↑
- [CSRF on /api/graphql allows executing mutations through GET requests](https://hackerone.com/reports/1122408) — GitLab, $3,370 · 86↑
- [CSRF token validation system is disabled on Stripe Dashboard](https://hackerone.com/reports/1493437) — Stripe, $2,500 · 86↑
- [CSRF to Reflected XSS at echo.urbandictionary.biz via spoofing content type](https://hackerone.com/reports/1237321) — Urban Dictionary, $0 · 86↑
- [Login CSRF vulnerability on hackerone.com](https://hackerone.com/reports/834366) — HackerOne, $500 · 83↑
- [Delete any user's added Email,Telephone,Fax,Address,Skype via csrf in (https://academy.acronis.com/)](https://hackerone.com/reports/709537) — Acronis, $0 · 82↑
- [CSRF protection bypass on TikTok Webcast Endpoints](https://hackerone.com/reports/1543234) — TikTok, $2,500 · 79↑
- [CSRF in ticket function](https://hackerone.com/reports/1890310) — TikTok, $0 · 79↑
- [CSRF protection on OIDC login is broken](https://hackerone.com/reports/1878381) — Nextcloud, $500 · 77↑
- [Japan - CSRF in webapp.starbucks.co.jp with user interaction could leak an access token if the user was not using Chrome](https://hackerone.com/reports/1113559) — Starbucks, $0 · 77↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
