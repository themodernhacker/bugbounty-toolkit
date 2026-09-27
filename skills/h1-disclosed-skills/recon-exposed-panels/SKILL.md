---
name: recon-exposed-panels
description: Finding and accessing exposed internal dashboards (Grafana, Kibana, Elasticsearch, proxies, Phabricator) via fingerprinting. Teaches panel discovery and the PII/secret exposure they yield.
sources: hackerone_public
report_count: 2
---

# Exposed Internal Dashboards & Proxies

**Reports**: Snapchat — "Access to multiple production Grafana dashboards" (hackerone.com/reports/663628, high, $10,000); Reddit — "Exposed proxy allows to access internal reddit domains" (hackerone.com/reports/2967634, $7,500). Also Uber Phabricator via leaked cert (#591813, $40,000).

## Why it matters (the new lesson)
Monitoring/admin tools (Grafana, Kibana, Elasticsearch, Prometheus, Jaeger, Phabricator, open proxies) are often bound to a public host with default/no auth. Grafana leaks dashboards + queryable datasources (internal hosts, tokens), Elasticsearch leaks indices, and an open proxy lets you reach the internal network directly.

## How it works
Fingerprint + probe:
```
/                        # title "Grafana", "Kibana"
/api/org, /api/dashboards, /api/ds/query   # Grafana unauth endpoints
/.kibana, /_cat/indices                     # Elasticsearch/Kibana
/api/health                                 # Prometheus
```

## How to hunt for it
1. Mass-fingerprint: `httpx -title -tech-detect -path /,/login,/api/health` across subdomains/IPs.
2. Grafana: `/api/search`, `/api/dashboards/home`, `/api/datasources` (may expose creds), `/render/d-solo/...` (SSRF).
3. Elasticsearch: `/_cat/indices?v`, `/_search?q=password`.
4. Open proxy: `curl -x http://target:3128 http://internal` — enumerate internal hosts.

## Tooling
`httpx -tech-detect`, `whatweb`, `wappalyzer`, nuclei `exposed-panels/` + `grafana-*` templates.

## Fix
AuthN/Z on all dashboards; SSO; network-isolate (VPN only); disable anonymous access; audit datasource creds.
