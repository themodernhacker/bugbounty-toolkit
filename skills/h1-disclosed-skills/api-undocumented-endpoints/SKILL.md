---
name: api-undocumented-endpoints
description: Finding undocumented/hidden API endpoints (GraphQL `fileCopy`, internal APIs returning client secrets) that skip access-control review. Teaches API surface discovery and introspecting schemas/JS for hidden mutations.
sources: hackerone_public
report_count: 1
---

# Undocumented API Endpoints / Hidden Mutations

**Reports**: Shopify — "Undocumented `fileCopy` GraphQL API" (hackerone.com/reports/981472, $2,000); Uber — "Client secret, server tokens for developer applications returned by internal API" (#419655).

## Why it matters (the new lesson)
Undocumented endpoints and hidden GraphQL mutations are the least-tested attack surface: they often skip the access-control and rate-limit review that public endpoints get. Discovery — not exploitation — is the hard part, and it pays.

## How it works
- GraphQL: introspect the schema, list all mutations, grep the client JS for query strings referencing unexposed fields (`fileCopy`, `adminGenerateSessionPayload`).
- REST: diff mobile vs web vs internal APIs; enumerate `/api/v1`, `/internal`, `/admin`, `/v2`, and paths found in JS bundles/source maps.

## How to hunt for it
1. Run GraphQL introspection (`__schema { types { name fields { name } } }`) and diff against the docs.
2. Grep JS/source maps for `mutation`, `/api/`, endpoint strings; enumerate.
3. For each hidden endpoint/mutation, test with low-privilege tokens for missing authorization.

## Payloads
```graphql
{ __schema { mutationType { fields { name } } } }
mutation { fileCopy(input:{source:"x", destination:"y"}) { ... } }
```

## Fix
Disable introspection in prod; enforce authz on every endpoint/mutation (not just documented ones); review internal APIs.
