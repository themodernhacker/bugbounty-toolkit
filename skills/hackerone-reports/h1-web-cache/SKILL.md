---
name: h1-web-cache
description: Web cache poisoning / deception: real-world techniques and chains distilled from 30 disclosed HackerOne reports (top bounty $9,700). Use when hunting web cache poisoning / deception for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-cache-poison.
source: reddelexc/hackerone-reports
report_count: 30
top_bounty: 9700
---

# Web cache poisoning / deception — disclosed-report playbook (H1)

Distilled from **30** disclosed HackerOne reports for this class (top bounty **$9,700**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-cache-poison` skill for the hunting methodology.

## How to hunt
- Find unkeyed inputs (X-Forwarded-Host/-Scheme, headers) reflected in cached responses.
- Web Cache Deception: static-ext trick to cache authenticated pages.
- Confirm the poisoned/deceived response is served to ANOTHER user (self-targeted PoC).
- CDN path-normalization differences (Cloudflare/Fastly/GCP).

## Patterns in the wild (from report titles)

`cache` ×31 · `token` ×5 · `leak` ×4 · `csrf` ×3 · `disclosure` ×3 · `stored` ×2 · `dom` ×2

## Top disclosed reports

- [DoS on PayPal via web cache poisoning](https://hackerone.com/reports/622122) — PayPal, $9,700 · 851↑
- [Web cache poisoning attack leads to user information and more](https://hackerone.com/reports/492841) — Postmates, $500 · 343↑
- [Web Cache Poisoning leads to Stored XSS](https://hackerone.com/reports/1424094) — Glassdoor, $0 · 133↑
- [Defacement of catalog.data.gov via web cache poisoning to stored DOMXSS](https://hackerone.com/reports/303730) — GSA Bounty, $750 · 93↑
- [https://themes.shopify.com::: Host header web cache poisoning lead to DoS](https://hackerone.com/reports/1096609) — Shopify, $2,900 · 82↑
- [Web Cache Poisoning leads to XSS and DoS](https://hackerone.com/reports/1621540) — Glassdoor, $0 · 71↑
- [web cache deception in https://tradus.com lead to name/user_id enumeration and other info](https://hackerone.com/reports/537564) — OLX, $0 · 63↑
- [Web Cache Deception](https://hackerone.com/reports/2265400) — Glassdoor, $0 · 62↑
- [[https://www.glassdoor.com] -  Web Cache Deception Leads to gdtoken Disclosure](https://hackerone.com/reports/1343086) — Glassdoor, $0 · 60↑
- [CSRF-tokens on pages without no-cache headers, resulting in ATO when using CloudFlare proxy (Web Cache Deception)](https://hackerone.com/reports/260697) — Discourse, $0 · 58↑
- [Web Cache Deception Attack (XSS)](https://hackerone.com/reports/394016) — Discourse, $256 · 51↑
- [Shopify.com Web Cache Deception vulnerability leads to personal information and CSRF tokens leakage](https://hackerone.com/reports/1271944) — Shopify, $800 · 48↑
- [Web cache deception attack on https://open.vanillaforums.com/messages/all](https://hackerone.com/reports/593712) — Vanilla, $150 · 47↑
- [Web Cache Deception vulnerability on algolia.com leads to personal information leakage](https://hackerone.com/reports/1530066) — Algolia, $400 · 46↑
- [Web Cache poisoning attack leads to User information Disclosure and more](https://hackerone.com/reports/631589) — Lyst, $0 · 45↑
- [Web cache poisoning leads to disclosure of CSRF token and sensitive information](https://hackerone.com/reports/504514) — Smule, $0 · 39↑
- [Web Cache Poisoning on  █████](https://hackerone.com/reports/1183263) — U.S. Dept Of Defense, $0 · 36↑
- [Web cache poisoning at www.acronis.com](https://hackerone.com/reports/1010858) — Acronis, $0 · 29↑
- [Web cache deception attack - expose token information](https://hackerone.com/reports/397508) — Chaturbate, $0 · 28↑
- [HTTP request smuggling on Basecamp 2 allows web cache poisoning](https://hackerone.com/reports/919175) — Basecamp, $0 · 28↑
- [Web Cache Deception Attack (XSS)](https://hackerone.com/reports/504261) — Algolia, $0 · 26↑
- [https://help.nextcloud.com::: Web cache poisoning attack](https://hackerone.com/reports/429747) — Nextcloud, $0 · 25↑
- [Web cache information leakage at sbermarket.ru](https://hackerone.com/reports/893353) — Mail.ru, $400 · 22↑
- [[*.rocketbank.ru] Web Cache Deception & XSS](https://hackerone.com/reports/415168) — QIWI, $0 · 21↑
- [Several domains on kaspersky.com are vulnerable to Web Cache Deception attack](https://hackerone.com/reports/1185028) — Kaspersky, $0 · 20↑
- [Web Cache Poisoning leading to DoS](https://hackerone.com/reports/1346618) — U.S. General Services Administration, $0 · 19↑
- [Web Cache Poisoning](https://hackerone.com/reports/534297) — Mail.ru, $0 · 17↑
- [[okmedia.insideok.ru] Web Cache Poisoing & XSS](https://hackerone.com/reports/550266) — ok.ru, $0 · 14↑
- [Information Leakage via TikTok Ads Web Cache Deception](https://hackerone.com/reports/1484468) — TikTok, $0 · 14↑
- [Web cache deception attack - expose earning state information](https://hackerone.com/reports/439021) — Semrush, $0 · 10↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
