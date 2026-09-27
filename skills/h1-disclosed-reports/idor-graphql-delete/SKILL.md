---
name: idor-graphql-delete
description: IDOR in a GraphQL mutation deleting all licenses/certifications for any user. Teaches GraphQL mutation-level authorization testing and object-reference IDOR in APIs.
sources: hackerone_public
report_count: 1
---

# IDOR in GraphQL mutations (delete any user's data)

**Report**: HackerOne — "IDOR delete all Licenses/certifications via CreateOrUpdateHackerCertification GraphQL mutation" (hackerone.com/reports/2122671). Also GraphQL BillingDocumentDownload/BillDetails (Shopify #2207248).

## Why it matters (the new lesson)
GraphQL concentises many mutations into one endpoint; each mutation/field needs its own authz check, and teams frequently forget on write (delete/update) operations. Test *mutations*, not just queries — destructive IDOR is critical severity.

## How it works
```graphql
mutation { createOrUpdateHackerCertification(input:{ hackerId:"VICTIM", ... }) { ... } }
```
Passing another user's `hackerId` (or `userId`) in the input lets you act on their objects.

## How to hunt for it
1. Introspect or collect the GraphQL schema (`__schema`, `__type`), list all `mutation` fields.
2. For each mutation taking an object ID, replay as user B targeting user A's ID.
3. Check delete/update/write mutations first (highest impact), then read queries.

## Tooling
- GraphQL introspection via `graphql-path-enum`/GraphQLmap, `altair`, Burp with GraphQL queries.
- Watch `input` types for `*Id`/`*Uuid` fields.

## Fix
Authorize every resolver against the authenticated principal; validate object ownership in the resolver, not the client.
