---
name: h1-ssrf
description: Server-Side Request Forgery: real-world techniques and chains distilled from 316 disclosed HackerOne reports (top bounty $25,000). Use when hunting server-side request forgery for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-ssrf.
source: reddelexc/hackerone-reports
report_count: 316
top_bounty: 25000
---

# Server-Side Request Forgery — disclosed-report playbook (H1)

Distilled from **316** disclosed HackerOne reports for this class (top bounty **$25,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-ssrf` skill for the hunting methodology.

## How to hunt
- Every URL-fetch/import/webhook/preview/PDF feature; blind cases OOB-confirmed.
- Cloud metadata (169.254.169.254, IMDSv1), internal ports, gopher->Redis.
- Filter bypass: DNS rebinding, decimal/hex IP, redirects, alternate schemes.
- Escalate to credential theft / internal RCE; stop at proof.

## Patterns in the wild (from report titles)

`ssrf` ×297 · `blind` ×57 · `bypass` ×33 · `internal` ×33 · `api` ×22 · `upload` ×14 · `disclosure` ×11 · `aws` ×9 · `unauthenticated` ×8 · `metadata` ×7 · `rce` ×7 · `dom` ×6

## Top disclosed reports

- [My Expense Report resulted in a Server-Side Request Forgery (SSRF) on Lyft](https://hackerone.com/reports/885975) — Lyft, $0 · 653↑
- [SSRF in Exchange leads to ROOT access in all instances](https://hackerone.com/reports/341876) — Shopify, $0 · 583↑
- [Server Side Request Forgery (SSRF) via Analytics Reports](https://hackerone.com/reports/2262382) — HackerOne, $25,000 · 524↑
- [Server-Side Request Forgery using Javascript allows to exfill data from Google Metadata](https://hackerone.com/reports/530974) — Snapchat, $0 · 420↑
- [Server Side Request Forgery (SSRF) at app.hellosign.com leads to AWS private keys disclosure](https://hackerone.com/reports/923132) — Dropbox, $4,913 · 360↑
- [SSRF on project import via the remote_attachment_url on a Note](https://hackerone.com/reports/826361) — GitLab, $10,000 · 359↑
- [Server Side Request Forgery mitigation bypass](https://hackerone.com/reports/632101) — GitLab, $0 · 350↑
- [Blind SSRF to internal services in matrix preview_link API](https://hackerone.com/reports/1960765) — Reddit, $6,000 · 343↑
- [SSRF & LFR via on city-mobil.ru](https://hackerone.com/reports/748123) — Mail.ru, $0 · 343↑
- [Full Response SSRF via Google Drive](https://hackerone.com/reports/1406938) — Dropbox, $17,576 · 302↑
- [SSRF  leaking internal google cloud data through upload function [SSH Keys, etc..]](https://hackerone.com/reports/549882) — Vimeo, $0 · 276↑
- [SSRF on fleet.city-mobil.ru leads to local file read](https://hackerone.com/reports/748069) — Mail.ru, $0 · 272↑
- [Full read SSRF in www.evernote.com that can leak aws metadata and local file inclusion](https://hackerone.com/reports/1189367) — Evernote, $0 · 262↑
- [SSRF in graphQL query (pwapi.ex2b.com)](https://hackerone.com/reports/1864188) — EXNESS, $3,000 · 261↑
- [Unauthenticated blind SSRF in OAuth Jira authorization controller](https://hackerone.com/reports/398799) — GitLab, $4,000 · 238↑
- [SSRF & LFR on city-mobil.ru](https://hackerone.com/reports/748128) — Mail.ru, $0 · 237↑
- [Full Read SSRF on Gitlab's Internal Grafana](https://hackerone.com/reports/878779) — GitLab, $0 · 229↑
- [Unsafe charts embedding implementation leads to cross-account stored XSS and SSRF](https://hackerone.com/reports/708589) — New Relic, $0 · 225↑
- [Unauthenticated SSRF in jira.tochka.com leading to RCE in confluence.bank24.int](https://hackerone.com/reports/713900) — QIWI, $0 · 221↑
- [SSRF in webhooks leads to AWS private keys disclosure](https://hackerone.com/reports/508459) — Omise, $0 · 214↑
- [Stored XSS & SSRF in Lark Docs](https://hackerone.com/reports/892049) — Lark Technologies, $3,000 · 178↑
- [SSRF on duckduckgo.com/iu/](https://hackerone.com/reports/398641) — DuckDuckGo, $0 · 165↑
- [Server Side Request Forgery](https://hackerone.com/reports/644238) — Lark Technologies, $0 · 164↑
- [SSRF in Autodesk Rendering leading to account takeover](https://hackerone.com/reports/3024673) — Autodesk, $0 · 161↑
- [External SSRF and Local File Read via video upload due to vulnerable FFmpeg HLS processing](https://hackerone.com/reports/1062888) — TikTok, $2,727 · 159↑
- [SSRF chained to hit internal host leading to another SSRF which allows to read internal images.](https://hackerone.com/reports/826097) — PlayStation, $1,000 · 147↑
- [Blind SSRF on errors.hackerone.net due to Sentry misconfiguration](https://hackerone.com/reports/374737) — HackerOne, $3,500 · 143↑
- [DNS Rebinding SSRF in Burp Suite MCP Server Enables Internal Network Access via send_http1_request Tool](https://hackerone.com/reports/3176157) — PortSwigger Web Security, $0 · 142↑
- [SSRF in https://couriers.indrive.com/api/file-storage](https://hackerone.com/reports/2300358) — inDrive, $0 · 141↑
- [Server Side Request Forgery (SSRF) in webhook functionality](https://hackerone.com/reports/2301565) — HackerOne, $2,500 · 137↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
