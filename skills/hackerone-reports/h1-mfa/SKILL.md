---
name: h1-mfa
description: MFA / 2FA bypass: real-world techniques and chains distilled from 90 disclosed HackerOne reports (top bounty $10,000). Use when hunting mfa / 2fa bypass for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-mfa-bypass.
source: reddelexc/hackerone-reports
report_count: 90
top_bounty: 10000
---

# MFA / 2FA bypass — disclosed-report playbook (H1)

Distilled from **90** disclosed HackerOne reports for this class (top bounty **$10,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-mfa-bypass` skill for the hunting methodology.

## How to hunt
- Is MFA middleware-gated or per-endpoint? Try direct navigation past the challenge.
- OTP: brute (no rate limit), replay, race on validate, backup-code dump via /api/me.
- Factor downgrade; 'remember me' persistence bypass.
- Reach a post-MFA authenticated state as the attacker to prove it.

## Patterns in the wild (from report titles)

`2fa` ×75 · `bypass` ×39 · `mfa` ×7 · `rce` ×4 · `account takeover` ×3 · `csrf` ×3 · `ato` ×2 · `api` ×2 · `admin` ×2 · `token` ×2 · `disclosure` ×2

## Top disclosed reports

- [2FA bypass by sending blank code](https://hackerone.com/reports/897385) — Glassdoor, $0 · 303↑
- [Hacker can bypass 2FA requirement and reporter blacklist through embedded submission form](https://hackerone.com/reports/418767) — HackerOne, $10,000 · 208↑
- [2FA Bypass leads to  impersonation of legimate users](https://hackerone.com/reports/2885636) — Drugs.com, $0 · 206↑
- [TikTok 2FA Bypass](https://hackerone.com/reports/1247108) — TikTok, $1,564 · 194↑
- [Previously created sessions continue being valid after MFA activation](https://hackerone.com/reports/667739) — Superhuman (formerly Grammarly), $0 · 176↑
- [Enable 2FA without verifying the email](https://hackerone.com/reports/649533) — Moneybird, $0 · 149↑
- [Bypassing HackerOne 2FA due to race condition](https://hackerone.com/reports/2598548) — HackerOne, $0 · 139↑
- [2FA requirement bypass when inviting team members](https://hackerone.com/reports/3356149) — Omise, $0 · 105↑
- [Password not checked when disabling 2FA on HackerOne](https://hackerone.com/reports/587910) — HackerOne, $0 · 95↑
- [Account takeover w/o interaction for a user that doesn't have 2fa enabled via 2fa linking and improper auth at /api/2fa/verify](https://hackerone.com/reports/810880) — Helium, $0 · 92↑
- [2FA bypass possible on https://authsvc.singlestore.com](https://hackerone.com/reports/3329361) — SingleStore, $0 · 92↑
- [Session Doesn't expire after 2fa and also other session can change passsword](https://hackerone.com/reports/2234736) — SideFX, $300 · 90↑
- [“email” MFA mode allows bypassing MFA from victim’s device when the device trust is not expired](https://hackerone.com/reports/665722) — Superhuman (formerly Grammarly), $2,500 · 82↑
- [Information disclosure -/> 2fa bypass -/> POST exploitation](https://hackerone.com/reports/1276373) — Algolia, $0 · 76↑
- [2FA doesn't work in "https://insider.razer.com"](https://hackerone.com/reports/701901) — Razer, $200 · 72↑
- [Able to blocking users with 2fa from login into their accounts by just knowing the SteamID](https://hackerone.com/reports/1179232) — CS Money, $300 · 69↑
- [Enable 2FA without verifying the email](https://hackerone.com/reports/3016540) — XVIDEOS, $0 · 69↑
- [Two-factor authentication enforcement bypass](https://hackerone.com/reports/1050244) — Nextcloud, $750 · 63↑
- [Changing the 2FA secret key and backup codes without knowing the 2FA OTP](https://hackerone.com/reports/1139535) — HackerOne, $0 · 56↑
- [bypass two-factor authentication in Android apps and web](https://hackerone.com/reports/1747978) — TikTok, $0 · 55↑
- [Account deletion using the /v1/account/destroy API endpoint using account password without 2FA verification](https://hackerone.com/reports/2197244) — Mozilla, $1,000 · 52↑
- [Missing ownership check in 2FA for secondary client login](https://hackerone.com/reports/1250474) — LY Corporation, $0 · 52↑
- [Two factor authentication bypass](https://hackerone.com/reports/2463279) — HackerOne, $0 · 47↑
- [Two-factor authentication bypass on Grab Android App](https://hackerone.com/reports/202425) — Grab, $0 · 46↑
- [Misconfiguration in Two Factor Authorisation](https://hackerone.com/reports/178293) — Shopify, $1,500 · 40↑
- [Signup with any email and enable 2FA without verifying email](https://hackerone.com/reports/699200) — Omise, $0 · 40↑
- [Enable 2Fa verification without verifying email](https://hackerone.com/reports/1618021) — Cloudflare Public Bug Bounty, $0 · 40↑
- [bypass two-factor authentication.](https://hackerone.com/reports/1842183) — LinkedIn, $0 · 40↑
- [Business Logic error leads to bypass 2FA requirement](https://hackerone.com/reports/2571981) — HackerOne, $0 · 39↑
- [Bypass  two-factor authentication](https://hackerone.com/reports/121696) — Slack, $0 · 36↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
