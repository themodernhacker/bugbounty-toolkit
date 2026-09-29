---
name: h1-dos
description: Denial of Service: real-world techniques and chains distilled from 324 disclosed HackerOne reports (top bounty $12,500). Use when hunting denial of service for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with triage-validation.
source: reddelexc/hackerone-reports
report_count: 324
top_bounty: 12500
---

# Denial of Service — disclosed-report playbook (H1)

> **SCOPE WARNING:** OUT OF SCOPE in almost every bug bounty program. Do NOT test without explicit written authorization for this exact class.

Distilled from **324** disclosed HackerOne reports for this class (top bounty **$12,500**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `triage-validation` skill for the hunting methodology.

## How to hunt
- Read the program policy FIRST — DoS is almost always explicitly excluded.
- Study these reports for patterns (ReDoS, algorithmic complexity, resource amplification) as DEFENSIVE knowledge.
- If (and only if) a program authorizes it in writing, use the smallest possible PoC and stop at proof.

## Patterns in the wild (from report titles)

`api` ×20 · `rce` ×20 · `cache` ×17 · `bypass` ×5 · `leak` ×5 · `dom` ×3 · `chain` ×3 · `ato` ×3 · `graphql` ×3 · `internal` ×3 · `path traversal` ×3 · `stored` ×2

## Top disclosed reports

- [DoS on PayPal via web cache poisoning](https://hackerone.com/reports/622122) — PayPal, $9,700 · 851↑
- [profile-picture name parameter with large value lead to DoS for other users and programs on the platform](https://hackerone.com/reports/764434) — HackerOne, $0 · 475↑
- [Denial of service to WP-JSON API by cache poisoning the CORS allow origin header](https://hackerone.com/reports/591302) — Automattic, $0 · 405↑
- [DoS Vulnerability via Cache Poisoning on cdn.shopify.com and shopify-assets.shopifycdn.com](https://hackerone.com/reports/1695604) — Shopify, $3,800 · 265↑
- [Ability to DOS any organization's SSO and open up the door to account takeovers](https://hackerone.com/reports/976603) — Superhuman (formerly Grammarly), $10,500 · 259↑
- [Denial of service via cache poisoning](https://hackerone.com/reports/409370) — HackerOne, $2,500 · 253↑
- [Uploading large payload on domain instructions causes server-side DoS](https://hackerone.com/reports/887321) — HackerOne, $2,500 · 210↑
- [DOS via Mutation Aliasing in GraphQL Account Recovery Phone Number Verification API](https://hackerone.com/reports/3287208) — HackerOne, $12,500 · 180↑
- [xmlrpc.php FILE IS enable it will used for Bruteforce attack and Denial of Service(DoS)](https://hackerone.com/reports/752073) — Nord Security, $0 · 162↑
- [Node disk DOS by writing to container /etc/hosts](https://hackerone.com/reports/867699) — Kubernetes, $1,000 · 161↑
- [DoS on the Issue page by exploiting Mermaid.](https://hackerone.com/reports/470067) — GitLab, $3,000 · 145↑
- [character limitation bypass can lead to DoS on Twitter App and 500 Internal Server Error](https://hackerone.com/reports/819088) — X / xAI, $0 · 141↑
- [a very long name in hey.com can prevent anyone from accessing their contacts and probably can cause denial of service](https://hackerone.com/reports/1018037) — Basecamp, $1,000 · 132↑
- [Permanent DoS with one click.](https://hackerone.com/reports/975827) — Automattic, $0 · 127↑
- [DOS of RSKJ server](https://hackerone.com/reports/2105808) — Rootstock Labs, $5,000 · 120↑
- [HTML Injection in Swing can disclose netNTLM hash or cause DoS](https://hackerone.com/reports/1054382) — PortSwigger Web Security, $1,000 · 117↑
- [ActiveStorage throws exception when using whitespace as filename, may lead to denial of service of multiple pages](https://hackerone.com/reports/713407) — HackerOne, $0 · 111↑
- [Cache Poisoning DoS on downloads.exodus.com](https://hackerone.com/reports/1173153) — Exodus, $0 · 110↑
- [Denial of Service via Hyperlinks in Posts](https://hackerone.com/reports/1077136) — Slack, $1,500 · 109↑
- [Unsufficent input verification leads to DoS and resource consumption](https://hackerone.com/reports/2818147) — Sorare, $300 · 108↑
- [Any installed app can force immediate logout and persistent DOS of authenticated Basecamp sessions via unprotected exported StartActivity](https://hackerone.com/reports/3764217) — Basecamp, $0 · 103↑
- [Attacker with an Old account might still be able to DoS ctf.hacker101.com by sending a Crafted request](https://hackerone.com/reports/861170) — HackerOne, $0 · 97↑
- [Denial of Service (DoS) Vulnerability in Drafts Creation Endpoint](https://hackerone.com/reports/3400140) — Discourse, $1,024 · 93↑
- [Denial of Service | twitter.com & mobile.twitter.com](https://hackerone.com/reports/903740) — X / xAI, $1,120 · 88↑
- [DoS attack via comment on Issue](https://hackerone.com/reports/557154) — GitLab, $1,000 · 84↑
- [Application Level DoS - Large Markdown Payload in Reply Section Leading to Resource Exhaustion](https://hackerone.com/reports/3058919) — Discourse, $0 · 84↑
- [CVE-2024-41990: Potential denial-of-service in django.utils.html.urlize()](https://hackerone.com/reports/2795558) — Internet Bug Bounty, $2,162 · 83↑
- [Denial Of Service (Out Of Memory) on Updating Bounty Table [Urgent]](https://hackerone.com/reports/1043372) — HackerOne, $0 · 83↑
- [Cache poisoning Denial of Service affecting assets.gitlab-static.net](https://hackerone.com/reports/1160407) — GitLab, $0 · 83↑
- [https://themes.shopify.com::: Host header web cache poisoning lead to DoS](https://hackerone.com/reports/1096609) — Shopify, $2,900 · 82↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
