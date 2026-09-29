---
name: h1-subdomain-takeover
description: Subdomain takeover: real-world techniques and chains distilled from 216 disclosed HackerOne reports (top bounty $3,000). Use when hunting subdomain takeover for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-subdomain.
source: reddelexc/hackerone-reports
report_count: 216
top_bounty: 3000
---

# Subdomain takeover — disclosed-report playbook (H1)

Distilled from **216** disclosed HackerOne reports for this class (top bounty **$3,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-subdomain` skill for the hunting methodology.

## How to hunt
- Enumerate CNAMEs; match dangling targets against can-i-take-over-xyz fingerprints.
- Claim only on assets you control to prove it; screenshot and release.
- Escalate: cookie scope, OAuth redirect_uri, email — chain to ATO.
- Never serve content that could harm real users.

## Patterns in the wild (from report titles)

`dom` ×247 · `subdomain` ×216 · `aws` ×21 · `api` ×5 · `ato` ×4 · `gcp` ×4 · `bypass` ×3 · `rce` ×2

## Top disclosed reports

- [Subdomain Takeover to Authentication bypass](https://hackerone.com/reports/335330) — Roblox, $0 · 782↑
- [Subdomain takeover of datacafe-cert.starbucks.com](https://hackerone.com/reports/665398) — Starbucks, $0 · 311↑
- [Authentication bypass on auth.uber.com via subdomain takeover of saostatic.uber.com](https://hackerone.com/reports/219205) — Uber, $0 · 182↑
- [Subdomain takeover of storybook.lystit.com](https://hackerone.com/reports/779442) — Lyst, $1,000 · 163↑
- [Hacker.One Subdomain Takeover](https://hackerone.com/reports/159156) — HackerOne, $0 · 154↑
- [Subdomain Takeover Via Insecure CloudFront Distribution cdn.grab.com](https://hackerone.com/reports/352869) — Grab, $1,000 · 142↑
- [Subdomain takeover at info.hacker.one](https://hackerone.com/reports/202767) — HackerOne, $0 · 134↑
- [Multiple Subdomain Takeovers: fly.staging.shipt.com, fly.us-west-2.staging.shipt.com, fly.us-east-1.staging.shipt.com](https://hackerone.com/reports/576857) — Shipt, $0 · 128↑
- [Subdomain takeover of mydailydev.starbucks.com](https://hackerone.com/reports/570651) — Starbucks, $0 · 122↑
- [Subdomain takeover of d02-1-ag.productioncontroller.starbucks.com](https://hackerone.com/reports/661751) — Starbucks, $0 · 122↑
- [Subdomain takeover on http://fastly.sc-cdn.net/](https://hackerone.com/reports/154425) — Snapchat, $3,000 · 114↑
- [Subdomain takeover on svcgatewayus.starbucks.com](https://hackerone.com/reports/325336) — Starbucks, $0 · 109↑
- [Subdomain takeover on happymondays.starbucks.com due to non-used AWS S3 DNS record](https://hackerone.com/reports/186766) — Starbucks, $0 · 105↑
- [Subdomain takeover on usclsapipma.cv.ford.com](https://hackerone.com/reports/484420) — Ford, $0 · 105↑
- [Subdomain takeover of fr1.vpn.zomans.com](https://hackerone.com/reports/1182864) — Eternal, $350 · 99↑
- [Subdomain takeover of resources.hackerone.com](https://hackerone.com/reports/863551) — HackerOne, $500 · 95↑
- [Subdomain takeover on wfmnarptpc.starbucks.com](https://hackerone.com/reports/388622) — Starbucks, $0 · 90↑
- [Subdomain Takeover at creatorforum.roblox.com](https://hackerone.com/reports/264494) — Roblox, $0 · 90↑
- [Subdomain takeover of v.zego.com](https://hackerone.com/reports/1180697) — Zego, $0 · 84↑
- [Subdomain Takeover](https://hackerone.com/reports/180393) — Paragon Initiative Enterprises, $0 · 83↑
- [Multiple Subdomain takeovers via unclaimed instances](https://hackerone.com/reports/276269) — Starbucks, $0 · 83↑
- [Potential Subdomain Takeover on IBM.com domain.](https://hackerone.com/reports/3592387) — IBM, $0 · 81↑
- [Subdomain takeover at signup.uber.com](https://hackerone.com/reports/197489) — Uber, $0 · 79↑
- [Subdomain takeover on one of the subdomain under mozaws.net](https://hackerone.com/reports/2269867) — Mozilla, $0 · 79↑
- [Subdomain takeover in Gitlab pages](https://hackerone.com/reports/2523654) — GitLab, $0 · 79↑
- [Subdomain takeover #2  at info.hacker.one](https://hackerone.com/reports/209004) — HackerOne, $0 · 78↑
- [Subdomain takeover due to unclaimed Amazon S3 bucket on a2.bime.io](https://hackerone.com/reports/121461) — Bime, $0 · 77↑
- [Subdomain Takeover due to ████████ NS records at us-east4.37signals.com](https://hackerone.com/reports/1342422) — Basecamp, $0 · 77↑
- [Subdomain Takeover on demo.greenhouse.io pointing to unbouncepages](https://hackerone.com/reports/407355) — Greenhouse.io, $0 · 76↑
- [Subdomain takeover on a subdomain under firefox.com](https://hackerone.com/reports/2899858) — Mozilla, $500 · 75↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
