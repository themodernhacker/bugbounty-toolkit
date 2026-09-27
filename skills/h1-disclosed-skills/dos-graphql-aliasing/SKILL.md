---
name: dos-graphql-aliasing
description: GraphQL DoS via mutation/query aliasing (batching one field thousands of times) and depth/complexity abuse. Teaches aliasing-based resource exhaustion and how to measure query cost.
sources: hackerone_public
report_count: 1
---

# DoS via GraphQL Mutation/Query Aliasing

**Report**: HackerOne — "DOS via Mutation Aliasing in GraphQL Account Recovery Phone Number Verification API" (#3287208, $12,500).

## Why it matters (the new lesson)
GraphQL lets you alias the same field repeatedly in one request, bypassing "one operation = one cost" assumptions. A single request that runs a heavy field 10,000 times (or triggers 10,000 SMS/email sends) exhausts CPU, DB, or external quotas — a cheap, high-impact DoS that rate limiters (which count *requests*, not *field executions*) miss.

## How it works
```graphql
mutation {
  a1: sendVerification(phone:"+15550001") { ok }
  a2: sendVerification(phone:"+15550002") { ok }
  ... x10000
}
```

## How to hunt for it
1. Find expensive/state-changing fields (send code, search, fetch, file gen).
2. Alias it hundreds/thousands of times in a single request.
3. Observe CPU/time/resource or external side effects (SMS flood, email flood).

## Payloads
```graphql
query { a1:search(q:"a"){id} a2:search(q:"a"){id} ... }
```

## Fix
Query cost/depth analysis; cap field executions per request; persist rate limits per field; disallow aliasing sensitive mutations.
