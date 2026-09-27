# H1 Disclosed Reports → Hunting Skills

Skills distilled from **disclosed Critical/High/Medium HackerOne reports**, each chosen
because it teaches a *novel, transferable* technique — not just "another reflected XSS".
Every `SKILL.md` names the original report (program, ID, severity, bounty, weakness),
explains the new lesson, how the bug works, how to hunt for it, payloads, tooling, and
the fix. Sources: hackerone.com/hacktivity + reddelexc/hackerone-reports (data.csv).

## Index (29 skills)

### XSS
- `xss-cache-poisoning` — cache poisoning → **stored** XSS (PayPal #488147)
- `xss-postmessage-dom` — DOM XSS via unvalidated `postMessage` (HackerOne #398054)
- `xss-location-hash` — XSS in URL fragment → WAF-invisible (Slack #146336)
- `xss-config-injection` — XSS via SPA config/state override (Superhuman #1082847)

### SSRF
- `ssrf-to-rce-exchange` — SSRF → internal Exchange → root (Shopify #341876)
- `ssrf-full-response` — full-read SSRF (Dropbox #1406938, Evernote #1189367)
- `ssrf-blind-link-preview` — blind SSRF, OOB confirmation (Reddit #1960765)

### RCE
- `rce-npm-dependency-confusion` — internal npm name → public registry (PayPal #925585)
- `rce-git-flag-injection` — filename → git option → overwrite → RCE (GitLab #658013)
- `rce-markup-options` — unsafe Markdown/Kramdown renderer options (GitLab #1125425)

### IDOR
- `idor-private-reports` — object ID enumeration → private data (HackerOne #2487889)
- `idor-graphql-delete` — GraphQL mutation IDOR delete (HackerOne #2122671)

### Account Takeover (ATO)
- `ato-request-smuggling` — mass ATO via request smuggling (Slack #737140)
- `ato-passwordless-signup` — passwordless account claim (Uber #143717)
- `ato-leaked-cookie` — session cookie leak → ATO (HackerOne #745324)

### Business Logic
- `business-logic-negative-quantity` — price manipulation via negative/overflow qty (Upserve #364843)
- `business-logic-crypto-balance` — balance/ledger invariant manipulation (Coinbase #300748)

### Request Smuggling
- `smuggling-http2` — HTTP/2 request smuggling (Basecamp #1211724, Tomcat CVE-2024-21733)

### Web Cache
- `cache-deception-pii` — Web Cache Deception → PII/CSRF leak (Shopify #1271944)
- `cache-poisoning-stored-xss` — cache poisoning → stored XSS/DoS (Glassdoor #1424094)

### OAuth
- `oauth-idn-homograph` — redirect_uri IDN homograph bypass (Semrush #861940)
- `oauth-token-leak-chain` — token theft via Referer/chained bugs (Uber #202781)

### SSTI
- `ssti-smarty-rce` — SSTI → RCE (Unikrn #164224)

### Subdomain Takeover
- `subdomain-takeover-auth-bypass` — takeover → auth bypass (Roblox #335330)

### Auth Bypass
- `auth-bypass-partners` — admin auth bypass via partner/SSO (Shopify #270981)

### GraphQL
- `graphql-rce-sift` — unauth RCE via sift `$where` filter (Mozilla #3782701)
- `graphql-sqli` — SQLi in GraphQL arg (HackerOne #435066)

### Race Condition
- `race-condition-giftcard` — multi-redeem race (Reverb #759247)
- `race-condition-2fa` — 2FA bypass race (HackerOne #2598548)

## How to use
Load the matching skill when a target feature matches (e.g. `ssrf-blind-link-preview`
for a link-preview feature, `business-logic-negative-quantity` for a cart/checkout).
Each skill's "How to hunt for it" is a ready-to-run checklist.
