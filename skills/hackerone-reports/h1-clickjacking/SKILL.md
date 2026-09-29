---
name: h1-clickjacking
description: Clickjacking / UI redressing: real-world techniques and chains distilled from 135 disclosed HackerOne reports (top bounty $3,000). Use when hunting clickjacking / ui redressing for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-clickjacking.
source: reddelexc/hackerone-reports
report_count: 135
top_bounty: 3000
---

# Clickjacking / UI redressing — disclosed-report playbook (H1)

Distilled from **135** disclosed HackerOne reports for this class (top bounty **$3,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-clickjacking` skill for the hunting methodology.

## How to hunt
- Only sensitive state-changing actions matter; ignore bare header absence.
- Confirm the page frames in a real browser AND the action survives SameSite/framebusting.
- Chain to OAuth confirm, money transfer, or account settings for real impact.

## Patterns in the wild (from report titles)

`dom` ×5 · `bypass` ×4 · `reflected` ×3 · `account takeover` ×3 · `oauth` ×3 · `admin` ×3 · `chain` ×2 · `api` ×2

## Top disclosed reports

- [RCE of Burp  Scanner / Crawler via Clickjacking](https://hackerone.com/reports/1274695) — PortSwigger Web Security, $3,000 · 171↑
- [Twitter Periscope Clickjacking Vulnerability](https://hackerone.com/reports/591432) — X / xAI, $1,120 · 143↑
- [Highly wormable clickjacking in player card](https://hackerone.com/reports/85624) — X / xAI, $0 · 134↑
- [Clickjacking on donation page](https://hackerone.com/reports/921709) — WordPress, $0 · 90↑
- [Clickjacking in main domain https://topechelon.com/](https://hackerone.com/reports/2964441) — Top Echelon Software, $0 · 80↑
- [Viral Direct Message Clickjacking via link truncation leading to capture of both Google credentials & installation of malicious 3rd party Twitter App](https://hackerone.com/reports/643274) — X / xAI, $0 · 64↑
- [Double Clickjacking Attack on WakaTime OAuth Authorization Flow at https://wakatime.com/oauth/authorize](https://hackerone.com/reports/3287060) — WakaTime, $0 · 57↑
- [Sensitive Clickjacking on admin login page.](https://hackerone.com/reports/389145) — Shipt, $0 · 55↑
- [Stealing User emails by clickjacking cards.twitter.com/xxx/xxx](https://hackerone.com/reports/154963) — X / xAI, $0 · 49↑
- [Clickjacking vkpay](https://hackerone.com/reports/374817) — VK.com, $0 · 44↑
- [[api.tumblr.com] Exploiting clickjacking vulnerability to trigger self DOM-based XSS](https://hackerone.com/reports/953579) — Automattic, $0 · 31↑
- [URL is vulnerable to clickjacking  https://app.passit.io/](https://hackerone.com/reports/530008) — Passit, $0 · 28↑
- [Clickjacking Vulnerability Can Leads To Delete Developer APP](https://hackerone.com/reports/1416612) — TikTok, $500 · 26↑
- [Clickjacking at ylands.com](https://hackerone.com/reports/405342) — BOHEMIA INTERACTIVE a.s., $80 · 22↑
- [Clickjacking in the admin page](https://hackerone.com/reports/728004) — Rocket.Chat, $0 · 21↑
- [Clickjacking on cas.acronis.com login page](https://hackerone.com/reports/971234) — Acronis, $0 · 19↑
- [CRITICAL-CLICKJACKING at Yelp Reservations Resulting in exposure of victim Private Data (Email info) + Victim Credit Card MissUse.](https://hackerone.com/reports/355859) — Yelp, $0 · 18↑
- [Clickjacking in [exchangemarketplace.com]](https://hackerone.com/reports/658217) — Shopify, $0 · 17↑
- [Clickjacking at join.nordvpn.com](https://hackerone.com/reports/765955) — Nord Security, $0 · 17↑
- [self-xss with ClickJacking can leads to account takeover in Firefox](https://hackerone.com/reports/892289) — Imgur, $0 · 17↑
- [Clickjacking In jobs.wordpress.net](https://hackerone.com/reports/223024) — WordPress, $0 · 16↑
- [Clickjacking at open.rocket.chat](https://hackerone.com/reports/1584034) — Rocket.Chat, $0 · 16↑
- [OAuth authorization page vulnerable to clickjacking](https://hackerone.com/reports/65825) — Coinbase, $0 · 15↑
- [Clickjacking wordcamp.org](https://hackerone.com/reports/230581) — WordPress, $0 · 14↑
- [Make user buy items via clickjacking possibility](https://hackerone.com/reports/471967) — Mail.ru, $0 · 14↑
- [Reflected XSS through ClickJacking](https://hackerone.com/reports/1171403) — U.S. Dept Of Defense, $0 · 14↑
- [Modifying application settings via clickjacking on o2.mail.ru](https://hackerone.com/reports/355774) — Mail.ru, $150 · 13↑
- [Clickjacking Vulnerability found on Yelp](https://hackerone.com/reports/214087) — Yelp, $0 · 13↑
- [Clickjacking at  app.lemlist.com](https://hackerone.com/reports/1574017) — lemlist, $0 · 13↑
- [Clickjacking on Mixmax.com](https://hackerone.com/reports/234713) — Mixmax, $0 · 12↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
