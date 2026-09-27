---
name: sqli-user-agent-header
description: SQL injection in HTTP headers (User-Agent, Referer, X-Forwarded-For) — injection points scanners skip. Teaches testing every header as a SQLi input and how logs/metrics sinks are injectable.
sources: hackerone_public
report_count: 1
---

# SQL Injection in HTTP Headers (User-Agent)

**Report**: GSA (labs.data.gov) — "SQL injection in .../csv_to_json via User-Agent" (hackerone.com/reports/297478, critical, SQL Injection).

## Why it matters (the new lesson)
Developers parameterize query strings but often splice headers (`User-Agent`, `Referer`, `X-Forwarded-For`, `X-Real-IP`, `Cookie`) into queries for logging, analytics, or geo/device lookup. Automated scanners rarely test headers, so header SQLi survives. **Always test headers.**

## How it works
```sql
-- app does: INSERT INTO visits(user_agent) VALUES('$UA')
```
Attacker sets `User-Agent: ' OR 1=1 --` → boolean/time-based results, or error-based via malformed quotes.

## How to hunt for it
1. Identify endpoints that log/fingerprint the client (analytics, dashboards, error pages echoing your UA).
2. Inject into `User-Agent`, `Referer`, `X-Forwarded-For`, `X-Real-IP`, `X-Client-IP`, `Cookie`.
3. Use error/boolean/time payloads and observe.
4. Then dump via sqlmap with `--headers`.

## Payloads
```
User-Agent: ' OR '1'='1
User-Agent: ' OR SLEEP(5)-- -
User-Agent: " AND 1=2 UNION SELECT 1,2,3--
```

## Tooling
`sqlmap -u URL --headers="User-Agent: ' OR 1=1--" --level 5 --risk 3`; Burp Repeater.

## Fix
Never concatenate headers into SQL; parameterize; store raw headers and query with bound params.
