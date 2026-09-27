---
name: recon-github-dorking
description: Finding leaked secrets/tokens in public GitHub repos and gists (GitHub dorking). Teaches GitHub code search syntax, org-wide secret scanning, and validating live tokens.
sources: hackerone_public
report_count: 3
---

# GitHub Secret Leakage (Dorking)

**Reports**: Snapchat — "Github Token Leaked publicly" (hackerone.com/reports/396467, critical) and "Leaked JFrog Artifactory creds on GitHub" (#911606, $15,000); Grab — "Leaking sensitive info on Github → full access to all Grab Slack channels" (#397527, critical).

## Why it matters (the new lesson)
Employees commit tokens/keys to public repos. GitHub's code search is the world's largest free secret-hunting ground. A single leaked token often grants access to internal systems (JFrog, Slack, cloud, SCM). This is pure-recon, zero-target-interaction, and routinely critical.

## How it works
GitHub search qualifiers:
```
org:company "password"
org:company "BEGIN RSA PRIVATE KEY"
org:company extension:env DB_PASSWORD
org:company "api_key" "AKIA"
org:company "token" "ghp_"
```
Then validate found keys with KeyHacks / cloud CLI (`aws sts get-caller-identity`).

## How to hunt for it
1. Enumerate the company's GitHub orgs/users (also employee personal repos).
2. Search for secret patterns (tokens, keys, `.env`, `id_rsa`, configs, CI logs).
3. Validate live keys (KeyHacks, `curl -H "Authorization: token ..."`); check scope.
4. Also monitor commit history of public repos (`git log -S "key"`).

## Tooling
GitHub search UI/API, `gitleaks`, `trufflehog`, `git-secrets`, `github-dorks` repo, `KeyHacks`, `nuclei -t exposures/tokens/github/`.

## Fix
Pre-commit secret scanning (gitleaks/trufflehog in CI); no secrets in repos; rotate leaked keys immediately; GitHub push protection.
