---
name: h1-file-reading
description: File disclosure / LFI / path traversal: real-world techniques and chains distilled from 399 disclosed HackerOne reports (top bounty $12,000). Use when hunting file disclosure / lfi / path traversal for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-lfi.
source: reddelexc/hackerone-reports
report_count: 399
top_bounty: 12000
---

# File disclosure / LFI / path traversal — disclosed-report playbook (H1)

Distilled from **399** disclosed HackerOne reports for this class (top bounty **$12,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-lfi` skill for the hunting methodology.

## How to hunt
- Hit every path/file/template parameter with traversal + wrappers (php://, file://).
- PHP filter-chain to RCE; log poisoning; blind read confirmed OOB.
- Cloud/app secrets: /proc, config files, source, AWS creds.
- Escalate read -> source leak -> further chains.

## Patterns in the wild (from report titles)

`path traversal` ×155 · `disclosure` ×77 · `lfi` ×24 · `rce` ×23 · `bypass` ×13 · `api` ×8 · `internal` ×8 · `redirect` ×8 · `leak` ×7 · `unauthenticated` ×6 · `reflected` ×5 · `ato` ×5

## Top disclosed reports

- [HTML-injection in PDF-export leads to LFI](https://hackerone.com/reports/809819) — Visma Public, $500 · 330↑
- [Full read SSRF in www.evernote.com that can leak aws metadata and local file inclusion](https://hackerone.com/reports/1189367) — Evernote, $0 · 262↑
- [Misuse of an authentication cookie combined with a path traversal on app.starbucks.com permitted access to restricted data](https://hackerone.com/reports/876295) — Starbucks, $0 · 239↑
- [Keybase client (Windows 10): Write files anywhere in userland using relative path in "download attachement" feature](https://hackerone.com/reports/713006) — Keybase, $5,000 · 196↑
- [Worker container escape lead to arbitrary file reading in host machine [again]](https://hackerone.com/reports/697055) — Semmle, $2,000 · 178↑
- [Path traversal in filename in LINE Mac client](https://hackerone.com/reports/727727) — LY Corporation, $0 · 174↑
- [Mozilla VPN Clients: RCE via file write and path traversal](https://hackerone.com/reports/2995025) — Mozilla, $6,000 · 172↑
- [XSS Reflected on reddit.com via url path](https://hackerone.com/reports/1051373) — Reddit, $0 · 157↑
- [Path traversal, SSTI and RCE on a MailRu acquisition](https://hackerone.com/reports/536130) — Mail.ru, $2,000 · 152↑
- [[portswigger.net] Path Traversal al /cms/audioitems](https://hackerone.com/reports/2424815) — PortSwigger Web Security, $0 · 145↑
- [Path traversal, to RCE](https://hackerone.com/reports/733072) — GitLab, $12,000 · 142↑
- [Directory Traversal in uftpd 2.6-2.10](https://hackerone.com/reports/694141) — ██████, $0 · 136↑
- [Unauthenticated LFI revealing log information](https://hackerone.com/reports/272578) — Slack, $0 · 123↑
- [Wordpress unzip_file path traversal](https://hackerone.com/reports/205481) — WordPress, $0 · 119↑
- [Path Traversal Vulnerability in Lila Project](https://hackerone.com/reports/3181066) — Lichess, $0 · 116↑
- [SQL injection in URL path leads to Database Access](https://hackerone.com/reports/2633959) — MTN Group, $0 · 114↑
- [Worker container escape lead to arbitrary file reading in host machine](https://hackerone.com/reports/694181) — Semmle, $2,000 · 112↑
- [Zero day path traversal vulnerability in Grafana 8.x allows unauthenticated arbitrary local file read](https://hackerone.com/reports/1415820) — Aiven Ltd, $1,000 · 105↑
- [Lynxview JS interfaces Takeover via deeplink traversal](https://hackerone.com/reports/2417516) — TikTok, $0 · 103↑
- [Path traversal and file disclosure vulnerability in Apache HTTP Server 2.4.49](https://hackerone.com/reports/1394916) — Internet Bug Bounty, $4,000 · 96↑
- [Injection in path parameter of Ingress-nginx](https://hackerone.com/reports/2701701) — Kubernetes, $0 · 89↑
- [Path traversal in Nuget Package Registry](https://hackerone.com/reports/822262) — GitLab, $12,000 · 87↑
- [URL Path Manipulation Enables Cache Poisoning of Amazon Affiliate Products in Shopify Linkpop](https://hackerone.com/reports/1848940) — Shopify, $500 · 85↑
- [SSRF and LFI in site-audit tool](https://hackerone.com/reports/794099) — Semrush, $0 · 85↑
- [Vanilla Forums AddonManager getSingleIndex Directory Traversal File Inclusion Remote Code Execution Vulnerability](https://hackerone.com/reports/411140) — Vanilla, $900 · 84↑
- [Cache Poisoning via uppercase letters in invalid path](https://hackerone.com/reports/960618) — InnoGames, $550 · 82↑
- [Korea - LFI via path traversal at https://msr.istarbucks.co.kr:6443/appif/](https://hackerone.com/reports/780021) — Starbucks, $0 · 81↑
- [File writing by Directory traversal at actionpack-page_caching and RCE by it](https://hackerone.com/reports/519220) — Ruby on Rails, $1,000 · 80↑
- [LFI and SSRF via XXE in emblem editor](https://hackerone.com/reports/347139) — Rockstar Games, $1,500 · 79↑
- [Any one can view collaborater email address via  path /reports//<id/>/participants](https://hackerone.com/reports/1918362) — HackerOne, $0 · 78↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
