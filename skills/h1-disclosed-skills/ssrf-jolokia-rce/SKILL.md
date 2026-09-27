---
name: ssrf-jolokia-rce
description: SSRF to an internal Jolokia/JMX endpoint chained to RCE (Kafka Connect). Teaches JMX/Jolokia exploitation over SSRF and chaining file-upload + SSRF to reach privileged internal agents.
sources: hackerone_public
report_count: 1
---

# SSRF → internal Jolokia (JMX) → RCE

**Report**: Aiven — "[Kafka Connect] RCE by leveraging file upload + SSRF to internal Jolokia" (hackerone.com/reports/1547877, critical, $5,000).

## Why it matters (the new lesson)
Internal management agents (Jolokia/JMX, Spring Boot Actuator, Consul, etcd, Redis, Elasticsearch) are reachable from inside but not from the internet. An SSRF is your doorway. Jolokia exposes `exec`/`set` MBean operations that can load a remote class / write a file → RCE. The lesson: enumerate internal management ports over SSRF, not just cloud metadata.

## How it works
1. File-upload feature stores a malicious payload (e.g. a `.jar`/JSP) at a predictable path, or SSRF reaches Jolokia directly.
2. Use Jolokia's `exec` MBean (e.g. `java.util.logging`, `reloadByURL`, `mbean` `javax.management.loading.MLet`) to trigger class load / code execution.

## How to hunt for it
1. Confirm SSRF (Collaborator), then scan internal ports 8080/8778/11211/2379/9200/2181/1099.
2. Probe Jolokia: `http://target:8778/jolokia/list`, `.../exec/...` → check for writable MBeans.
3. Chain to load your hosted class → RCE.

## Payloads (Jolokia)
```
http://127.0.0.1:8778/jolokia/list
http://127.0.0.1:8778/jolokia/exec/java.lang:type=Memory/gc
http://127.0.0.1:8778/jolokia/exec/com.sun.management:type=DiagnosticCommand/.../...
```

## Fix
Bind Jolokia/Actuator/JMX to loopback + require auth; firewall internal management ports; SSRF egress allowlist; don't expose management agents to app-reachable network.
