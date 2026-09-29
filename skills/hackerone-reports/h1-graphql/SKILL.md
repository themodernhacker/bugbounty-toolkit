---
name: h1-graphql
description: GraphQL vulnerabilities: real-world techniques and chains distilled from 72 disclosed HackerOne reports (top bounty $12,500). Use when hunting graphql vulnerabilities for battle-tested patterns, filter bypasses and escalation chains from public disclosures; pairs with hunt-graphql.
source: reddelexc/hackerone-reports
report_count: 72
top_bounty: 12500
---

# GraphQL vulnerabilities — disclosed-report playbook (H1)

Distilled from **72** disclosed HackerOne reports for this class (top bounty **$12,500**). This is a curated on-ramp — the full technique lives in each linked report. Pair with the `hunt-graphql` skill for the hunting methodology.

## How to hunt
- Introspect the schema; enumerate queries/mutations and their authz.
- IDOR via node()/global IDs; SSRF/SQLi through arguments.
- Batching/alias abuse for rate-limit bypass and cost DoS (scope permitting).
- Field-level authz gaps leaking PII across tenants.

## Patterns in the wild (from report titles)

`graphql` ×72 · `api` ×11 · `disclosure` ×6 · `rce` ×5 · `idor` ×5 · `leak` ×5 · `bypass` ×3 · `admin` ×3 · `internal` ×3 · `unauthenticated` ×3 · `privilege` ×2

## Top disclosed reports

- [Confidential data of users and limited metadata of programs and reports accessible via GraphQL](https://hackerone.com/reports/489146) — HackerOne, $0 · 1033↑
- [Email address of any user can be queried on Report Invitation GraphQL type when username is known](https://hackerone.com/reports/792927) — HackerOne, $0 · 670↑
- [IDOR - Delete all Licenses and certifications from users account using CreateOrUpdateHackerCertification GraphQL query](https://hackerone.com/reports/2122671) — HackerOne, $0 · 392↑
- [Private list members disclosure via GraphQL](https://hackerone.com/reports/885539) — X / xAI, $0 · 346↑
- [Unauthenticated RCE in Taskcluster web-server via GraphQL filter argument (sift $where)](https://hackerone.com/reports/3782701) — Mozilla, $12,000 · 331↑
- [SSRF in graphQL query (pwapi.ex2b.com)](https://hackerone.com/reports/1864188) — EXNESS, $3,000 · 261↑
- [Github Apps can use Scoped-User-To-Server Tokens to Obtain Full Access to User's Projects in Project V2 GraphQL api](https://hackerone.com/reports/1711938) — GitHub, $0 · 198↑
- [IDOR on GraphQL queries BillingDocumentDownload and BillDetails](https://hackerone.com/reports/2207248) — Shopify, $5,000 · 187↑
- [DOS via Mutation Aliasing in GraphQL Account Recovery Phone Number Verification API](https://hackerone.com/reports/3287208) — HackerOne, $12,500 · 180↑
- [Disclosure of `payment_transactions` for programs via GraphQL query](https://hackerone.com/reports/707433) — HackerOne, $0 · 178↑
- [SQL injection in GraphQL endpoint through embedded_submission_form_uuid parameter](https://hackerone.com/reports/435066) — HackerOne, $0 · 174↑
- [GraphQL AdminGenerateSessionPayload is leaked to staff with no permission](https://hackerone.com/reports/898528) — Shopify, $0 · 173↑
- [Undocumented `fileCopy` GraphQL API](https://hackerone.com/reports/981472) — Shopify, $2,000 · 157↑
- [Team object in GraphQL disclosed private_comment](https://hackerone.com/reports/978143) — HackerOne, $2,500 · 146↑
- [Bug in GraphQL and API integration leads to limited user address disclosure](https://hackerone.com/reports/473742) — Starbucks, $0 · 144↑
- [Unauthorized user can obtain `report_sources` attribute through Team GraphQL object](https://hackerone.com/reports/770209) — HackerOne, $2,500 · 142↑
- [Private program disclosure via `vpn_suspended` GraphQL query](https://hackerone.com/reports/715192) — HackerOne, $2,500 · 138↑
- [GraphQL field on Team node can be used to determine if External Program runs invite-only program](https://hackerone.com/reports/877642) — HackerOne, $2,500 · 107↑
- [Team object in GraphQL disclosed total number of whitelisted hackers](https://hackerone.com/reports/342978) — HackerOne, $2,500 · 93↑
- [Cross-Tenant IDOR ( graphql `AddRulesToPixelEvents` query ) allowing to add, update, and delete rules of any Pixel events on the platform](https://hackerone.com/reports/984965) — TikTok, $0 · 84↑
- [Private information exposed through GraphQL filters](https://hackerone.com/reports/645299) — HackerOne, $0 · 81↑
- [Insecure Direct Object Reference (IDOR) in GraphQL deleteProfileImages Mutation](https://hackerone.com/reports/2968039) — Autodesk, $0 · 79↑
- [Team object in GraphQL discloses team group names and permissions](https://hackerone.com/reports/343464) — HackerOne, $2,500 · 75↑
- [Unauthenticated GraphQL access by prepending __schema to private operations](https://hackerone.com/reports/3452015) — Enjin, $500 · 74↑
- [Team object in GraphQL disclosed of private programs via the industry](https://hackerone.com/reports/707406) — HackerOne, $500 · 72↑
- [Attachment object in GraphQL continues to grant access to files, even if they are removed from rendering](https://hackerone.com/reports/1132606) — HackerOne, $0 · 66↑
- [Image queue default key of 'None' and GraphQL unhandled type exception](https://hackerone.com/reports/996041) — Reddit, $500 · 65↑
- [GraphQL query "namespace" leaks data](https://hackerone.com/reports/614355) — GitLab, $0 · 64↑
- [Using GraphQL, STAFF with NO explicit permissions on Store can retrieve Shopify Payments Balance.](https://hackerone.com/reports/417170) — Shopify, $500 · 62↑
- [Access to internal info via Graphql on https://tng-api.watsons.com.my](https://hackerone.com/reports/2233480) — A.S. Watson Group, $0 · 61↑

## Validate & report
- Reproduce from a clean session/account; rule out false positives.
- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.
- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.
