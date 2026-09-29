---
name: h1-api
description: API abuse / insecure API: real-world techniques and chains distilled from 317 disclosed HackerOne reports (top bounty $39,999). Use when hunting api abuse / insecure api for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-api-misconfig.
source: reddelexc/hackerone-reports
report_count: 317
top_bounty: 39999
---

# API abuse / insecure API — disclosed-report playbook (H1)

Distilled from **317** disclosed HackerOne reports for this class (top bounty **$39,999**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-api-misconfig` skill for the hunting methodology.

## How to hunt
- Pull every spec (Swagger/OpenAPI/GraphQL); diff versions (v1/v2/beta/legacy).
- Test BOLA/BFLA, mass assignment, missing rate limits, verbose error leakage.
- Recover undocumented/legacy endpoints from JS bundles + the Wayback Machine.
- Replay privileged calls as a low-priv user; sweep object IDs across tenants.

## Patterns in the wild (from report titles)

`api` ×340 · `leak` ×49 · `token` ×26 · `disclosure` ×24 · `internal` ×18 · `bypass` ×15 · `rce` ×12 · `idor` ×12 · `admin` ×11 · `ato` ×10 · `csrf` ×9 · `unauthenticated` ×9

## Top disclosed reports

- [Exposed Kubernetes API - RCE/Exposed Creds](https://hackerone.com/reports/455645) — Snapchat, $25,000 · 1189↑
- [JumpCloud API Key leaked via Open Github Repository.](https://hackerone.com/reports/716292) — Starbucks, $0 · 739↑
- [[Pre-Submission][H1-4420-2019] API access to Phabricator on code.uberinternal.com from leaked certificate in git repo](https://hackerone.com/reports/591813) — Uber, $39,999 · 453↑
- [Flickr Account Takeover using AWS Cognito API](https://hackerone.com/reports/1342088) — Flickr, $0 · 438↑
- [Denial of service to WP-JSON API by cache poisoning the CORS allow origin header](https://hackerone.com/reports/591302) — Automattic, $0 · 405↑
- [Blind SSRF to internal services in matrix preview_link API](https://hackerone.com/reports/1960765) — Reddit, $6,000 · 343↑
- [Blind SQLi leading to RCE, from Unauthenticated access to a test API Webservice](https://hackerone.com/reports/592400) — Starbucks, $0 · 236↑
- [Google API key leaked to Public](https://hackerone.com/reports/1065041) — FetLife, $0 · 227↑
- [Github Apps can use Scoped-User-To-Server Tokens to Obtain Full Access to User's Projects in Project V2 GraphQL api](https://hackerone.com/reports/1711938) — GitHub, $0 · 198↑
- [DOS via Mutation Aliasing in GraphQL Account Recovery Phone Number Verification API](https://hackerone.com/reports/3287208) — HackerOne, $12,500 · 180↑
- [[IDOR] API endpoint leaking sensitive user information](https://hackerone.com/reports/723118) — Razer, $375 · 172↑
- [Unauthorized Access to TikTok Account [Private Videos] via API Endpoint](https://hackerone.com/reports/2868084) — TikTok, $0 · 165↑
- [Undocumented `fileCopy` GraphQL API](https://hackerone.com/reports/981472) — Shopify, $2,000 · 157↑
- [Banned user still has access to their deleted account via HackerOne's API using their API key](https://hackerone.com/reports/1577940) — HackerOne, $0 · 149↑
- [Public and secret api key leaked  in JavaScript source](https://hackerone.com/reports/983331) — Stripo Inc, $0 · 148↑
- [Bug in GraphQL and API integration leads to limited user address disclosure](https://hackerone.com/reports/473742) — Starbucks, $0 · 144↑
- [Disclose any user's private email through API](https://hackerone.com/reports/196655) — HackerOne, $0 · 140↑
- [Apache Flink RCE via GET jar/plan API Endpoint](https://hackerone.com/reports/1418891) — Aiven Ltd, $6,000 · 133↑
- [Yet Another OTP code Leaked in the API Response](https://hackerone.com/reports/2635315) — MTN Group, $0 · 133↑
- [Git flag injection - Search API with scope 'blobs'](https://hackerone.com/reports/682442) — GitLab, $7,000 · 130↑
- [Client secret, server tokens for developer applications returned by internal API](https://hackerone.com/reports/419655) — Uber, $0 · 125↑
- [Full access to InDrive jira panel via exposed API token](https://hackerone.com/reports/1785145) — inDrive, $0 · 125↑
- ["😂" + Unauthenticated Stored XSS in API at https://api.my.games/comments/v1/comments/update/](https://hackerone.com/reports/853637) — Mail.ru, $0 · 118↑
- [China – Limited Partner PII Regarding Work Scheduling via Unauthenticated API Endpoint](https://hackerone.com/reports/659248) — Starbucks, $0 · 116↑
- [Server-Side Request Forgery (SSRF) via Game Export API](https://hackerone.com/reports/3165242) — Lichess, $0 · 114↑
- [Cross-Site Request Forgery (CSRF) vulnerability on API endpoint allows account takeovers](https://hackerone.com/reports/419891) — Khan Academy, $0 · 111↑
- [Multiple IDORs in family pairing api](https://hackerone.com/reports/1286332) — TikTok, $0 · 107↑
- [Leak ██████████ information in real time through API request](https://hackerone.com/reports/307050) — Grab, $3,000 · 103↑
- [Creation of bounties through Customer API leads to private email disclosure](https://hackerone.com/reports/2382120) — HackerOne, $0 · 101↑
- [Stored XSS on TikTok's backend leads to the leakage of highly sensitive administrator data (Cookies, API Keys, Internal Paths, Emails, phone numbers).](https://hackerone.com/reports/3037447) — TikTok, $0 · 101↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
