---
name: h1-authorization
description: Authorization / access control: real-world techniques and chains distilled from 838 disclosed HackerOne reports (top bounty $18,000). Use when hunting authorization / access control for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-idor.
source: reddelexc/hackerone-reports
report_count: 838
top_bounty: 18000
---

# Authorization / access control — disclosed-report playbook (H1)

Distilled from **838** disclosed HackerOne reports for this class (top bounty **$18,000**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-idor` skill for the hunting methodology.

## How to hunt
- Enumerate roles and every object reference; build a permission matrix.
- Horizontal (other users' data) and vertical (admin functions) escalation.
- Forced browsing to function-level endpoints; missing server-side checks behind hidden UI.
- Prove with two accounts A/B; read/modify B's data from A.

## Patterns in the wild (from report titles)

`admin` ×248 · `privilege` ×178 · `escalation` ×149 · `bypass` ×86 · `api` ×66 · `leak` ×36 · `rce` ×35 · `ato` ×29 · `disclosure` ×27 · `idor` ×24 · `stored` ×19 · `oauth` ×18

## Top disclosed reports

- [Email Confirmation Bypass in myshop.myshopify.com that Leads to Full Privilege Escalation to Any Shop Owner by Taking Advantage of the Shopify SSO](https://hackerone.com/reports/791775) — Shopify, $0 · 1917↑
- [[Part II] Email Confirmation Bypass in myshop.myshopify.com that Leads to Full Privilege Escalation](https://hackerone.com/reports/796808) — Shopify, $0 · 894↑
- [Ability to reset password for account](https://hackerone.com/reports/322985) — Upserve, $0 · 633↑
- [Request smuggling on admin-official.line.me could lead to account takeover](https://hackerone.com/reports/740037) — LY Corporation, $0 · 564↑
- [Email Confirmation Bypass in your-store.myshopify.com which leads to privilege escalation](https://hackerone.com/reports/910300) — Shopify, $0 · 559↑
- [Privilege Escalation From user to SYSTEM via unauthenticated command execution](https://hackerone.com/reports/544928) — Ubiquiti Inc., $0 · 553↑
- [Able to Become Admin for Any LINE Official Account](https://hackerone.com/reports/698579) — LY Corporation, $0 · 492↑
- [H1514 Ability to MiTM Shopify PoS Session to Takeover Communications](https://hackerone.com/reports/423467) — Shopify, $0 · 372↑
- [Attacker is able to access commit title and team member comments which are supposed to be private](https://hackerone.com/reports/502593) — GitLab, $0 · 351↑
- [[Razer Pay  Mobile App] Broken access control allowing other user's bank account to be deleted](https://hackerone.com/reports/757095) — Razer, $1,000 · 311↑
- [Shopify admin authentication bypass using partners.shopify.com](https://hackerone.com/reports/270981) — Shopify, $0 · 310↑
- [Arbitrary Read of Another Users private repository without Authorization](https://hackerone.com/reports/3124517) — GitHub, $10,000 · 276↑
- [Ability to bypass partner email confirmation to take over any store given an employee email](https://hackerone.com/reports/300305) — Shopify, $15,250 · 270↑
- [Team member with Program permission only can escalate to Admin permission](https://hackerone.com/reports/605720) — HackerOne, $0 · 267↑
- [Oracle Webcenter Sites administrative and hi-privilege access available directly from the internet (/cs/Satellite)](https://hackerone.com/reports/170532) — LocalTapiola, $18,000 · 264↑
- [Ability to DOS any organization's SSO and open up the door to account takeovers](https://hackerone.com/reports/976603) — Superhuman (formerly Grammarly), $10,500 · 259↑
- [Ability to bypass email verification for OAuth grants results in accounts takeovers on 3rd parties](https://hackerone.com/reports/922456) — GitLab, $3,000 · 257↑
- [Privilege escalation from any user (including external) to gitlab admin when admin impersonates you](https://hackerone.com/reports/493324) — GitLab, $0 · 256↑
- [Stealing Users OAuth authorization code via redirect_uri](https://hackerone.com/reports/1861974) — pixiv, $2,000 · 252↑
- [Bypass Email Verification -- Able to Access Internal Gitlab Services that use Login with Gitlab and Perform Check on email domain](https://hackerone.com/reports/565883) — GitLab, $0 · 249↑
- [Linux privilege escalation via trusted $PATH in keybase-redirector](https://hackerone.com/reports/426944) — Keybase, $5,000 · 245↑
- [Shopify Partners Invitation Process Allows Privilege Escalation Without Email Verification](https://hackerone.com/reports/2885269) — Shopify, $0 · 242↑
- [Unauthenticated blind SSRF in OAuth Jira authorization controller](https://hackerone.com/reports/398799) — GitLab, $4,000 · 238↑
- [HackerOne SAML signup domain enforcement bypass results in unauthorized access to HackerOne PullRequest organization](https://hackerone.com/reports/2101076) — HackerOne, $0 · 228↑
- [[www.zomato.com] Blind XSS on one of the Admin Dashboard](https://hackerone.com/reports/724889) — Eternal, $750 · 221↑
- [Ability To Delete User(s) Account Without User Interaction](https://hackerone.com/reports/928255) — GitLab, $0 · 221↑
- [Incorrect authorization to the intelbot service leading to ticket information](https://hackerone.com/reports/1328546) — TikTok, $15,000 · 218↑
- [HackerOne Jira integration plugin Leaked JWT to unauthorized jira users](https://hackerone.com/reports/1103582) — HackerOne, $3,000 · 212↑
- [Unauthorized access to █████████.com allows access to Uber Brazil tax documents and system.](https://hackerone.com/reports/530441) — Uber, $4,500 · 210↑
- [Ability to create own account UUID leads to stored XSS](https://hackerone.com/reports/249131) — Upserve, $1,500 · 207↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
