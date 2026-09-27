---
name: spring-actuator-misconfig
description: Exposed Spring Boot Actuator endpoints with broken auth → heapdump/env disclosure, secrets, and sometimes RCE (jolokia/heapdump). Teaches actuator endpoint enumeration and exploitation.
sources: hackerone_public
report_count: 1
---

# Exposed Spring Boot Actuator → secrets / RCE

**Report**: LY Corporation — "Spring Actuator endpoints publicly available and broken authentication" (hackerone.com/reports/838635, critical, $12,500, Misconfiguration).

## Why it matters (the new lesson)
Spring Boot Actuator exposes `/actuator/*` management endpoints. Public + misconfigured actuator leaks env vars/`heapdump` (credentials, cloud keys), health/details, and can chain to RCE via `/jolokia`, `/heapdump` (extract secrets), or `/gateway` (route injection). It's one of the fastest "critical" wins in recon.

## How it works
```
/actuator            # list endpoints
/actuator/env        # env vars + propertySources (may include secrets)
/actuator/heapdump   # JVM heap -> grep for passwords/tokens (heapdump_tool)
/actuator/configprops
/actuator/mappings   # app routes
/actuator/jolokia    # JMX -> RCE
```

## How to hunt for it
1. `httpx -path /actuator,/actuator/env,/actuator/health,/actuator/heapdump` on every host.
2. Download `heapdump`; parse with `heapdump_tool` / `strings | grep -iE 'password|token|secret|key'`.
3. Check `/actuator/gateway/routes` + create a route → RCE (CVE-2022-22947 Spring Cloud Gateway), `/actuator/loggers`.

## Tooling
`httpx`, `curl`, `heapdump_tool` (`EugenMayer/heapdump_tool`), nuclei template `exposures/configs/springboot-actuator`.

## Fix
Require auth on `/actuator`; expose only on loopback; disable env/heapdump in prod; keep Spring Boot patched.
