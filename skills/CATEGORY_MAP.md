# CATEGORY_MAP.md — 100 bug categories → skills

Routing table from the target taxonomy to the skills that cover each class.
**Primary** = load this first (core, always discoverable). **+H1** = also load the
`h1-<class>` companion (`skills/hackerone-reports/`) for disclosed-report patterns.
**On-demand** = `grep -i "<kw>" skills/SKILL_INDEX.tsv` then `cat` the match.

Legend: 🟢 covered by a core skill · 🔵 covered on-demand · ⛔ out of scope in
almost every program — do **not** test without explicit written authorization.

## ⚡ Injection
| # | Category | Primary skill | Also |
|---|---|---|---|
| 1 | SQL Injection | 🟢 `hunt-sqli` | +H1 `h1-sqli`, `security-arsenal` |
| 2 | XSS | 🟢 `hunt-xss` | +H1 `h1-xss`, `hunt-dom` (DOM) |
| 3 | CSRF | 🟢 `hunt-csrf` | +H1 `h1-csrf` |
| 4 | RCE | 🟢 `hunt-rce` | +H1 `h1-rce` |
| 5 | Command Injection | 🔵 `cmdi-command-injection` (yaklang) | `hunt-rce` |
| 6 | XML Injection | 🟢 `hunt-xxe` | `security-arsenal` |
| 7 | LDAP Injection | 🔵 `hunt-ldap` | — |
| 8 | XPath Injection | 🔵 grep `xpath` / `hunt-misc` | `security-arsenal` |
| 9 | HTML Injection | 🔵 `hunt-html-injection` | escalate → `hunt-xss` |
| 10 | SSI Injection | 🔵 grep `ssi` / `hunt-misc` | `hunt-rce` |
| 11 | OS Command Injection | 🔵 `cmdi-command-injection` (yaklang) | `hunt-rce` |
| 12 | Blind SQLi | 🟢 `hunt-sqli` | +H1 `h1-sqli` |
| 13 | SSTI | 🟢 `hunt-ssti` | +H1 `h1-ssti` |

## ⚡ Broken Auth & Session
| # | Category | Primary skill | Also |
|---|---|---|---|
| 14 | Session Fixation | 🔵 `hunt-session` | +H1 `h1-auth` |
| 15 | Brute Force | 🔵 `hunt-brute-force` | `hunt-mfa-bypass` |
| 16 | Session Hijacking | 🔵 `hunt-session` | `hunt-ato` |
| 17 | Password Cracking | 🔵 `credential-attack` (agentic) | own accounts only |
| 18 | Weak Password Storage | 🔵 `h1-info-disclosure` | `security-arsenal` |
| 19 | Insecure Authentication | 🟢 `hunt-auth-bypass` | +H1 `h1-auth` |
| 20 | Cookie Theft | 🟢 `hunt-xss` → session | `hunt-ato` |
| 21 | Credential Reuse | 🔵 `credential-attack` | own accounts only |

## ⚡ Sensitive Data Exposure
| # | Category | Primary skill | Also |
|---|---|---|---|
| 22 | Inadequate Encryption | 🔵 `hunt-tls-network` | grep `crypto` |
| 23 | IDOR | 🟢 `hunt-idor` | +H1 `h1-idor` |
| 24 | Data Leakage | 🟢 `hunt-source-leak` | +H1 `h1-info-disclosure` |
| 25 | Unencrypted Storage | 🔵 `h1-info-disclosure` | `hunt-mobile` (mobile) |
| 26 | Missing Security Headers | 🔵 `security-arsenal` / `hunt-misc` | usually low sev |
| 27 | Insecure File Handling | 🟢 `hunt-file-upload` | `hunt-lfi` |

## ⚡ Security Misconfiguration
| # | Category | Primary skill | Also |
|---|---|---|---|
| 28 | Default Passwords | 🔵 `security-arsenal` | `credential-attack` |
| 29 | Directory Listing | 🔵 `hunt-source-leak` | +H1 `h1-info-disclosure` |
| 30 | Unprotected API Endpoints | 🟢 `hunt-shadow-api` | `hunt-api-misconfig`, +H1 `h1-api` |
| 31 | Open Ports/Services | 🟢 recon (`web2-recon`, naabu/nmap) | `recon-scope-triage` |
| 32 | Improper Access Controls | 🟢 `hunt-idor` | +H1 `h1-authorization` |
| 33 | Information Disclosure | 🟢 `hunt-source-leak` | +H1 `h1-info-disclosure` |
| 34 | Unpatched Software | 🟢 recon + `nuclei` | `security-arsenal` |
| 35 | Misconfigured CORS | 🟢 `hunt-cors` | `security-arsenal` |
| 36 | HTTP Header Misconfig | 🔵 `hunt-misc` / `security-arsenal` | `hunt-host-header` |

