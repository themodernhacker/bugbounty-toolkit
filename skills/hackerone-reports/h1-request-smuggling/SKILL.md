---
name: h1-request-smuggling
description: HTTP request smuggling: real-world techniques and chains distilled from 52 disclosed HackerOne reports (top bounty $7,500). Use when hunting http request smuggling for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-http-smuggling.
source: reddelexc/hackerone-reports
report_count: 52
top_bounty: 7500
---

# HTTP request smuggling — disclosed-report playbook (H1)

Distilled from **52** disclosed HackerOne reports for this class (top bounty **$7,500**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-http-smuggling` skill for the hunting methodology.

## How to hunt
- CL.TE / TE.CL / H2.CL / H2.TE on CDN+origin stacks; use HTTP Request Smuggler.
- Confirm with the time-delay technique before impact.
- Escalate: cache poisoning, credential capture, auth bypass via smuggled prefix.
- Be careful — poisoning affects other users; keep PoC self-targeted.

## Patterns in the wild (from report titles)

`smuggling` ×52 · `account takeover` ×2 · `ato` ×2 · `api` ×2

## Top disclosed reports

- [Mass account takeovers using HTTP Request Smuggling on https://slackb.com/ to steal session cookies](https://hackerone.com/reports/737140) — Slack, $0 · 868↑
- [Request smuggling on admin-official.line.me could lead to account takeover](https://hackerone.com/reports/740037) — LY Corporation, $0 · 564↑
- [Stealing Zomato X-Access-Token: in Bulk using HTTP Request Smuggling on api.zomato.com](https://hackerone.com/reports/771666) — Eternal, $0 · 559↑
- [Password theft login.newrelic.com via Request Smuggling](https://hackerone.com/reports/498052) — New Relic, $3,000 · 490↑
- [HTTP request Smuggling](https://hackerone.com/reports/867952) — Helium, $0 · 300↑
- [HTTP Request Smuggling via HTTP/2](https://hackerone.com/reports/1211724) — Basecamp, $7,500 · 298↑
- [HTTP request smuggling (?) canpol.deti.mail.ru](https://hackerone.com/reports/957881) — Mail.ru, $5,000 · 241↑
- [HTTP Request Smuggling on https://labs.data.gov](https://hackerone.com/reports/726773) — GSA Bounty, $750 · 160↑
- [HTTP Request Smuggling at app.workbox.dk](https://hackerone.com/reports/919988) — Visma Public, $500 · 139↑
- [HTTP Request Smuggling due to CR-to-Hyphen conversion](https://hackerone.com/reports/922597) — Node.js, $0 · 134↑
- [HTTP Request Smuggling on vpn.lob.com](https://hackerone.com/reports/694604) — Lob, $500 · 123↑
- [HTTP Request Smuggling in Transform Rules using hexadecimal escape sequences in the concat() function](https://hackerone.com/reports/1478633) — Cloudflare Public Bug Bounty, $6,000 · 116↑
- [HTTP request smuggling using malformed Transfer-Encoding header](https://hackerone.com/reports/735748) — Node.js, $0 · 105↑
- [Possibility of Request smuggling attack](https://hackerone.com/reports/2280391) — Internet Bug Bounty, $4,660 · 93↑
- [CVE-2024-21733 Apache Tomcat HTTP Request Smuggling (Client- Side Desync) (CWE: 444)](https://hackerone.com/reports/2327341) — Internet Bug Bounty, $4,660 · 57↑
- [Potential HTTP Request Smuggling in ruby webrick](https://hackerone.com/reports/965267) — Ruby, $0 · 53↑
- [Request Smuggling in Apache Tomcat (Important, CVE-2023-45648)](https://hackerone.com/reports/2299692) — Internet Bug Bounty, $4,660 · 51↑
- [HTTP Request Smuggling via Connection: close/<TAB/> in Node.js llhttp parser](https://hackerone.com/reports/3723248) — Node.js, $0 · 49↑
- [HTTP request smuggling with Origin Rules using newlines in the host_header action parameter](https://hackerone.com/reports/1575912) — Cloudflare Public Bug Bounty, $3,100 · 46↑
- [HTTP Request Smuggling](https://hackerone.com/reports/1120982) — U.S. Dept Of Defense, $0 · 40↑
- [Potential HTTP Request Smuggling in nodejs](https://hackerone.com/reports/1002188) — Node.js, $250 · 34↑
- [HTTP Request Smuggling on api.flocktory.com Leads to XSS on Customer Sites](https://hackerone.com/reports/955170) — QIWI, $0 · 29↑
- [HTTP request smuggling on Basecamp 2 allows web cache poisoning](https://hackerone.com/reports/919175) — Basecamp, $0 · 28↑
- [Unauthenticated request smuggling on launchpad.37signals.com](https://hackerone.com/reports/867577) — Basecamp, $0 · 26↑
- [Request smuggling on ████████](https://hackerone.com/reports/526880) — U.S. Dept Of Defense, $0 · 25↑
- [http request smuggling in pscp.tv and periscope.tv](https://hackerone.com/reports/713285) — X / xAI, $560 · 24↑
- [HTTP Request Smuggling Vulnerability Analysis - cURL Security Report](https://hackerone.com/reports/3249936) — curl, $0 · 23↑
- [Apache HTTP Server: mod_proxy_ajp: Possible request smuggling](https://hackerone.com/reports/1594627) — Internet Bug Bounty, $2,400 · 21↑
- [Request Smuggling vulnerability due a vulnerable skipper reverse proxy running in the environment.](https://hackerone.com/reports/711679) — Razer, $375 · 18↑
- [HTTP Request Smuggling due to accepting space before colon](https://hackerone.com/reports/1238709) — Node.js, $250 · 18↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
