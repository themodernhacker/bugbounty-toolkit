# Bug Bounty Skills Library

Agent skills (markdown `SKILL.md` playbooks) for bug-bounty hunting and red-team
engagements. Organized by source to preserve provenance and avoid name collisions.

Each skill is a self-contained folder with a `SKILL.md` (and sometimes `references/`,
`AGENTS.md`, or extra docs). **To use a skill:** read its `SKILL.md` when a target
matches the class — e.g. load `hunt-xss` when testing a reflected input, `hunt-ssrf`
for URL-fetch parameters, `hunt-idor` for object references, etc.

## Layout

```
skills/
├── claude-bughunter/      # core hunt library (83 skills)
├── agentic-bug-hunter/    # additional hunt/web2/web3 skills (15)
├── agent-zero/            # agent framework meta-skills (7) — NOT hunting skills
├── methodology/           # My Bug Hunting Methodology.md (wadgamer10)
└── README.md
```

## claude-bughunter/  (83 skills)
hunt-{xss, sqli, ssrf, ssti, xxe, lfi, idor, csrf, cors, open-redirect, race-condition,
http-smuggling, cache-poison, host-header, deserialization, nosqli, graphql, file-upload,
jwt-crypto, oauth, saml, session, mfa-bypass, auth-bypass, brute-force, captcha-bypass,
business-logic, api-misconfig, aspnet, laravel, nextjs, nodejs, springboot, websocket,
ato, subdomain, source-leak, clickjacking, html-injection, rce, rag-vector, llm-ai,
shadow-api, spa-api, cicd, cloud-misconfig, k8s, ldap, ntlm-info, exceptional-conditions,
forgot-password, dispatch, fintech-graphql, grpc, misc, sharepoint, tls-network} +
pipelines/reporting: bb-methodology, recon-scope-triage, osint-methodology, offensive-osint,
web2-recon, web3-audit, report-writing, evidence-hygiene, redteam-*, triage-validation,
security-arsenal, supply-chain-attack-recon, bug-bounty, bugcrowd-reporting,
mid-engagement-ir-detection, ios/apk-redteam-pipeline, m365-entra-attack, okta-attack,
enterprise-vpn-attack, vmware-vcenter-attack, cloud-iam-deep, meme-coin-audit, bb-local-toolkit.

## agentic-bug-hunter/  (15 skills)
argus, bb-methodology, bug-bounty, cicd-security, client-reverse, credential-attack,
graphql-audit, meme-coin-audit, mobile-pentest, report-writing, security-arsenal,
triage-validation, web2-recon, web2-vuln-classes, web3-audit.

## agent-zero/  (7 skills — framework meta, not for hunting)
a0-create-agent, a0-create-plugin, a0-development, a0-manage-plugin, build-skill,
scheduled-tasks, setup-a0-cli. (For building/extending the agent-zero framework itself.)

## methodology/
`My Bug Hunting Methodology.md` — full recon→enum→exploit→report workflow
(subfinder, amass, assetfinder, httpx, nuclei, sqlmap, etc.).
