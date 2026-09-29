---
name: h1-rce
description: Remote Code Execution: real-world techniques and chains distilled from 336 disclosed HackerOne reports (top bounty $33,510). Use when hunting remote code execution for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-rce.
source: reddelexc/hackerone-reports
report_count: 336
top_bounty: 33510
---

# Remote Code Execution — disclosed-report playbook (H1)

Distilled from **336** disclosed HackerOne reports for this class (top bounty **$33,510**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-rce` skill for the hunting methodology.

## How to hunt
- Injection sinks: template (SSTI), deserialization, command, file-include, upload.
- SSRF -> internal management agents (Jolokia/Actuator/Redis) -> RCE.
- Confirm execution OOB (Collaborator/interactsh); non-destructive proof only (id/hostname).
- This is Critical — stop at proof, never pivot beyond what the report needs.

## Patterns in the wild (from report titles)

`rce` ×227 · `upload` ×18 · `bypass` ×15 · `deserialization` ×13 · `path traversal` ×10 · `unauthenticated` ×9 · `api` ×7 · `privilege` ×6 · `pre-auth` ×6 · `ssrf` ×5 · `escalation` ×5 · `leak` ×5

## Top disclosed reports

- [RCE on Steam Client via buffer overflow in Server Info](https://hackerone.com/reports/470520) — Valve, $0 · 1288↑
- [Potential pre-auth RCE on Twitter VPN](https://hackerone.com/reports/591295) — X / xAI, $20,160 · 1243↑
- [RCE via npm misconfig -- installing internal libraries from the public registry](https://hackerone.com/reports/925585) — PayPal, $30,000 · 941↑
- [H1514 Remote Code Execution on kitcrm using bulk customer update of Priority Products](https://hackerone.com/reports/422944) — Shopify, $0 · 830↑
- [Remote Code Execution on www.semrush.com/my_reports on Logo upload](https://hackerone.com/reports/403417) — Semrush, $0 · 823↑
- [Git flag injection - local file overwrite to remote code execution](https://hackerone.com/reports/658013) — GitLab, $12,000 · 777↑
- [RCE and Complete Server Takeover of http://www.█████.starbucks.com.sg/](https://hackerone.com/reports/502758) — Starbucks, $0 · 571↑
- [RCE when removing metadata with ExifTool](https://hackerone.com/reports/1154542) — GitLab, $20,000 · 508↑
- [Remote Code Execution in Slack desktop apps + bonus](https://hackerone.com/reports/783877) — Slack, $0 · 507↑
- [SQL injection on contactws.contact-sys.com in TScenObject action ScenObjects leads to remote code execution](https://hackerone.com/reports/816254) — QIWI, $0 · 475↑
- [RCE via unsafe inline Kramdown options when rendering certain Wiki pages](https://hackerone.com/reports/1125425) — GitLab, $20,000 · 427↑
- [Panorama UI XSS leads to Remote Code Execution via Kick/Disconnect Message](https://hackerone.com/reports/631956) — Valve, $0 · 419↑
- [Remote code execution on Basecamp.com](https://hackerone.com/reports/365271) — Basecamp, $5,000 · 415↑
- [RCE via the DecompressedArchiveSizeValidator and Project BulkImports (behind feature flag)](https://hackerone.com/reports/1609965) — GitLab, $33,510 · 385↑
- [Multiple bugs leads to RCE on TikTok for Android](https://hackerone.com/reports/1065500) — TikTok, $0 · 371↑
- [RCE on build server via misconfigured pip install](https://hackerone.com/reports/946409) — Yelp, $0 · 366↑
- [RCE on shared.mail.ru due to "widget" plugin](https://hackerone.com/reports/518637) — Mail.ru, $10,000 · 359↑
- [[ RCE ] Through stopping the redirect in /admin/* the attacker able to bypass Authentication And Upload Malicious File](https://hackerone.com/reports/683957) — Mail.ru, $0 · 340↑
- [Unauthenticated RCE in Taskcluster web-server via GraphQL filter argument (sift $where)](https://hackerone.com/reports/3782701) — Mozilla, $12,000 · 331↑
- [RCE via npm misconfig -- installing internal libraries from the public registry](https://hackerone.com/reports/1007014) — Uber, $9,000 · 325↑
- [RCE on TikTok Ads Portal](https://hackerone.com/reports/1024575) — TikTok, $0 · 310↑
- [RCE via github import](https://hackerone.com/reports/1672388) — GitLab, $0 · 271↑
- [Unrestricted File Upload Leads to RCE on mobile.starbucks.com.sg](https://hackerone.com/reports/1027822) — Starbucks, $0 · 247↑
- [Blind SQLi leading to RCE, from Unauthenticated access to a test API Webservice](https://hackerone.com/reports/592400) — Starbucks, $0 · 236↑
- [Unchecked weapon id in WeaponList message parser on client leads to RCE](https://hackerone.com/reports/513154) — Valve, $3,000 · 229↑
- [RCE by command line argument injection to `gm convert` in `/edit/process?a=crop`](https://hackerone.com/reports/212696) — Imgur, $0 · 229↑
- [Unauthenticated SSRF in jira.tochka.com leading to RCE in confluence.bank24.int](https://hackerone.com/reports/713900) — QIWI, $0 · 221↑
- [OOB reads in network message handlers leads to RCE](https://hackerone.com/reports/807772) — Valve, $7,500 · 219↑
- [RCE on CS:GO client using unsanitized entity ID in EntityMsg message](https://hackerone.com/reports/584603) — Valve, $9,000 · 209↑
- [RCE using bash command injection on /system/images (toimitilat.lahitapiola.fi)](https://hackerone.com/reports/303061) — LocalTapiola, $0 · 209↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
