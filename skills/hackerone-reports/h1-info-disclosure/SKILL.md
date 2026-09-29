---
name: h1-info-disclosure
description: Information disclosure: real-world techniques and chains distilled from 345 disclosed HackerOne reports (top bounty $10,000). Use when hunting information disclosure for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-source-leak.
source: reddelexc/hackerone-reports
report_count: 345
top_bounty: 10000
---

# Information disclosure — disclosed-report playbook (H1)

Distilled from **345** disclosed HackerOne reports for this class (top bounty **$10,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-source-leak` skill for the hunting methodology.

## How to hunt
- Source maps, .git/.env exposure, Swagger, debug/stack traces, verbose errors.
- GitHub/dorking for secrets; JS bundles for keys and internal endpoints.
- Directory listing, backup files, and cache/CDN leakage of other users' data.
- Rate impact by the sensitivity of what's exposed (PII/creds >> version banners).

## Patterns in the wild (from report titles)

`disclosure` ×284 · `leak` ×33 · `api` ×28 · `idor` ×19 · `bypass` ×16 · `rce` ×15 · `unauthenticated` ×8 · `token` ×8 · `dom` ×5 · `chain` ×5 · `account takeover` ×5 · `admin` ×5

## Top disclosed reports

- [Sensitive user information disclosure at bonjour.uber.com/marketplace/_rpc via the 'userUuid' parameter](https://hackerone.com/reports/542340) — Uber, $0 · 642↑
- [[Grab Android/iOS] Insecure deeplink leads to sensitive information disclosure](https://hackerone.com/reports/401793) — Grab, $0 · 549↑
- [Web cache poisoning attack leads to user information and more](https://hackerone.com/reports/492841) — Postmates, $500 · 343↑
- [Information Disclosure in /skills call](https://hackerone.com/reports/188719) — HackerOne, $10,000 · 285↑
- [sdrc.starbucks.com - Information Disclosure via unsecured attachment directory](https://hackerone.com/reports/769016) — Starbucks, $0 · 197↑
- [Unauthenticated access to sensitive user information](https://hackerone.com/reports/702677) — Razer, $500 · 184↑
- [Information Disclosure through Sentry Instance ███████](https://hackerone.com/reports/697512) — Eternal, $750 · 178↑
- [[IDOR] API endpoint leaking sensitive user information](https://hackerone.com/reports/723118) — Razer, $375 · 172↑
- [Information disclosure with sensitive data](https://hackerone.com/reports/703600) — Mail.ru, $1,500 · 156↑
- [Information disclosure via a misconfigured third-party product](https://hackerone.com/reports/739251) — Algolia, $0 · 156↑
- [information disclosure of secret_key_base via encoding charcters](https://hackerone.com/reports/460545) — GitLab, $3,500 · 146↑
- [[c-api.city-mobil.ru] Client authentication bypass leads to information disclosure](https://hackerone.com/reports/772118) — Mail.ru, $0 · 143↑
- [[Information Disclosure] Amazon S3 Bucket of Shopify Ping (iOS) have public access of other users image](https://hackerone.com/reports/1021906) — Shopify, $2,900 · 135↑
- [IDOR at mtnmobad.mtnbusiness.com.ng leads to PII leakage.](https://hackerone.com/reports/1773609) — MTN Group, $0 · 133↑
- [Vine all registered user Private/sensitive information disclosure .[ Ip address/phone no/email and many other informations ]](https://hackerone.com/reports/202823) — X / xAI, $0 · 121↑
- [PII Disclosure At `theperfumeshop.com/register/forOrder`](https://hackerone.com/reports/1618100) — A.S. Watson Group, $0 · 118↑
- [China – Limited Partner PII Regarding Work Scheduling via Unauthenticated API Endpoint](https://hackerone.com/reports/659248) — Starbucks, $0 · 116↑
- [[Zomato Order] Insecure deeplink leads to sensitive information disclosure](https://hackerone.com/reports/532225) — Eternal, $750 · 113↑
- [Sensitive Information Disclosure via Back Button Post Logout on https://apps.nextcloud.com/account/](https://hackerone.com/reports/2946927) — Nextcloud, $0 · 113↑
- [Broken Access Control (IDOR) in Booking Detail and Bids Could Leads to Sensitive Information Disclosure](https://hackerone.com/reports/2374730) — Bykea, $0 · 106↑
- [Public google drive link Exposes Military Orders Containing PII (Name, SSN etc..) and Operational Details](https://hackerone.com/reports/2926447) — U.S. Dept Of Defense, $0 · 99↑
- [Lack of rate limiting in https://███/PKI/PassReset.aspx leads to PII disclosure and potential account takeover](https://hackerone.com/reports/2748003) — U.S. Dept Of Defense, $0 · 98↑
- [Cross-origin resource sharing misconfig | steal user information](https://hackerone.com/reports/235200) — Semrush, $0 · 97↑
- [[███████] Information disclosure due unauthenticated access to APIs and system browser functions](https://hackerone.com/reports/2122964) — U.S. Dept Of Defense, $0 · 97↑
- [Critical Information Disclosure via /talos/api/v1/files/upload](https://hackerone.com/reports/3228011) — Bykea, $0 · 95↑
- [Information Disclosure of metrics fax.wavecell.com/metrics](https://hackerone.com/reports/1365076) — 8x8, $0 · 92↑
- [███ leaking PII of tour visitors (names, email addresses, phone numbers) via misconfigured record permissions](https://hackerone.com/reports/2294930) — U.S. Dept Of Defense, $0 · 89↑
- [Disclosure of User Information](https://hackerone.com/reports/753725) — Nord Security, $0 · 88↑
- [Information disclosure by sending a GIF](https://hackerone.com/reports/1801427) — LinkedIn, $0 · 84↑
- [Possible PII Disclosure via Advanced Vetting Process - ██████](https://hackerone.com/reports/2421796) — HackerOne, $2,500 · 82↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
