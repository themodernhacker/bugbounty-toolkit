---
name: h1-idor
description: Insecure Direct Object Reference: real-world techniques and chains distilled from 253 disclosed HackerOne reports (top bounty $10,500). Use when hunting insecure direct object reference for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-idor.
source: reddelexc/hackerone-reports
report_count: 253
top_bounty: 10500
---

# Insecure Direct Object Reference — disclosed-report playbook (H1)

Distilled from **253** disclosed HackerOne reports for this class (top bounty **$10,500**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-idor` skill for the hunting methodology.

## How to hunt
- Collect every object identifier (numeric, UUID, hash, encoded).
- Swap IDs across two accounts; test read, update, delete separately.
- Look in APIs, GraphQL node(), export/download, and 'share' features.
- Decode obfuscated IDs (base64, hashids) before concluding it's safe.

## Patterns in the wild (from report titles)

`idor` ×232 · `api` ×28 · `leak` ×19 · `account takeover` ×11 · `disclosure` ×10 · `ato` ×8 · `bypass` ×6 · `graphql` ×6 · `upload` ×6 · `dom` ×4 · `unauthenticated` ×3 · `token` ×3

## Top disclosed reports

- [IDOR to add secondary users in www.paypal.com/businessmanage/users/api/v1/users](https://hackerone.com/reports/415081) — PayPal, $10,500 · 793↑
- [IDOR - Delete all Licenses and certifications from users account using CreateOrUpdateHackerCertification GraphQL query](https://hackerone.com/reports/2122671) — HackerOne, $0 · 392↑
- [IDOR allow access to payments data of any user](https://hackerone.com/reports/751577) — Nord Security, $0 · 387↑
- [Insecure Direct Object Reference (IDOR) - Delete Campaigns](https://hackerone.com/reports/1969141) — HackerOne, $0 · 346↑
- [idor allows you to delete photos and album from a gallery](https://hackerone.com/reports/380410) — Pornhub, $1,500 · 266↑
- [Insecure Direct Object Reference (IDOR) Allows Viewing Private Report Details via /bugs.json Endpoint](https://hackerone.com/reports/2487889) — HackerOne, $0 · 261↑
- [Singapore - Account Takeover via IDOR](https://hackerone.com/reports/876300) — Starbucks, $0 · 259↑
- [IDOR allows any user to edit others videos](https://hackerone.com/reports/681473) — Pornhub, $1,500 · 248↑
- [IDOR: Account Deletion via Session Misbinding – Attacker Can Delete Victim Account](https://hackerone.com/reports/3154983) — Mozilla, $0 · 241↑
- [An IDOR that can lead to enumeration of a user and disclosure of email and phone number within cashier](https://hackerone.com/reports/1966006) — Unikrn, $3,000 · 232↑
- [IDOR delete any Tickets on ads.tiktok.com](https://hackerone.com/reports/1475520) — TikTok, $0 · 216↑
- [I.D.O.R To Order,Book,Buy,reserve On YELP FOR FREE (UNAUTHORIZED USE OF OTHER USER'S CREDIT CARD)](https://hackerone.com/reports/391092) — Yelp, $0 · 214↑
- [IDOR vulnerability in unreleased HackerOne Copilot feature](https://hackerone.com/reports/2218334) — HackerOne, $0 · 210↑
- [IDOR allows an attacker to modify the links of any user](https://hackerone.com/reports/1661113) — Reddit, $0 · 206↑
- [IDOR when editing users leads to Account Takeover without User Interaction at CrowdSignal](https://hackerone.com/reports/915114) — Automattic, $0 · 202↑
- [IDOR on GraphQL queries BillingDocumentDownload and BillDetails](https://hackerone.com/reports/2207248) — Shopify, $5,000 · 187↑
- [IDOR leads to Edit Anyone's Blogs / Websites](https://hackerone.com/reports/974222) — Automattic, $0 · 176↑
- [IDOR Vulnerability at AddTagToAssets operation name](https://hackerone.com/reports/2633771) — HackerOne, $0 · 175↑
- [IDOR in the https://market.semrush.com/](https://hackerone.com/reports/837400) — Semrush, $0 · 173↑
- [Getting access of mod logs from any public or restricted subreddit with IDOR vulnerability](https://hackerone.com/reports/1658418) — Reddit, $5,000 · 160↑
- [IDOR vulnerability (Price manipulation)](https://hackerone.com/reports/1403176) — Acronis, $0 · 146↑
- [IDOR and statistics leakage in Orders](https://hackerone.com/reports/544329) — X / xAI, $289 · 141↑
- [IDOR at mtnmobad.mtnbusiness.com.ng leads to PII leakage.](https://hackerone.com/reports/1773609) — MTN Group, $0 · 133↑
- [IDOR on ads.tiktok.com Allows Unauthorized Product Addition](https://hackerone.com/reports/2848610) — TikTok, $500 · 131↑
- [IDOR on in-app hardcoded zombie endpoint](https://hackerone.com/reports/3085742) — Bykea, $0 · 127↑
- [IDOR in https://3d.cs.money/](https://hackerone.com/reports/990878) — CS Money, $0 · 126↑
- [IDOR to view order information of users and personal information](https://hackerone.com/reports/2524562) — WakaTime, $0 · 126↑
- [[api.pandao.ru] IDOR for order delivery address](https://hackerone.com/reports/723461) — Mail.ru, $3,000 · 125↑
- [IDOR leads to leak analytics of any restaurant](https://hackerone.com/reports/1116387) — Uber, $0 · 123↑
- [IDOR for changing privacy settings on any memories](https://hackerone.com/reports/1733627) — TikTok, $0 · 122↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
