---
name: h1-xss
description: Cross-Site Scripting: real-world techniques and chains distilled from 2396 disclosed HackerOne reports (top bounty $20,000). Use when hunting cross-site scripting for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-xss.
source: reddelexc/hackerone-reports
report_count: 2396
top_bounty: 20000
---

# Cross-Site Scripting — disclosed-report playbook (H1)

Distilled from **2396** disclosed HackerOne reports for this class (top bounty **$20,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-xss` skill for the hunting methodology.

## How to hunt
- Reflected/stored/DOM; every sink; context-aware payloads and WAF bypass.
- DOM: sources (location, postMessage) -> sinks (innerHTML, eval).
- Escalate: steal session, CSRF token, or chain to ATO — self-targeted PoC.
- Prove JS execution (not just HTML injection -> that's html-injection).

## Patterns in the wild (from report titles)

`stored` ×661 · `reflected` ×574 · `dom` ×163 · `admin` ×78 · `bypass` ×73 · `api` ×68 · `blind` ×53 · `upload` ×48 · `redirect` ×47 · `ato` ×37 · `rce` ×30 · `csrf` ×30

## Top disclosed reports

- [Bypass for #488147 enables stored XSS on https://paypal.com/signin again](https://hackerone.com/reports/510152) — PayPal, $20,000 · 2683↑
- [Stored XSS on https://paypal.com/signin via cache poisoning](https://hackerone.com/reports/488147) — PayPal, $18,900 · 684↑
- [Reflected XSS on https://www.glassdoor.com/employers/sem-dual-lp/](https://hackerone.com/reports/846338) — Glassdoor, $0 · 684↑
- [Stored XSS in Wiki pages](https://hackerone.com/reports/526325) — GitLab, $0 · 628↑
- [Stored XSS on imgur profile](https://hackerone.com/reports/484434) — Imgur, $0 · 613↑
- [One-click account hijack for anyone using Apple sign-in with Reddit, due to response-type switch + leaking href to XSS on www.redditmedia.com](https://hackerone.com/reports/1567186) — Reddit, $0 · 508↑
- [XSS in steam react chat client](https://hackerone.com/reports/409850) — Valve, $7,500 · 495↑
- [Reflected XSS in OAUTH2 login flow](https://hackerone.com/reports/697099) — LY Corporation, $1,989 · 487↑
- [Cross-Site-Scripting on www.tiktok.com and m.tiktok.com leading to Data Exfiltration](https://hackerone.com/reports/968082) — TikTok, $0 · 472↑
- [XSS vulnerable parameter in a location hash](https://hackerone.com/reports/146336) — Slack, $0 · 455↑
- [Blind XSS on image upload](https://hackerone.com/reports/1010466) — CS Money, $1,000 · 449↑
- [Panorama UI XSS leads to Remote Code Execution via Kick/Disconnect Message](https://hackerone.com/reports/631956) — Valve, $0 · 419↑
- [Stored XSS Vulnerability](https://hackerone.com/reports/643908) — WordPress, $0 · 403↑
- [[accounts.reddit.com] Redirect parameter allows for XSS](https://hackerone.com/reports/1962645) — Reddit, $5,000 · 394↑
- [Reflected XSS on www.hackerone.com and resources.hackerone.com](https://hackerone.com/reports/840759) — HackerOne, $500 · 387↑
- [Reflected XSS and sensitive data exposure, including payment details, on lioncityrentals.com.sg](https://hackerone.com/reports/340431) — Uber, $4,000 · 376↑
- [HEY.com email stored XSS](https://hackerone.com/reports/982291) — Basecamp, $5,000 · 359↑
- [Blind XSS on Twitter's internal Big Data panel at █████████████](https://hackerone.com/reports/1207040) — X / xAI, $0 · 357↑
- [Stored XSS in wordpress.com](https://hackerone.com/reports/733248) — Automattic, $0 · 356↑
- [Reflected XSS in TikTok endpoints](https://hackerone.com/reports/1350887) — TikTok, $0 · 356↑
- [XSS while logging using Google](https://hackerone.com/reports/691611) — Shopify, $1,750 · 341↑
- [Stored XSS in Private Message component (BuddyPress)](https://hackerone.com/reports/487081) — WordPress, $0 · 337↑
- [DOM XSS on duckduckgo.com search](https://hackerone.com/reports/868934) — DuckDuckGo, $0 · 326↑
- [Stored XSS in my staff name fired in another your internal panel](https://hackerone.com/reports/946053) — Shopify, $0 · 326↑
- [yelp.com XSS ATO (via login keylogger, link Google account)](https://hackerone.com/reports/2010530) — Yelp, $0 · 323↑
- [Reflected XSS](https://hackerone.com/reports/739601) — Bumble, $1,000 · 317↑
- [Stored XSS in markdown via the DesignReferenceFilter](https://hackerone.com/reports/1212067) — GitLab, $16,000 · 316↑
- [Stored-XSS-ads.tiktok.com](https://hackerone.com/reports/2306491) — TikTok, $0 · 310↑
- [Stored XSS via Kroki diagram](https://hackerone.com/reports/1731349) — GitLab, $13,950 · 295↑
- [Account takeover through the combination of cookie manipulation and XSS](https://hackerone.com/reports/534450) — Superhuman (formerly Grammarly), $0 · 291↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
