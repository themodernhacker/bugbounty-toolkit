---
name: ssrf-to-rce-exchange
description: SSRF into an internal Exchange/EWS instance leading to ROOT access on all instances. Teaches the SSRF-to-internal-service-RCE chain and how internal protocols (EWS, gopher, HTTP) are abused through a URL-fetch primitive.
sources: hackerone_public
report_count: 1
---

# SSRF → RCE via internal Exchange (root on all instances)

**Report**: Shopify — "SSRF in Exchange leads to ROOT access on all instances" (hackerone.com/reports/341876, critical). Related chains: SSRF → RCE in confluence (QIWI #713900), SSRF → Redis RCE via gopher (Yahoo).

## Why it matters (the new lesson)
SSRF is often treated as "read metadata → done". The real prize is pivoting a URL-fetch primitive into an **internal service** that exposes a second-stage exploit (Exchange EWS, Jenkins, Redis, Elasticsearch, Confluence, internal GraphQL). One SSRF can become full RCE with no auth because "internal" endpoints trust the caller.

## How it works
1. Find a feature that fetches a server-supplied URL (webhook, import, preview, avatar proxy, report generator).
2. Point it at internal host:port (`http://127.0.0.1`, `http://10.x`, `http://[::1]`, `http://exchange.internal/`).
3. Speak the internal service's protocol over the same connection — e.g. Exchange Autodiscover/EWS SOAP, or `gopher://` to a raw TCP service (Redis, memcached, MySQL).

## How to hunt for it
1. Map every "fetch URL"/"import URL"/"webhook"/"preview" feature.
2. Confirm SSRF with Collaborator/interactsh (OOB), then enumerate internal ports/hosts (IP fuzzing, `169.254.169.254`, common `10.x/172.x/192.168.x`).
3. For each reachable service, attempt its known RCE path.

## Payloads (protocol tricks)
```
http://169.254.169.254/latest/meta-data/iam/security-credentials/   # AWS
http://metadata.google.internal/computeMetadata/v1/                 # GCP (needs Metadata-Flavor: Google)
http://169.254.169.254/metadata/instance?api-version=2021-02-01     # Azure (needs Metadata: true)
gopher://127.0.0.1:6379/_REDIS RCE payload                          # Redis
```

## Fix
Block/allowlist outbound fetch destinations; forbid internal/link-local IPs (with IPv6 + DNS-rebinding aware checks); disable gopher/dict/file schemes; require auth on internal services.