## ⚡ XML
| # | Category | Primary skill | Also |
|---|---|---|---|
| 37 | XXE | 🟢 `hunt-xxe` | +H1 `h1-xxe` |
| 38 | XML Entity Expansion (XEE) | ⛔ DoS-class | study only; `hunt-xxe` for structure |
| 39 | XML Bomb | ⛔ DoS-class | do not detonate on live systems |

## ⚡ Broken Access Control
| # | Category | Primary skill | Also |
|---|---|---|---|
| 40 | Inadequate Authorization | 🟢 `hunt-idor` | +H1 `h1-authorization` |
| 41 | Privilege Escalation | 🟢 `hunt-idor` | +H1 `h1-authorization` |
| 42 | Insecure DOR | 🟢 `hunt-idor` | +H1 `h1-idor` |
| 43 | Forceful Browsing | 🔵 dir brute (`ffuf`/`feroxbuster`) | `hunt-shadow-api` |
| 44 | Missing Function-Level AC | 🟢 `hunt-idor` | +H1 `h1-authorization` |

## ⚡ Insecure Deserialization
| # | Category | Primary skill | Also |
|---|---|---|---|
| 45 | RCE via Deserialization | 🟢 `hunt-deserialization` | `hunt-rce`, +H1 `h1-rce` |
| 46 | Data Tampering | 🟢 `hunt-deserialization` | `hunt-business-logic` |
| 47 | Object Injection | 🟢 `hunt-deserialization` | `prototype-pollution` (yaklang) |

## ⚡ API Security
| # | Category | Primary skill | Also |
|---|---|---|---|
| 48 | Insecure API Endpoints | 🟢 `hunt-api-misconfig` | +H1 `h1-api` |
| 49 | API Key Exposure | 🟢 `hunt-source-leak` | `secrets-in-git-history` (useosint) |
| 50 | Lack of Rate Limiting | 🔵 `hunt-brute-force` | `h1-api` |
| 51 | Inadequate Input Validation | 🟢 injection skills (1–13) | `hunt-api-misconfig` |

## ⚡ Insecure Communication
| # | Category | Primary skill | Also |
|---|---|---|---|
| 52 | MITM | ⛔ needs network position | out of web scope; `hunt-tls-network` for TLS flaws |
| 53 | Insufficient TLS | 🔵 `hunt-tls-network` | `tlsx` |
| 54 | Insecure SSL/TLS Config | 🔵 `hunt-tls-network` | `tlsx`, `nuclei` ssl |
| 55 | Insecure Protocols | 🔵 `hunt-tls-network` | recon |

## ⚡ Client-Side
| # | Category | Primary skill | Also |
|---|---|---|---|
| 56 | DOM XSS | 🟢 `hunt-dom` | `hunt-xss`, +H1 `h1-xss` |
| 57 | Insecure Cross-Origin Comm | 🟢 `hunt-cors` | postMessage → `hunt-dom` |
| 58 | Browser Cache Poisoning | 🟢 `hunt-cache-poison` | +H1 `h1-web-cache` |
| 59 | Clickjacking | 🟢 `hunt-clickjacking` | +H1 `h1-clickjacking` |
| 60 | HTML5 Security Issues | 🔵 `hunt-dom` | `hunt-cors` |

## ⚡ Denial of Service ⛔ (61–65)
All DoS classes (DDoS, App-layer DoS, Resource Exhaustion, Slowloris, XML DoS)
are **out of scope in essentially every bug bounty program.** Study the
`h1-dos` skill for *defensive* pattern knowledge; do **not** run DoS/stress
tooling against a target without explicit written authorization for that exact
class. No offensive DoS tooling is provided here by design.

## ⚡ Other Web
| # | Category | Primary skill | Also |
|---|---|---|---|
| 66 | SSRF | 🟢 `hunt-ssrf` | +H1 `h1-ssrf` |
| 67 | HTTP Parameter Pollution | 🔵 `http-parameter-pollution` (yaklang) | `hunt-misc` |
| 68 | Insecure Redirects/Forwards | 🟢 `hunt-open-redirect` | +H1 `h1-open-redirect` |
| 69 | File Inclusion (LFI/RFI) | 🟢 `hunt-lfi` | +H1 `h1-file-reading` |
| 70 | Security Header Bypass | 🔵 `hunt-misc` | `hunt-host-header` |
| 71 | Clickjacking | 🟢 `hunt-clickjacking` | +H1 `h1-clickjacking` |
| 72 | Inadequate Session Timeout | 🔵 `hunt-session` | low sev alone |
| 73 | Insufficient Logging/Monitoring | 🔵 `hunt-misc` | usually informational |
| 74 | Business Logic | 🟢 `hunt-business-logic` | +H1 `h1-business-logic` |
| 75 | API Abuse | 🟢 `hunt-api-misconfig` | +H1 `h1-api` |

