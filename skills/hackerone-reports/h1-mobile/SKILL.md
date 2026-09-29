---
name: h1-mobile
description: Mobile app vulnerabilities: real-world techniques and chains distilled from 184 disclosed HackerOne reports (top bounty $10,000). Use when hunting mobile app vulnerabilities for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with triage-validation.
source: reddelexc/hackerone-reports
report_count: 184
top_bounty: 10000
---

# Mobile app vulnerabilities — disclosed-report playbook (H1)

Distilled from **184** disclosed HackerOne reports for this class (top bounty **$10,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `triage-validation` skill for the hunting methodology.

## How to hunt
- Decompile (jadx/apktool); grep for secrets, endpoints, Firebase, pinned certs.
- Insecure storage, exported components, deeplink abuse, weak SSL pinning.
- Test the mobile API surface — often older/weaker than the web app.
- Reverse the client to reach hidden/privileged endpoints.

## Patterns in the wild (from report titles)

`bypass` ×18 · `leak` ×13 · `api` ×10 · `rce` ×7 · `upload` ×5 · `token` ×5 · `account takeover` ×4 · `csrf` ×4 · `disclosure` ×4 · `path traversal` ×4 · `stored` ×3 · `ato` ×3

## Top disclosed reports

- [CVE-2019-5765: 1-click HackerOne account takeover on all Android devices](https://hackerone.com/reports/563870) — Chrome, $0 · 375↑
- [Multiple bugs leads to RCE on TikTok for Android](https://hackerone.com/reports/1065500) — TikTok, $0 · 371↑
- [AWS bucket leading to iOS test build code and configuration exposure](https://hackerone.com/reports/404822) — Slack, $1,500 · 321↑
- [[Razer Pay  Mobile App] Broken access control allowing other user's bank account to be deleted](https://hackerone.com/reports/757095) — Razer, $1,000 · 311↑
- [Golden techniques to bypass host validations in Android apps](https://hackerone.com/reports/431002) — ██████, $0 · 278↑
- [Periscope android app deeplink leads to CSRF in follow action](https://hackerone.com/reports/583987) — X / xAI, $1,540 · 224↑
- [read new emails from any inbox IOS APP in notification center](https://hackerone.com/reports/977212) — Mail.ru, $10,000 · 186↑
- [url that twitter mobile site can not load](https://hackerone.com/reports/500686) — X / xAI, $1,120 · 142↑
- [XSS via message subject - mobile application](https://hackerone.com/reports/368912) — Mail.ru, $1,000 · 139↑
- [Changing email address on Twitter for Android unsets "Protect your Tweets"](https://hackerone.com/reports/472013) — X / xAI, $2,940 · 119↑
- [Possible to steal any protected files on Android](https://hackerone.com/reports/377107) — ownCloud, $750 · 115↑
- [Ability to Add and Verify Uncontrolled Mobile Numbers Leading to Account Takeover (ATO)](https://hackerone.com/reports/2762462) — MTN Group, $0 · 97↑
- [Disclosure of all uploads to Cloudinary via hardcoded api secret in Android app](https://hackerone.com/reports/351555) — Reverb.com, $0 · 96↑
- [Bypass of biometrics security functionality is possible in Android application (com.shopify.mobile)](https://hackerone.com/reports/637194) — Shopify, $500 · 90↑
- [MetaMask Browser URL and Transaction Origin Spoofing - Metamask wallet Android & Metamask wallet iOS](https://hackerone.com/reports/1751333) — MetaMask, $0 · 86↑
- [[Razer Pay Android App] Multiple vulnerabilities chained to allow "RedPacket" money to be stolen by a 3rd party](https://hackerone.com/reports/753280) — Razer, $1,000 · 84↑
- [Grammarly Keyboard for Android /<4.1  leaks user input through logs (except for sensitive input fields)](https://hackerone.com/reports/462416) — Superhuman (formerly Grammarly), $0 · 84↑
- [Domain highlighting on External link warning is not working on Chrome & Microsoft Edge browsers on Mobile](https://hackerone.com/reports/2553026) — HackerOne, $0 · 81↑
- [Reflect XSS on Mobile Search page](https://hackerone.com/reports/380246) — Pornhub, $250 · 79↑
- [Sensitive Info Leak - An Attacker Can Retrieve All the Users Mobile Numbers at https://website-api.production.curve.app/api/waitlist/us](https://hackerone.com/reports/902733) — Curve, $0 · 79↑
- [Grammarly Keyboard for Android "Authorization Code with PKCE" flow implementation vulnerability that allows account takeover](https://hackerone.com/reports/824931) — Superhuman (formerly Grammarly), $0 · 76↑
- [Authorization bypass using login by phone option+horizontal escalation possible on Grab Android App](https://hackerone.com/reports/205000) — Grab, $0 · 68↑
- [Persistant Arbitrary code execution in mattermost android](https://hackerone.com/reports/1115864) — Mattermost, $0 · 66↑
- [URL Scheme Validation Bypass in Shopify Mobile App Allows Javascript Execution](https://hackerone.com/reports/1737358) — Shopify, $0 · 65↑
- [Insufficient session expiration in the **com.shopify.ping** android app](https://hackerone.com/reports/1172205) — Shopify, $0 · 63↑
- [Java: CWE-749 Unsafe resource loading in Android WebView leaking to injection attacks](https://hackerone.com/reports/1011956) — GitHub Security Lab, $2,300 · 60↑
- [Periscope iOS app CSRF in follow action due to deeplink](https://hackerone.com/reports/805073) — X / xAI, $2,940 · 58↑
- [Firebase Database Takeover in Zego Sense Android app](https://hackerone.com/reports/1065134) — Zego, $0 · 58↑
- [Default Nextcloud Server and Android Client leak sharee searches to Nextcloud](https://hackerone.com/reports/1167916) — Nextcloud, $750 · 57↑
- [Android: Explanation of Access to app protected components vulnerability](https://hackerone.com/reports/951691) — ██████, $0 · 56↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
