---
name: h1-ssti
description: Server-Side Template Injection: real-world techniques and chains distilled from 12 disclosed HackerOne reports (top bounty $2,300). Use when hunting server-side template injection for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-ssti.
source: reddelexc/hackerone-reports
report_count: 12
top_bounty: 2300
---

# Server-Side Template Injection — disclosed-report playbook (H1)

Distilled from **12** disclosed HackerOne reports for this class (top bounty **$2,300**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-ssti` skill for the hunting methodology.

## How to hunt
- Probe math in {{ }} / ${ } across Jinja2/Twig/Freemarker/ERB/Velocity.
- Fingerprint engine from behavior, then use the engine-specific RCE gadget.
- Targets: email/PDF/report templates, CMS preview, error pages with input.
- Confirm code exec OOB; benign proof only.

## Patterns in the wild (from report titles)

`ssti` ×3 · `rce` ×2

## Top disclosed reports

- [H1514 Server Side Template Injection in Return Magic email templates?](https://hackerone.com/reports/423541) — Shopify, $0 · 409↑
- [Path traversal, SSTI and RCE on a MailRu acquisition](https://hackerone.com/reports/536130) — Mail.ru, $2,000 · 152↑
- [Urgent: Server side template injection via Smarty template allows for RCE](https://hackerone.com/reports/164224) — Unikrn, $0 · 122↑
- [Reflected XSS and Server Side Template Injection  in all HubSpot CMSes](https://hackerone.com/reports/399462) — HubSpot Inactive, $0 · 64↑
- [Python : Add query to detect Server Side Template Injection](https://hackerone.com/reports/944359) — GitHub Security Lab, $0 · 29↑
- [Server Side Template Injection on Name parameter during Sign Up process](https://hackerone.com/reports/1104349) — Glovo, $0 · 27↑
- [SSTI leads to Command injection](https://hackerone.com/reports/3584149) — curl, $0 · 24↑
- [[Ruby]: Server Side Template Injection](https://hackerone.com/reports/1928279) — GitHub Security Lab, $2,300 · 13↑
- [CodeQL query to detect Server-Side Template Injections (JavaScript)](https://hackerone.com/reports/894872) — GitHub Security Lab, $0 · 8↑
- [Server-side Template Injection in lodash.js](https://hackerone.com/reports/904672) — Node.js third-party modules, $0 · 8↑
- [Server-side template injection at ujs test server](https://hackerone.com/reports/942103) — Ruby on Rails, $0 · 5↑
- [Java : Add query to detect Server Side Template Injection (SSTI)](https://hackerone.com/reports/1490372) — GitHub Security Lab, $0 · 4↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
