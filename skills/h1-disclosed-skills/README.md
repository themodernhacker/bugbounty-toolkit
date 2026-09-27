# H1 Disclosed Reports → Hunting Skills

Skills distilled from **disclosed Critical/High/Medium HackerOne reports**, each chosen
because it teaches a *novel, transferable* technique — not just "another reflected XSS".
Every `SKILL.md` names the original report (program, ID, severity, bounty, weakness),
explains the new lesson, how the bug works, how to hunt for it, payloads, tooling, and
the fix. Sources: hackerone.com/hacktivity + reddelexc/hackerone-reports (data.csv).

## Index (64 skills)

### XSS (8)
- `xss-cache-poisoning` — cache poisoning → **stored** XSS (PayPal #488147)
- `xss-cache-poisoning-bypass` — bypass of the above fix (PayPal #510152, $20k)
- `xss-postmessage-dom` — DOM XSS via unvalidated `postMessage` (HackerOne #398054)
- `xss-location-hash` — XSS in URL fragment → WAF-invisible (Slack #146336)
- `xss-config-injection` — XSS via SPA config/state override (Superhuman #1082847)
- `xss-svg-data-url` — stored XSS via SVG/`data:` URL (Shopify #1276742)
- `xss-blind-image-upload` — blind XSS via upload → admin panel (CS Money #1010466)
- `xss-prototype-pollution` — prototype pollution → XSS (Elastic #998398)

### SSRF (7)
- `ssrf-to-rce-exchange` — SSRF → internal Exchange → root (Shopify #341876)
- `ssrf-full-response` — full-read SSRF (Dropbox #1406938, Evernote #1189367)
- `ssrf-blind-link-preview` — blind SSRF, OOB confirmation (Reddit #1960765)
- `ssrf-ffmpeg-hls` — SSRF+LFR via FFmpeg HLS upload (TikTok #1062888)
- `ssrf-jolokia-rce` — SSRF → internal Jolokia/JMX → RCE (Aiven #1547877)
- `ssrf-filter-bypass` — DNS rebinding + NAT64 IPv6 filter bypass (#3634400, #3176157)

### RCE (3)
- `rce-npm-dependency-confusion` — internal npm name → public registry (PayPal #925585)
- `rce-git-flag-injection` — filename → git option → overwrite → RCE (GitLab #658013)
- `rce-markup-options` — unsafe Markdown/Kramdown renderer options (GitLab #1125425)

### SQLi (3)
- `sqli-user-agent-header` — SQLi in HTTP headers (GSA #297478)
- `sqli-array-parameter` — SQLi in array params `param[]` (Valve #383127, $25k)
- `sqli-to-rce` — blind SQLi → RCE (QIWI #816254)

### Open Redirect (3)
- `open-redirect-to-ato` — OR → account takeover (cs.money #905607)
- `open-redirect-regex-bypass` — regex/domain-validation bypass → ATO (Khan Academy #3723458)
- `open-redirect-oauth-code` — OR → OAuth code exposure (LY #3423013)

### XXE (3)
- `xxe-svg-upload` — XXE via SVG upload → SSRF (Zivver #897244)
- `xxe-jpeg-xmp` — XXE via JPEG XMP metadata (Informatica #836877)
- `xxe-blind-oob` — blind/OOB XXE via parameter entities (Uber #154096)

### CSRF (3)
- `csrf-graphql-get` — CSRF via GraphQL GET mutations (GitLab #1122408)
- `csrf-oauth-nullbyte-state` — 1-click ATO via null-byte `state` bypass (Logitech #1046630)
- `csrf-token-validation-bypass` — token validation bypasses (GitHub #1497169, Stripe #1483327)

### Path Traversal / File Read (3)
- `path-traversal-apache-41773` — Apache CVE-2021-41773 encoded traversal (IBB #1394916)
- `lfi-html-injection-pdf` — HTML injection in PDF export → LFI (Visma #809819)
- `path-traversal-to-rce` — path traversal → RCE via file write (GitLab #733072)

### IDOR (2)
- `idor-private-reports` — object ID enumeration → private data (HackerOne #2487889)
- `idor-graphql-delete` — GraphQL mutation IDOR delete (HackerOne #2122671)

### Account Takeover (3)
- `ato-request-smuggling` — mass ATO via request smuggling (Slack #737140)
- `ato-passwordless-signup` — passwordless account claim (Uber #143717)
- `ato-leaked-cookie` — session cookie leak → ATO (HackerOne #745324)

### Business Logic (2)
- `business-logic-negative-quantity` — price manipulation via negative/overflow qty (Upserve #364843)
- `business-logic-crypto-balance` — balance/ledger invariant manipulation (Coinbase #300748)

### Request Smuggling (1)
- `smuggling-http2` — HTTP/2 request smuggling (Basecamp #1211724, Tomcat CVE-2024-21733)

### Web Cache (2)
- `cache-deception-pii` — Web Cache Deception → PII/CSRF leak (Shopify #1271944)
- `cache-poisoning-stored-xss` — cache poisoning → stored XSS/DoS (Glassdoor #1424094)

### OAuth (2)
- `oauth-idn-homograph` — redirect_uri IDN homograph bypass (Semrush #861940)
- `oauth-token-leak-chain` — token theft via Referer/chained bugs (Uber #202781)

### SSTI (1)
- `ssti-smarty-rce` — SSTI → RCE (Unikrn #164224)

### Subdomain Takeover (1)
- `subdomain-takeover-auth-bypass` — takeover → auth bypass (Roblox #335330)

### Auth Bypass (1)
- `auth-bypass-partners` — admin auth bypass via partner/SSO (Shopify #270981)

### GraphQL (2)
- `graphql-rce-sift` — unauth RCE via sift `$where` filter (Mozilla #3782701)
- `graphql-sqli` — SQLi in GraphQL arg (HackerOne #435066)

### Race Condition (2)
- `race-condition-giftcard` — multi-redeem race (Reverb #759247)
- `race-condition-2fa` — 2FA bypass race (HackerOne #2598548)

### High-Value Infrastructure (4)
- `elasticsearch-painless-rce` — ES Painless script → RCE via GraphQL (HackerOne #3694007)
- `spring-actuator-misconfig` — exposed Actuator + broken auth (LY #838635, $12.5k)
- `exposed-kubernetes-api` — exposed kube-apiserver → cluster takeover (Snapchat #455645, $25k)
- `exposed-jenkins` — open Jenkins → RCE/creds (Snapchat #231460, $15k)

### API (2)
- `api-undocumented-endpoints` — hidden endpoints/mutations (Shopify #981472, Uber #419655)
- `api-apache-flink-rce` — Flink RCE via jar/plan API (Aiven #1418891)

### Information Disclosure (1)
- `info-disclosure-graphql` — sensitive data via GraphQL fields (HackerOne #489146)

### Recon (6)
- `recon-exposed-git` — `.git`/`.svn`/`.env` exposure + dumping (Semrush #676212, GSA #268382)
- `recon-js-source-secrets` — API keys in JS/source maps (Stripo #983331)
- `recon-exposed-panels` — Grafana/Kibana/Prometheus/open-proxy (Snapchat #663628, Reddit #2967634)
- `recon-github-dorking` — GitHub secret/credential hunting (Snapchat #396467, Grab #397527)
- `recon-dns-enum-zone-transfer` — subdomain enum + AXFR (crt.name, subfinder, amass)
- `recon-http-fingerprint` — tech fingerprinting (httpx/whatweb/wafw00f)

## How to use
Load the matching skill when a target feature matches (e.g. `xxe-jpeg-xmp` for photo
upload, `csrf-graphql-get` for GraphQL, `recon-github-dorking` for credential recon).
Each skill's "How to hunt for it" is a ready-to-run checklist.
