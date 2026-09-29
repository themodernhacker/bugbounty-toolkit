# Bug Bounty Skills Library

Agent skills (markdown `SKILL.md` playbooks) for bug-bounty hunting, pentest, and
red-team engagements. Organized by source to preserve provenance and avoid name
collisions.

Each skill is a self-contained folder with a `SKILL.md` (and sometimes `references/`,
`AGENTS.md`, or extra docs). **To use a skill:** read its `SKILL.md` when a target
matches the class — e.g. load `hunt-xss` when testing a reflected input, `hunt-ssrf`
for URL-fetch parameters, `hunt-idor` for object references, etc.

## Layout

```
skills/
├── claude-bughunter/              # core hunt library (83 skills)
├── agentic-bug-hunter/            # hunt/web2/web3 skills (15)
├── yaklang-hack-skills/           # offensive hacking playbooks (103)
├── useosint/                      # OSINT / recon (29)
├── h1-disclosed-skills/          # 100 skills distilled from disclosed H1 reports
├── hackerone-reports/             # 28 h1-<class> companions (generated, see below)
├── methodology/                   # My Bug Hunting Methodology.md
├── CATEGORY_MAP.md                # 100 bug categories -> which skill to load
├── SKILL_INDEX.tsv                # generated: grep this to find on-demand skills
└── README.md
```

Start with **`CATEGORY_MAP.md`** to route a bug class to the right skill.

## hackerone-reports/  (28 skills, generated)  — from reddelexc/hackerone-reports
`h1-<class>` companions (h1-xss, h1-ssrf, h1-idor, …) distilled from thousands of
disclosed HackerOne reports: per class, the top-paid disclosed reports, patterns
seen in the wild, and a hunting checklist. Load alongside the matching `hunt-*`
skill. **Generated** — rebuild with `bash tools/gen-skills.sh` (not committed as
source; `.h1src/` is the working clone).

## claude-bughunter/  (83 skills)  — elementalsouls/Claude-BugHunter
hunt-{xss, sqli, ssrf, ssti, xxe, lfi, idor, csrf, cors, open-redirect, race-condition,
http-smuggling, cache-poison, host-header, deserialization, nosqli, graphql, file-upload,
jwt-crypto, oauth, saml, session, mfa-bypass, auth-bypass, brute-force, captcha-bypass,
business-logic, api-misconfig, aspnet, laravel, nextjs, nodejs, springboot, websocket,
ato, subdomain, source-leak, clickjacking, html-injection, rce, rag-vector, llm-ai,
shadow-api, spa-api, cicd, cloud-misconfig, k8s, ldap, ntlm-info, exceptional-conditions,
forgot-password, dispatch, fintech-graphql, grpc, misc, sharepoint, tls-network} +
pipelines/reporting: bb-methodology, recon-scope-triage, osint-methodology, offensive-osint,
web2-recon, web3-audit, report-writing, evidence-hygiene, redteam-*, triage-validation,
security-arsenal, supply-chain-attack-recon, bug-bounty, bugcrowd-reporting, etc.

## agentic-bug-hunter/  (15 skills)  — awarexone/Agentic-Bug-Hunter
argus, bb-methodology, bug-bounty, cicd-security, client-reverse, credential-attack,
graphql-audit, meme-coin-audit, mobile-pentest, report-writing, security-arsenal,
triage-validation, web2-recon, web2-vuln-classes, web3-audit.

## yaklang-hack-skills/  (103 skills)  — yaklang/hack-skills
Offensive web/network/AD/mobile playbooks: xss-cross-site-scripting, sqli-sql-injection,
ssrf-server-side-request-forgery, ssti-server-side-template-injection, xxe, idor-broken-object-authorization,
csrf, open-redirect, cors-cross-origin-misconfiguration, waf-bypass-techniques,
subdomain-takeover, request-smuggling, web-cache-deception, websocket-security,
http-parameter-pollution, host-header-attacks, jwt-oauth-token-attacks, saml-sso-assertion-attacks,
oauth-oidc-misconfiguration, api-authorization-and-bola, api-recon-and-docs, nosql-injection,
cmdi-command-injection, path-traversal-lfi, file-access-vuln, upload-insecure-files,
deserialization-insecure, prototype-pollution, race-condition, clickjacking, crlf-injection,
csv-formula-injection, dangling-markup-injection, email-header-injection, xslt-injection,
graphql-and-hidden-parameters, http2-specific-attacks, dns-rebinding-attacks, +
AD/network/OS: active-directory-{acl-abuse, kerberos-attacks, certificate-services},
linux/windows-{privilege-escalation, lateral-movement, security-bypass, av-evasion},
ntlm-relay-coercion, kubernetes-pentesting, container-escape, kernel-exploitation,
reverse-shell-techniques, tunneling-and-pivoting, recon-and-methodology, etc.

## useosint/  (29 skills)  — useosint/skills
OSINT & recon: recon-a-domain-passively, find-hidden-subdomains, find-exposed-servers,
find-leaks-in-the-wild, google-like-a-spy, who-owns-this-domain, x-ray-a-company,
secrets-in-git-history, secrets-in-file-metadata, dig-through-data-brokers, find-anyone,
geolocate-from-pixels, pattern-of-life-from-socials, write-the-intel-brief, etc.

## h1-disclosed-skills/  (100 skills)  — distilled from disclosed H1 reports
Novel techniques from real Critical/High/Medium disclosed reports across XSS, SSRF,
SQLi, Open Redirect, XXE, CSRF, path-traversal, RCE, IDOR, ATO, GraphQL, cache, OAuth,
race conditions, upload, DoS, clickjacking, 2FA, SSO/SAML, mobile, API, info-disclosure,
high-value infrastructure, and recon. Full index: skills/h1-disclosed-skills/README.md

## methodology/
`My Bug Hunting Methodology.md` — full recon→enum→exploit→report workflow
(subfinder, amass, assetfinder, httpx, nuclei, sqlmap, etc.).
