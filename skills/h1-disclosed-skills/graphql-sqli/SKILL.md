---
name: graphql-sqli
description: SQL injection in a GraphQL endpoint via an embedded_submission_form_uuid field — classic SQLi hidden behind a GraphQL schema. Teaches SQLi testing inside GraphQL/JSON APIs.
sources: hackerone_public
report_count: 1
---

# SQLi inside a GraphQL endpoint

**Report**: HackerOne — "SQLi in GraphQL endpoint via embedded_submission_form_uuid" (hackerone.com/reports/435066). Also MTN SQLi in URL path (#2633959), QIWI SQLi→RCE (#816254).

## Why it matters (the new lesson)
GraphQL doesn't eliminate SQLi — resolvers still build queries from arguments. Scan for SQLi *inside* GraphQL mutations/queries and JSON APIs, where classic URL-parameter scanners never look.

## How it works
```graphql
{ report(embedded_submission_form_uuid: "' OR '1'='1") { id } }
```
The argument is concatenated into SQL in the resolver → boolean/UNION/time-based SQLi.

## How to hunt for it
1. Collect GraphQL fields (introspection) and identify those taking UUID/string ids that likely hit a DB.
2. Inject `'`, `" OR 1=1--`, `' AND SLEEP(5)--`, `' UNION SELECT ...--`.
3. Detect via timing (SLEEP), boolean (true/false result), or error messages.

## Payloads
```
' OR '1'='1
' UNION SELECT null-- 
' AND (SELECT * FROM (SELECT(SLEEP(5)))a)-- 
1 AND 1=2
```

## Tooling
- `sqlmap` with the GraphQL query as `--data`/raw body; `ghauri`; Burp Intruder.

## Fix
Parameterized queries/ORMs in resolvers; never concatenate GraphQL args into SQL.
