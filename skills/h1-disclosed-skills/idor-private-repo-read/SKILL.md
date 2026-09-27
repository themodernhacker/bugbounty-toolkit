---
name: idor-private-repo-read
description: Arbitrary read of another user's private repository without authorization — cross-tenant IDOR in source-hosting APIs. Teaches testing cross-user object access on repo/object APIs.
sources: hackerone_public
report_count: 1
---

# Arbitrary Read of Another User's Private Repository

**Report**: GitHub — "Arbitrary Read of Another User's private repository without Authorization" (#3124517, $10,000).

## Why it matters (the new lesson)
Source-hosting platforms are the highest-value IDOR targets: private repos contain secrets, source, and PII. Cross-tenant object access (changing the `owner`/`repo`/`id` in an API or a fork/import/migration path) leaks a whole repository. The bug usually hides in a *secondary* access path (imports, migrations, webhooks, archives) that skips the normal ACL check.

## How it works
1. Find an API that references a repo by ID/name without re-checking ownership (e.g. import/archive/fork).
2. Substitute another user's `owner`/`repo` → read their private content.

## How to hunt for it
1. Enumerate repo-access APIs beyond the obvious `GET /repos/{owner}/{repo}` (import, migrate, archive, fork, raw, trees, compare, webhook).
2. Replace the owner/repo/ID with a victim's; observe if private data returns.
3. Test across tenants (your account vs. another user's).

## Payloads / flow
```
GET /api/import/{victim}/private-repo  → 200 with content
GET /repos/{victim}/{private}/archive/...
```

## Fix
Re-check object ACL against the authenticated principal at the point of read; deny cross-tenant by default; test secondary paths.
