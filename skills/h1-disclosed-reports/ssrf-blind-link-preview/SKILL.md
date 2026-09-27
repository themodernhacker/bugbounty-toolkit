---
name: ssrf-blind-link-preview
description: Blind SSRF via a link-preview/matrix API reaching internal services, confirmed OOB. Teaches blind-SSRF detection (DNS+HTTP OOB) and internal port/service enumeration when no response is returned.
sources: hackerone_public
report_count: 1
---

# Blind SSRF via Link Preview (OOB confirmation)

**Report**: Reddit — "Blind SSRF to internal services in matrix preview_link API" (hackerone.com/reports/1960765, $6,000). Also SSRF in webhooks → AWS key disclosure (Omise #508459).

## Why it matters (the new lesson)
"Blind" SSRF returns nothing to you, so the *only* way to prove it (and get paid) is **out-of-band (OOB)**: your Collaborator/interactsh domain receives the DNS/HTTP hit. Then you enumerate internal services by observing side effects (timing, error differences, status codes) since you can't read the response.

## How it works
The app fetches a user-supplied URL server-side but doesn't return the body. Give it `http://<your-collaborator-id>.oastify.com/x` and watch your listener for a DNS A/AAAA + HTTP request. That's proof. Then pivot to internal host:port probing.

## How to hunt for it
1. Find any "import/link/preview/fetch/notification" URL input.
2. Set it to `http://canary.burpcollaborator.net` and confirm DNS+HTTP in Collaborator.
3. Enumerate: `http://127.0.0.1:PORT`, `http://10.0.0.0/8` common services, cloud metadata. Detect open ports by response-time delta or error-string differences.

## Tooling
- Burp Collaborator (`generate_collaborator_payload`, `get_collaborator_interactions` in Burp MCP).
- `interactsh-client` (interactsh), `canarytokens`.

## Fix
Egress allowlist + block RFC1918/link-local/metadata; never allow user-controlled URLs to reach internal nets.
