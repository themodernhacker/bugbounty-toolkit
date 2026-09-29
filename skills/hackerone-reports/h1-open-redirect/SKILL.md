---
name: h1-open-redirect
description: Open redirect: real-world techniques and chains distilled from 274 disclosed HackerOne reports (top bounty $3,000). Use when hunting open redirect for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-open-redirect.
source: reddelexc/hackerone-reports
report_count: 274
top_bounty: 3000
---

# Open redirect — disclosed-report playbook (H1)

Distilled from **274** disclosed HackerOne reports for this class (top bounty **$3,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-open-redirect` skill for the hunting methodology.

## How to hunt
- Every redirect param (next, url, return, callback); test //evil.com and whitelist-host bypasses.
- Low-sev alone — always chain: OAuth code theft, SSRF pivot, phishing.
- Header/meta/JS redirect variants; parameter pollution to smuggle the target.

## Patterns in the wild (from report titles)

`redirect` ×286 · `bypass` ×23 · `oauth` ×12 · `api` ×9 · `reflected` ×8 · `dom` ×8 · `token` ×7 · `admin` ×4 · `leak` ×4 · `account takeover` ×3 · `saml` ×3 · `upload` ×3

## Top disclosed reports

- [[cs.money] Open Redirect Leads to Account Takeover](https://hackerone.com/reports/905607) — CS Money, $0 · 356↑
- [XSS and Open Redirect on MoPub Login](https://hackerone.com/reports/683298) — X / xAI, $1,540 · 247↑
- [Open Redirect in secure.showmax.com](https://hackerone.com/reports/749338) — Showmax, $550 · 225↑
- [Open redirect at https://inventory.upserve.com/http://google.com/](https://hackerone.com/reports/469803) — Upserve, $1,200 · 178↑
- [Open Redirect in Logout & Login](https://hackerone.com/reports/1788006) — Expedia Group Bug Bounty, $0 · 169↑
- [Open redirect due to scanning QR code via brave browser](https://hackerone.com/reports/1946534) — Brave Software, $0 · 148↑
- [Open Redirect on central.uber.com allows for account takeover](https://hackerone.com/reports/206591) — Uber, $0 · 143↑
- [Open redirect](https://hackerone.com/reports/2957962) — XVIDEOS, $0 · 142↑
- [1-Click Account Takeover via Open Redirect through Regex Bypass in Domain Validation](https://hackerone.com/reports/3723458) — Khan Academy, $0 · 121↑
- [CRLF to XSS & Open Redirection](https://hackerone.com/reports/2012519) — TikTok, $0 · 97↑
- [Twitter lite(Android): Vulnerable to local file steal, Javascript injection, Open redirect](https://hackerone.com/reports/499348) — X / xAI, $0 · 95↑
- [Open redirect vulnerability](https://hackerone.com/reports/380760) — Rockstar Games, $250 · 83↑
- [Open redirect](https://hackerone.com/reports/753399) — Nord Security, $0 · 81↑
- [[dev.twitter.com] XSS and Open Redirect](https://hackerone.com/reports/260744) — X / xAI, $1,120 · 74↑
- [Open Redirect](https://hackerone.com/reports/1213580) — Affirm, $250 · 74↑
- [Open Redirect on ███████](https://hackerone.com/reports/2265413) — Fastly VDP, $0 · 74↑
- [open redirected by host header](https://hackerone.com/reports/2828499) — Localize, $0 · 73↑
- [Bypass of Open Redirect Fix on lovable.dev via /..// Path Traversal in redirect parameter](https://hackerone.com/reports/3599248) — Lovable VDP, $0 · 73↑
- [Open Redirect](https://hackerone.com/reports/504751) — Omise, $100 · 72↑
- [Chained open redirects and use of Ideographic Full Stop defeat Twitter's  approach to blocking links](https://hackerone.com/reports/1032610) — X / xAI, $560 · 70↑
- [Open Redirect Vulnerability in OAuth Flow Leading to Potential Phishing Attack](https://hackerone.com/reports/3099816) — Lichess, $0 · 70↑
- [Google API key leaks and security misconfiguration leads Open Redirect Vulnerability](https://hackerone.com/reports/1066410) — Clario, $300 · 68↑
- [Reflected XSS & Open Redirect at mcs main domain](https://hackerone.com/reports/996262) — Mail.ru, $0 · 68↑
- [Multiple Open Redirect on TikTok domains](https://hackerone.com/reports/2221547) — TikTok, $0 · 61↑
- [Open redirect using theme install](https://hackerone.com/reports/101962) — Shopify, $0 · 60↑
- [Authentication Token Theft via Open Redirect in Callback URL Parameter](https://hackerone.com/reports/3419636) — lemlist, $0 · 60↑
- [Open redirect Via X-Forwarded-Host](https://hackerone.com/reports/1479889) — Omise, $0 · 58↑
- [Open redirection at https://chaturbate.com/auth/login/](https://hackerone.com/reports/411723) — Chaturbate, $0 · 55↑
- [Open Redirection in Login - Korean Starbucks](https://hackerone.com/reports/380939) — Starbucks, $0 · 54↑
- [Open Redirect on http://events.hackerone.com/redirect?url=https://naglinagli.github.io](https://hackerone.com/reports/1028345) — HackerOne, $0 · 54↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
