---
name: h1-xxe
description: XML External Entity: real-world techniques and chains distilled from 55 disclosed HackerOne reports (top bounty $6,000). Use when hunting xml external entity for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-xxe.
source: reddelexc/hackerone-reports
report_count: 55
top_bounty: 6000
---

# XML External Entity — disclosed-report playbook (H1)

Distilled from **55** disclosed HackerOne reports for this class (top bounty **$6,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-xxe` skill for the hunting methodology.

## How to hunt
- Any XML/SVG/DOCX/SOAP/SAML parser; classic and blind OOB (DTD callback).
- Escalate XXE -> LFI, SSRF, and occasionally RCE.
- OOB-or-it-didn't-happen for blind; Collaborator confirmation.
- Parameter entities when inline entities are filtered.

## Patterns in the wild (from report titles)

`xxe` ×54 · `blind` ×7 · `rce` ×5 · `ssrf` ×4 · `upload` ×4 · `bypass` ×3 · `lfi` ×2

## Top disclosed reports

- [XXE at ecjobs.starbucks.com.cn/retail/hxpublic_v6/hxdynamicpage6.aspx](https://hackerone.com/reports/500515) — Starbucks, $0 · 319↑
- [XXE on pulse.mail.ru](https://hackerone.com/reports/505947) — Mail.ru, $6,000 · 264↑
- [XXE on sms-be-vip.twitter.com in SXMP Processor](https://hackerone.com/reports/248668) — X / xAI, $0 · 258↑
- [XXE on https://duckduckgo.com](https://hackerone.com/reports/483774) — DuckDuckGo, $0 · 218↑
- [Phone Call to XXE via Interactive Voice Response](https://hackerone.com/reports/395296) — ██████, $0 · 172↑
- [Partial bypass of #483774 with Blind XXE on https://duckduckgo.com](https://hackerone.com/reports/486732) — DuckDuckGo, $0 · 159↑
- [Multiple endpoints are vulnerable to XML External Entity injection (XXE)](https://hackerone.com/reports/72272) — Pornhub, $2,500 · 138↑
- [XXE through injection of a payload in the XMP metadata of a JPEG file](https://hackerone.com/reports/836877) — Informatica, $0 · 138↑
- [XXE in Site Audit function exposing file and directory contents](https://hackerone.com/reports/312543) — Semrush, $0 · 115↑
- [XXE Injection through SVG image upload leads to SSRF](https://hackerone.com/reports/897244) — Zivver, $0 · 112↑
- [XXE in DoD website that may lead to RCE](https://hackerone.com/reports/227880) — U.S. Dept Of Defense, $0 · 97↑
- [[RCE] Unserialize to XXE - file disclosure on ams.upload.pornhub.com](https://hackerone.com/reports/142562) — Pornhub, $0 · 90↑
- [Blind XXE via Powerpoint files](https://hackerone.com/reports/334488) — Open-Xchange, $2,000 · 86↑
- [LFI and SSRF via XXE in emblem editor](https://hackerone.com/reports/347139) — Rockstar Games, $1,500 · 79↑
- [blind XXE in autodiscover parser](https://hackerone.com/reports/315837) — Mail.ru, $0 · 70↑
- [Blind OOB XXE At "http://ubermovement.com/"](https://hackerone.com/reports/154096) — Uber, $500 · 56↑
- [XXE на webdav.mail.ru -  PROPFIND/PROPPATCH](https://hackerone.com/reports/758978) — Mail.ru, $0 · 54↑
- [XXE on ██████████ by bypassing WAF ████](https://hackerone.com/reports/433996) — QIWI, $0 · 53↑
- [RCE via Local File Read -/> php unserialization-/> XXE -/> unpickling](https://hackerone.com/reports/415501) — h1-5411-CTF, $0 · 46↑
- [[rev-app.informatica.com] - XXE](https://hackerone.com/reports/105434) — Informatica, $0 · 45↑
- [XML External Entity (XXE) in qiwi.com + waf bypass](https://hackerone.com/reports/99279) — QIWI, $0 · 41↑
- [Authenticated XXE](https://hackerone.com/reports/1095645) — WordPress, $0 · 41↑
- [XXE on DoD web server](https://hackerone.com/reports/188743) — U.S. Dept Of Defense, $0 · 37↑
- [[HTA2] XXE on https://███ via SpellCheck Endpoint.](https://hackerone.com/reports/715949) — U.S. Dept Of Defense, $0 · 37↑
- [XML Parser Bug: XXE over which leads to RCE](https://hackerone.com/reports/55431) — drchrono, $0 · 35↑
- [Singapore - XXE at https://www.starbucks.com.sg/RestApi/soap11](https://hackerone.com/reports/762251) — Starbucks, $0 · 32↑
- [[app.informaticaondemand.com] XXE](https://hackerone.com/reports/105753) — Informatica, $0 · 25↑
- [Non-production Open Database In Combination With XXE Leads To SSRF](https://hackerone.com/reports/742808) — Evernote, $0 · 25↑
- [Blind XXE on my.mail.ru](https://hackerone.com/reports/276276) — Mail.ru, $800 · 23↑
- [XXE in upload file feature](https://hackerone.com/reports/105787) — Informatica, $0 · 22↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
