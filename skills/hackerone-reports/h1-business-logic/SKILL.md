---
name: h1-business-logic
description: Business logic flaws: real-world techniques and chains distilled from 203 disclosed HackerOne reports (top bounty $12,000). Use when hunting business logic flaws for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-business-logic.
source: reddelexc/hackerone-reports
report_count: 203
top_bounty: 12000
---

# Business logic flaws — disclosed-report playbook (H1)

Distilled from **203** disclosed HackerOne reports for this class (top bounty **$12,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-business-logic` skill for the hunting methodology.

## How to hunt
- Model the intended money/trust flow; look for skipped or reorderable steps.
- Negative/decimal quantities, price/coupon tampering, currency confusion.
- Race conditions on redeem/transfer/vote (see h1-race-condition).
- Demonstrate concrete financial/impact loss to the target.

## Patterns in the wild (from report titles)

`bypass` ×13 · `ssrf` ×8 · `admin` ×7 · `csrf` ×7 · `api` ×6 · `cache` ×6 · `leak` ×6 · `account takeover` ×5 · `rce` ×5 · `redirect` ×5 · `stored` ×4 · `dom` ×4

## Top disclosed reports

- [Project Template functionality can be used to copy private project data, such as repository, confidential issues, snippets, and merge requests](https://hackerone.com/reports/689314) — GitLab, $12,000 · 457↑
- [Account takeover through the combination of cookie manipulation and XSS](https://hackerone.com/reports/534450) — Superhuman (formerly Grammarly), $0 · 291↑
- [Ethereum account balance manipulation](https://hackerone.com/reports/300748) — Coinbase, $0 · 276↑
- [SSRF  leaking internal google cloud data through upload function [SSH Keys, etc..]](https://hackerone.com/reports/549882) — Vimeo, $0 · 276↑
- [Account Takeover via Email ID Change and Forgot Password Functionality](https://hackerone.com/reports/1089467) — New Relic, $2,048 · 214↑
- [Blind SQL injection and making any profile comments from any users to disappear using "like" function (2 in 1 issues)](https://hackerone.com/reports/363815) — Pornhub, $0 · 211↑
- [OLO Total price manipulation using negative quantities](https://hackerone.com/reports/364843) — Upserve, $0 · 167↑
- [Abusing "Report as abuse" functionality to delete any user's post.](https://hackerone.com/reports/411075) — Vanilla, $300 · 160↑
- [Server Side Request Forgery (SSRF) in webhook functionality](https://hackerone.com/reports/2301565) — HackerOne, $2,500 · 137↑
- [Business Logic Error – Bypass of OTP Verification During Signup on hover.com](https://hackerone.com/reports/3255473) — Tucows (VDP), $0 · 134↑
- [Exploitable live argument in onClick Function leads to Data Leakage of Inactive/Suspended Products](https://hackerone.com/reports/2295958) — TikTok, $1,000 · 128↑
- [Unserialize leading to arbitrary PHP function invoke](https://hackerone.com/reports/210741) — Rockstar Games, $0 · 119↑
- [HTTP Request Smuggling in Transform Rules using hexadecimal escape sequences in the concat() function](https://hackerone.com/reports/1478633) — Cloudflare Public Bug Bounty, $6,000 · 116↑
- [XXE in Site Audit function exposing file and directory contents](https://hackerone.com/reports/312543) — Semrush, $0 · 115↑
- [Claiming the listing of a non-delivery restaurant through OTP manipulation](https://hackerone.com/reports/1330529) — Eternal, $3,250 · 108↑
- [Null pointer dereference in SMTP server function smtp_string_parse](https://hackerone.com/reports/827729) — Open-Xchange, $1,500 · 105↑
- [Account Takeover in Password Reset Function](https://hackerone.com/reports/3228888) — Mars, $0 · 104↑
- [Able to bypass authorization logic and gain more access then intended](https://hackerone.com/reports/3713965) — GitHub, $0 · 103↑
- [Bypass of biometrics security functionality is possible in Android application (com.shopify.mobile)](https://hackerone.com/reports/637194) — Shopify, $500 · 90↑
- [URL Path Manipulation Enables Cache Poisoning of Amazon Affiliate Products in Shopify Linkpop](https://hackerone.com/reports/1848940) — Shopify, $500 · 85↑
- [Manipulating response leads to free access to Streamlabs Prime](https://hackerone.com/reports/1070510) — Logitech, $0 · 80↑
- [CSRF in ticket function](https://hackerone.com/reports/1890310) — TikTok, $0 · 79↑
- [Business Logic Bypass Allows Setting “Read Access” Role Without Pro Plan Subscription](https://hackerone.com/reports/3591764) — Lovable VDP, $0 · 76↑
- [Authorization Token on PlayStation Network Leaks via postMessage function](https://hackerone.com/reports/826394) — PlayStation, $1,000 · 74↑
- [Title: Deceptive Manipulation of HTTP to HTTPS with VPN in Burp Suite](https://hackerone.com/reports/2230842) — PortSwigger Web Security, $0 · 71↑
- [sqli on █████████ search functionality](https://hackerone.com/reports/2446550) — Mars, $0 · 71↑
- [Parameter Manipulation allowed for viewing of other user’s teavana.com orders](https://hackerone.com/reports/141090) — Starbucks, $0 · 70↑
- [Old WebKit HTML agent in Template Preview function has multiple known vulnerabilities leading to RCE](https://hackerone.com/reports/520717) — Lob, $1,500 · 68↑
- [Captcha bypass for the most important function - At en.instagram-brand.com](https://hackerone.com/reports/206653) — Automattic, $0 · 64↑
- [Reflected XSS in "Create Category" Functionality of Post Creation Module](https://hackerone.com/reports/3179138) — MainWP, $50 · 63↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
