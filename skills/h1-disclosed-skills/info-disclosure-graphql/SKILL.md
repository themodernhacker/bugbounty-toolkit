---
name: info-disclosure-graphql
description: Sensitive data disclosure through GraphQL (over-broad types/fields, missing field-level authz). Teaches enumerating GraphQL objects for sensitive fields and the field-level authorization gap.
sources: hackerone_public
report_count: 1
---

# Confidential Data Disclosure via GraphQL

**Report**: HackerOne — "Confidential data of users and limited metadata of programs/reports accessible via GraphQL" (hackerone.com/reports/489146, critical, Information Disclosure).

## Why it matters (the new lesson)
GraphQL centralizes data access into one schema; if field-level authorization is missing, a low-privilege query can pull sensitive fields (emails, private reports, tokens) that REST endpoints would hide. GraphQL also makes **schema discovery** easy — you can enumerate every type/field and hunt for authorization gaps systematically.

## How it works
Introspect, then query a sensitive field on a type you shouldn't reach:
```graphql
{ __schema { types { name fields { name } } } }
query { team(id:"x") { name handle private_comment report_sources } }
```

## How to hunt for it
1. Introspect the full schema; list every type and field.
2. Look for sensitive field names: `email`, `token`, `secret`, `payment_transactions`, `private_comment`, `vpn_suspended`, `report_sources`.
3. Query each as a low-privilege user; flag any field returning data beyond your entitlement.

## Payloads
```graphql
{ team { handle total_whitelisted_hackers } }
{ report(id:123){ title vulnerability_information } }
{ me { email } }
```

## Fix
Field-level authorization (reject queries for fields the caller can't access); disable introspection in prod; query allowlists; depth/cost limits.
