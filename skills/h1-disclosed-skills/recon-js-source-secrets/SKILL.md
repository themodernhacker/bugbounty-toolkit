---
name: recon-js-source-secrets
description: Finding leaked API keys/secrets in JavaScript bundles and source maps. Teaches the JS recon pipeline: collect JS → source maps → beautify → regex for keys/tokens/endpoints.
sources: hackerone_public
report_count: 1
---

# API Keys / Secrets in JS & Source Maps

**Report**: Stripo — "Public and secret api key leaked in JavaScript source" (hackerone.com/reports/983331, medium). See also Google Docs link in JS (#2180521).

## Why it matters (the new lesson)
SPAs bundle config, and source maps (`.map`) often contain the *unminified* original — with API keys, internal endpoints, secrets, and comments that reveal the backend. Extracting JS + source maps is a high-yield, low-risk recon step that frequently yields hardcoded credentials.

## How it works
1. Crawl the site for `.js` (katana, hakrawler, grep `src=`, `.map`).
2. If a JS ends with `//# sourceMappingURL=app.js.map`, fetch `app.js.map` → `sourcesContent` = full source.
3. Regex for secrets: `api[_-]?key`, `secret`, `token`, `Bearer`, `aws_`, `AIza` (GCP), `sk_live`, `pk_live`, `AKIA` (AWS), `ghp_`, `-----BEGIN`.

## How to hunt for it
```bash
katana -u https://target -jc | grep -E '\.js(\?|$)' | anew js.txt
# for each js, fetch + check sourceMappingURL, beautify, grep
cat js.txt | xargs -I{} sh -c 'curl -s {} | tee >(grep -oE "sourceMappingURL=[^ ]+" )'
grep -rhoE '(AKIA|AIza|ghp_|sk_live|Bearer [A-Za-z0-9._-]{20,})[A-Za-z0-9_./+-]{8,}' js/ | sort -u
```

## Tooling
`katana`, `gau`/`waybackurls` (historical JS), `getJS`, `LinkFinder`, `SecretFinder`, `trufflehog`, `gitleaks`, `js-beautify`, `sourcemapper`.

## Fix
Never ship secrets to the client; use runtime proxy/edge config; strip source maps from prod; rotate any leaked keys.
