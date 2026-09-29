---
name: h1-sqli
description: SQL injection: real-world techniques and chains distilled from 307 disclosed HackerOne reports (top bounty $25,000). Use when hunting sql injection for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-sqli.
source: reddelexc/hackerone-reports
report_count: 307
top_bounty: 25000
---

# SQL injection — disclosed-report playbook (H1)

Distilled from **307** disclosed HackerOne reports for this class (top bounty **$25,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-sqli` skill for the hunting methodology.

## How to hunt
- Every param, header, and JSON field; error-based, boolean/time blind, second-order.
- ORM raw fragments, GraphQL/SOQL args, WAF bypass encodings.
- sqlmap for confirmation; prove data access minimally (version(), one benign row).
- Never dump real customer data — one-row proof is enough.

## Patterns in the wild (from report titles)

`blind` ×48 · `sqli` ×35 · `api` ×23 · `bypass` ×9 · `ato` ×9 · `admin` ×7 · `rce` ×4 · `unauthenticated` ×3 · `token` ×3 · `dom` ×2 · `aws` ×2 · `disclosure` ×2

## Top disclosed reports

- [SQL Injection Extracts Starbucks Enterprise Accounting, Financial, Payroll Database](https://hackerone.com/reports/531051) — Starbucks, $0 · 800↑
- [SQL injection in https://labs.data.gov/dashboard/datagov/csv_to_json via User-agent](https://hackerone.com/reports/297478) — GSA Bounty, $0 · 699↑
- [Time-Based SQL injection at city-mobil.ru](https://hackerone.com/reports/868436) — Mail.ru, $15,000 · 631↑
- [SQL injection at https://sea-web.gold.razer.com/ajax-get-status.php via txid parameter](https://hackerone.com/reports/819738) — Razer, $2,000 · 580↑
- [SQL Injection in https://api-my.pay.razer.com/inviteFriend/getInviteHistoryLog](https://hackerone.com/reports/811111) — Razer, $2,000 · 528↑
- [SQL injection on contactws.contact-sys.com in TScenObject action ScenObjects leads to remote code execution](https://hackerone.com/reports/816254) — QIWI, $0 · 475↑
- [Blind SQL Injection](https://hackerone.com/reports/758654) — InnoGames, $2,000 · 432↑
- [SQL Injection in report_xml.php through countryFilter[] parameter](https://hackerone.com/reports/383127) — Valve, $25,000 · 407↑
- [SQL injection at fleet.city-mobil.ru](https://hackerone.com/reports/881901) — Mail.ru, $10,000 · 372↑
- [[windows10.hi-tech.mail.ru]  Blind SQL Injection](https://hackerone.com/reports/786044) — Mail.ru, $5,000 · 330↑
- [[www.zomato.com] SQLi - /php/██████████ - item_id](https://hackerone.com/reports/403616) — Eternal, $4,500 · 326↑
- [SQL Injection on cookie parameter](https://hackerone.com/reports/761304) — MTN Group, $0 · 323↑
- [SQL Injection at https://sea-web.gold.razer.com/lab/cash-card-incomplete-translog-resend via period-hour Parameter](https://hackerone.com/reports/781205) — Razer, $2,000 · 240↑
- [SQL Injection in agent-manager](https://hackerone.com/reports/962889) — Acronis, $0 · 237↑
- [Blind SQLi leading to RCE, from Unauthenticated access to a test API Webservice](https://hackerone.com/reports/592400) — Starbucks, $0 · 236↑
- [[api.easy2pay.co]  SQL Injection at fortumo via TransID parameter [Bypassing Signature Validation🔥]](https://hackerone.com/reports/894325) — Razer, $4,000 · 232↑
- [SQL Injection in www.hyperpure.com](https://hackerone.com/reports/1044716) — Eternal, $2,000 · 229↑
- [Boolean-based SQL Injection on relap.io](https://hackerone.com/reports/745938) — Mail.ru, $0 · 227↑
- [Blind SQL Injection in city-mobil.ru domain](https://hackerone.com/reports/711075) — Mail.ru, $2,000 · 224↑
- [Blind SQL injection and making any profile comments from any users to disappear using "like" function (2 in 1 issues)](https://hackerone.com/reports/363815) — Pornhub, $0 · 211↑
- [Blind SQL Injection on starbucks.com.gt and WAF Bypass  :*](https://hackerone.com/reports/549355) — Starbucks, $0 · 210↑
- [www.drivegrab.com SQL injection](https://hackerone.com/reports/273946) — Grab, $4,500 · 203↑
- [Blind SQL injection on id.indrive.com](https://hackerone.com/reports/2051931) — inDrive, $4,134 · 199↑
- [Remote Code Execution on contactws.contact-sys.com via SQL injection in TCertObject operation "Delete"](https://hackerone.com/reports/816086) — QIWI, $0 · 194↑
- [SQLi at https://sea-web.gold.razer.com/demo-th/purchase-result.php via orderid Parameter](https://hackerone.com/reports/777693) — Razer, $2,000 · 183↑
- [Blind SQL injection in Hall of Fap](https://hackerone.com/reports/295841) — Pornhub, $0 · 179↑
- [SQL injection in GraphQL endpoint through embedded_submission_form_uuid parameter](https://hackerone.com/reports/435066) — HackerOne, $0 · 174↑
- [Sql injection on docs.atavist.com](https://hackerone.com/reports/1039315) — Automattic, $0 · 170↑
- [bypass sql injection #1109311](https://hackerone.com/reports/1224660) — Acronis, $0 · 164↑
- [SQL Injection [unauthenticated] with direct output at https://news.mail.ru/](https://hackerone.com/reports/818972) — Mail.ru, $7,500 · 156↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