## ⚡ Mobile
| # | Category | Primary skill | Also |
|---|---|---|---|
| 76 | Insecure Data Storage | 🔵 `mobile-pentest` (agentic) | +H1 `h1-mobile` |
| 77 | Insecure Data Transmission | 🔵 `mobile-pentest` | `hunt-tls-network` |
| 78 | Insecure Mobile API | 🔵 `mobile-pentest` | `hunt-api-misconfig` |
| 79 | Mobile App Reverse Eng. | 🔵 `android-pentesting-tricks` / `ios-pentesting-tricks` (yaklang) | jadx/apktool |

## ⚡ IoT / WoT (80–84)
🔵 No dedicated skill — IoT/WoT is usually outside standard web bug bounty scope.
Approach with device/network recon (nmap, firmware analysis) + the API skills
(`hunt-api-misconfig`, `hunt-auth-bypass`) **only for assets explicitly in a
program's scope.** Treat smart-home/privacy testing as requiring written
authorization.

## ⚡ Authentication Bypass
| # | Category | Primary skill | Also |
|---|---|---|---|
| 85 | Insecure "Remember Me" | 🔵 `hunt-session` | `hunt-auth-bypass` |
| 86 | CAPTCHA Bypass | 🔵 `hunt-captcha-bypass` | `hunt-brute-force` |

## ⚡ SSRF (deep)
| # | Category | Primary skill | Also |
|---|---|---|---|
| 87 | Blind SSRF | 🟢 `hunt-ssrf` (OOB) | +H1 `h1-ssrf` |
| 88 | Time-Based Blind SSRF | 🟢 `hunt-ssrf` | `interactsh-client` |

## ⚡ Content Spoofing
| # | Category | Primary skill | Also |
|---|---|---|---|
| 89 | MIME Sniffing | 🔵 `hunt-misc` (X-Content-Type-Options) | often low sev |
| 90 | X-Content-Type-Options Bypass | 🔵 `hunt-misc` | `hunt-file-upload` (content-type) |
| 91 | CSP Bypass | 🔵 `csp-bypass-advanced` (yaklang) | `hunt-xss` |

## ⚡ Business Logic Flaws
| # | Category | Primary skill | Also |
|---|---|---|---|
| 92 | Inconsistent Validation | 🟢 `hunt-business-logic` | injection skills |
| 93 | Race Conditions | 🟢 `hunt-race-condition` | +H1 `h1-race-condition` |
| 94 | Order Processing | 🟢 `hunt-business-logic` | +H1 `h1-business-logic` |
| 95 | Price Manipulation | 🟢 `hunt-business-logic` | +H1 `h1-business-logic` |
| 96 | Account Enumeration | 🔵 `hunt-brute-force` | `h1-auth` |
| 97 | User-Based Flaws | 🟢 `hunt-idor` | `hunt-business-logic` |

## ⚡ Zero-Day / Novel (98–100)
No skill can encode an *unknown* bug. Hunt these by combining the disclosed-report
companions (`skills/hackerone-reports/`, `skills/h1-disclosed-skills/`) for novel
chains, deep JS/attack-surface analysis, and the "What-If" framework in
`bb-methodology`. Report responsibly; never weaponize an unpatched 0-day beyond a
minimal, authorized PoC.

---

### Recon & methodology (Modules 2–8)
| Need | Skill(s) |
|---|---|
| Passive recon / OSINT | `web2-recon`, `osint-methodology`, useosint: `recon-a-domain-passively`, `find-hidden-subdomains`, `google-like-a-spy` |
| Active recon / 403 bypass / staging | `web2-recon`, grep `403` / `attack-surface-mapping` (yaklang) |
| Endpoint & param discovery | `web2-recon`, `hunt-shadow-api`, arjun/paramspider |
| JS & token analysis | `hunt-source-leak`, `secrets-in-git-history`, LinkFinder/SecretFinder |
| GitHub/secret recon | `hunt-source-leak`, `secrets-in-git-history`, trufflehog/gitleaks |
| Cloud/bucket exposure | `hunt-cloud-misconfig`, S3Scanner/cloud_enum |
| Chaining | `bb-methodology`, `hunt-ato`, +H1 companions |
| PoC / reporting / payout | `triage-validation`, `evidence-hygiene`, `report-writing`, `bugcrowd-reporting` |
