---
name: subdomain-takeover-auth-bypass
description: Subdomain takeover chained to authentication bypass (dangling CNAME to a service you control → serve a malicious app/JS). Teaches takeover detection + escalation beyond defacement.
sources: hackerone_public
report_count: 1
---

# Subdomain Takeover → Authentication Bypass

**Report**: Roblox — "Subdomain Takeover → Authentication bypass" (hackerone.com/reports/335330). Also Uber auth-bypass via saostatic takeover (#219205), Starbucks datacafe-cert takeover (#665398).

## Why it matters (the new lesson)
A dangling DNS record (CNAME to an unclaimed S3 bucket, GitHub Pages, Heroku, CloudFront, Fastly) lets you *claim* that host. If the app treats that host as same-origin/trusted (for auth callbacks, cookies, or JS), takeover becomes auth bypass or stored XSS — not just defacement.

## How it works
1. Find `sub.example.com` CNAME → `x.s3.amazonaws.com` (unclaimed) or `github.io`/`herokuapp.com`/`cloudfront.net` (deleted).
2. Claim the resource under the same name.
3. Serve content as that subdomain → steal cookies (if `Domain=.example.com` scoped) or bypass auth that trusts the host.

## How to hunt for it
1. Enumerate subdomains (subfinder, amass, assetfinder, crt.name).
2. Resolve CNAMEs and check for dangling states (NXDOMAIN on target, "NoSuchBucket", GitHub Pages 404 page, Heroku "no such app").
3. Claim and verify; check cookie scope and any auth/origin trust.

## Tooling
- `subfinder -d domain | dnsx -cname -resp`, `nuclei -t http/takeovers/`, `subzy`, `can-i-take-over-xyz`.

## Fix
Remove dangling DNS records on deprovision; verify ownership before provisioning; scope cookies tightly.
