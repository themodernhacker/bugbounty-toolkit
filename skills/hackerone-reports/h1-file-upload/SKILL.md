---
name: h1-file-upload
description: File upload vulnerabilities: real-world techniques and chains distilled from 158 disclosed HackerOne reports (top bounty $5,000). Use when hunting file upload vulnerabilities for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-file-upload.
source: reddelexc/hackerone-reports
report_count: 158
top_bounty: 5000
---

# File upload vulnerabilities — disclosed-report playbook (H1)

Distilled from **158** disclosed HackerOne reports for this class (top bounty **$5,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-file-upload` skill for the hunting methodology.

## How to hunt
- Bypass tables: double ext, magic bytes, content-type, .htaccess, SVG/HTML.
- Webshell -> direct request -> RCE; SVG/HTML -> stored XSS; DOCX/ZIP -> XXE/zip-slip.
- Path traversal in filename; overwrite sensitive files.
- Prove execution/XSS on a resource you uploaded.

## Patterns in the wild (from report titles)

`upload` ×166 · `stored` ×15 · `rce` ×12 · `ssrf` ×12 · `bypass` ×9 · `api` ×7 · `disclosure` ×5 · `blind` ×4 · `unauthenticated` ×4 · `redirect` ×4 · `leak` ×4 · `dom` ×3

## Top disclosed reports

- [Remote Code Execution on www.semrush.com/my_reports on Logo upload](https://hackerone.com/reports/403417) — Semrush, $0 · 823↑
- [Webshell via File Upload on ecjobs.starbucks.com.cn](https://hackerone.com/reports/506646) — Starbucks, $0 · 688↑
- [Blind XSS on image upload](https://hackerone.com/reports/1010466) — CS Money, $1,000 · 449↑
- [Unrestricted file upload on [ambassador.mail.ru]](https://hackerone.com/reports/854032) — Mail.ru, $3,000 · 404↑
- [[ RCE ] Through stopping the redirect in /admin/* the attacker able to bypass Authentication And Upload Malicious File](https://hackerone.com/reports/683957) — Mail.ru, $0 · 340↑
- [SSRF  leaking internal google cloud data through upload function [SSH Keys, etc..]](https://hackerone.com/reports/549882) — Vimeo, $0 · 276↑
- [Unrestricted file upload leads to Stored XSS](https://hackerone.com/reports/808862) — Visma Public, $250 · 268↑
- [Unrestricted File Upload Leads to RCE on mobile.starbucks.com.sg](https://hackerone.com/reports/1027822) — Starbucks, $0 · 247↑
- [Arbitrary File Upload to Stored XSS](https://hackerone.com/reports/808821) — Visma Public, $250 · 245↑
- [Admin Management - Login Using Default Password - Leads to Image Upload Backdoor/Shell](https://hackerone.com/reports/699030) — Razer, $200 · 199↑
- [External SSRF and Local File Read via video upload due to vulnerable FFmpeg HLS processing](https://hackerone.com/reports/1062888) — TikTok, $2,727 · 159↑
- [Unrestricted file upload in www.semrush.com /> /my_reports/api/v1/upload/image](https://hackerone.com/reports/748903) — Semrush, $0 · 133↑
- [User can upload files even after closing his account](https://hackerone.com/reports/1020371) — Basecamp, $0 · 124↑
- [Any user could upload attachments to pentest scoping form they don't have access to](https://hackerone.com/reports/2450215) — HackerOne, $0 · 121↑
- [Insecure file upload in xiaoai.mi.com Lead to Stored  XSS](https://hackerone.com/reports/882733) — Xiaomi, $0 · 117↑
- [Unrestricted File Upload on https://partner.tiktokshop.com/wsos_v2/oec_partner/upload](https://hackerone.com/reports/1890284) — TikTok, $0 · 117↑
- [Stored XSS in File Upload Leads to Privilege Escalation and Full Workspace Takeover](https://hackerone.com/reports/3115705) — Dust, $0 · 117↑
- [XXE Injection through SVG image upload leads to SSRF](https://hackerone.com/reports/897244) — Zivver, $0 · 112↑
- [[insideok.ru] Remote Command Execution via file upload.](https://hackerone.com/reports/666716) — ok.ru, $0 · 98↑
- [Missing Access Control in MigrationFile allows attacker to upload files to any Migration](https://hackerone.com/reports/3506183) — GitHub, $0 · 91↑
- [Unrestricted file upload leads to Stored XSS](https://hackerone.com/reports/880099) — GitLab, $0 · 89↑
- [Avatar upload allows arbitrary file overwriting](https://hackerone.com/reports/671605) — Mail.ru, $750 · 88↑
- [Unauthenticated user can upload an attachment to the last updated report draft](https://hackerone.com/reports/419896) — HackerOne, $0 · 86↑
- [Unrestricted File Upload at ██████████](https://hackerone.com/reports/2357778) — Mars, $0 · 78↑
- [XSS from arbitrary attachment upload.](https://hackerone.com/reports/831703) — Qulture.Rocks, $0 · 74↑
- [Open s3 bucket allows for public upload](https://hackerone.com/reports/504600) — Augur, $100 · 73↑
- [ImageId Format Injection in Image Upload Endpoint](https://hackerone.com/reports/3175928) — Lichess, $0 · 73↑
- [Cross site scripting via file upload in subdomain ads.tiktok.com](https://hackerone.com/reports/1433125) — TikTok, $500 · 65↑
- [Upload profile photo and  Pets addition - IDOR](https://hackerone.com/reports/2393021) — Mars, $0 · 64↑
- [After the upload of an private file, using transformations, the file becomes public without the possibility of changing it.](https://hackerone.com/reports/1984060) — Mozilla, $1,000 · 63↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
