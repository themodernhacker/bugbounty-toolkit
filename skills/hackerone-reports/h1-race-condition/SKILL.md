---
name: h1-race-condition
description: Race conditions: real-world techniques and chains distilled from 81 disclosed HackerOne reports (top bounty $5,000). Use when hunting race conditions for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-race-condition.
source: reddelexc/hackerone-reports
report_count: 81
top_bounty: 5000
---

# Race conditions — disclosed-report playbook (H1)

Distilled from **81** disclosed HackerOne reports for this class (top bounty **$5,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-race-condition` skill for the hunting methodology.

## How to hunt
- Single-packet attack (HTTP/2) / last-byte sync for near-simultaneous requests.
- Targets: coupon/gift-card redeem, balance transfer, vote, OTP validate, signup.
- Measure the limit-overrun (e.g. redeemed N times); reset state between tries.
- Confirm it's a real TOCTOU window, not just retries.

## Patterns in the wild (from report titles)

`race` ×81 · `bypass` ×8 · `api` ×8 · `oauth` ×3 · `privilege` ×3 · `dom` ×2 · `escalation` ×2

## Top disclosed reports

- [Race Condition allows to redeem multiple times gift cards which leads to free "money"](https://hackerone.com/reports/759247) — Reverb.com, $0 · 307↑
- [Race condition in performing retest allows duplicated payments](https://hackerone.com/reports/429026) — HackerOne, $0 · 239↑
- [Client-Side Race Condition using Marketo, allows sending user to data-protocol in Safari when form without onSuccess is submitted on www.hackerone.com](https://hackerone.com/reports/381356) — HackerOne, $0 · 154↑
- [Race Condition leads to undeletable group member](https://hackerone.com/reports/604534) — HackerOne, $0 · 153↑
- [Bypassing HackerOne 2FA due to race condition](https://hackerone.com/reports/2598548) — HackerOne, $0 · 139↑
- [Race condition in activating email resulting in infinite amount of diamonds received](https://hackerone.com/reports/509629) — InnoGames, $2,000 · 137↑
- [Race Conditions in Popular reports feature.](https://hackerone.com/reports/146845) — HackerOne, $0 · 125↑
- [Race Condition when following a user](https://hackerone.com/reports/927384) — Staging.every.org, $0 · 113↑
- [Race Condition : Exploiting the loyalty claim https://xxx.vendhq.com/loyalty/claim/email/xxxxx url and gain x amount of loyalty bonus/cash](https://hackerone.com/reports/331940) — Vend VDP, $0 · 96↑
- [Race Condition Enables Bypassing Verification Check](https://hackerone.com/reports/2110030) — Tools for Humanity, $3,000 · 95↑
- [Race Condition in Flag Submission](https://hackerone.com/reports/454949) — HackerOne, $0 · 94↑
- [Race condition on add 1 free domain](https://hackerone.com/reports/2616045) — Automattic, $0 · 93↑
- [Race Condition of Transfer data Credits to Organization Leads to Add Extra free Data Credits to the Organization](https://hackerone.com/reports/974892) — Helium, $250 · 74↑
- [Race condition leads to duplicate payouts](https://hackerone.com/reports/220445) — HackerOne, $0 · 73↑
- [Race condition in joining CTF group](https://hackerone.com/reports/1540969) — HackerOne, $500 · 72↑
- [Exceed the maximum number of subscribers using Race Condition](https://hackerone.com/reports/3221185) — SingleStore, $0 · 70↑
- [Email Verification Bypass via Race Condition](https://hackerone.com/reports/3020733) — Malwarebytes, $0 · 69↑
- [Race Condition in Folder Creation Allows Bypassing Folder Limit](https://hackerone.com/reports/3104355) — Dust, $0 · 65↑
- [Exceeding the limit of Workspaces via Race Condition](https://hackerone.com/reports/3226838) — SingleStore, $0 · 62↑
- [Race condition in faucet when using starport](https://hackerone.com/reports/1438052) — Cosmos, $5,000 · 60↑
- [Race Condition on "Get free Badoo Premium" which allows to get more days of free premium for Free.](https://hackerone.com/reports/1037430) — Bumble, $0 · 57↑
- [Race condition in claiming program credentials](https://hackerone.com/reports/488985) — HackerOne, $0 · 54↑
- [Race Conditions in OAuth 2 API implementations](https://hackerone.com/reports/55140) — Internet Bug Bounty, $0 · 51↑
- [Race condition leads to add more than 5 email at Data breaches monitor system at https://stage.firefoxmonitor.nonprod.cloudops.mozgcp.net](https://hackerone.com/reports/1913309) — Mozilla, $0 · 50↑
- [Race condition while removing the love react in community files.](https://hackerone.com/reports/996141) — Figma, $150 · 45↑
- [Race condition in User comments  Likes](https://hackerone.com/reports/1409913) — Eternal, $0 · 45↑
- [Race Condition on Create API Function](https://hackerone.com/reports/2682392) — Enjin, $0 · 45↑
- [Race Condition in Redeeming Coupons](https://hackerone.com/reports/157996) — Instacart, $0 · 43↑
- [Timeout-based race conditions make Uint8Array/Buffer.alloc non-zerofilled](https://hackerone.com/reports/3405778) — Node.js, $0 · 43↑
- [Race condition in up voting and down voting](https://hackerone.com/reports/183837) — Urban Dictionary, $0 · 42↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
