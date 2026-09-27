---
name: authz-priv-esc-graphql
description: Privilege escalation via permission-scope gaps (team member → admin, external → admin via impersonation). Teaches horizontal/vertical priv-esc testing on role/scope APIs.
sources: hackerone_public
report_count: 2
---

# Privilege Escalation (role/scope gaps)

**Reports**: HackerOne — "Team member with Program permission only can escalate to Admin permission" (#605720); GitLab — "Privilege escalation from any user to GitLab admin when admin impersonates you" (#493324).

## Why it matters (the new lesson)
Role systems fail at the *edges*: a permission intended for one scope leaks into another, or an impersonation/preview feature drops back into a more privileged context. The highest-value priv-esc bugs aren't "broken auth" — they're **authorization scope gaps** found by comparing what a low-priv user can mutate vs. what they should.

## How it works
1. Team member (program-scoped) mutates their own role/scope to `admin` via an API that doesn't re-check.
2. Or: admin impersonates a user, and on exit the session retains admin — or a user can trigger self-impersonation.

## How to hunt for it
1. As a low-priv user, enumerate every role/scope mutation endpoint; attempt self-upgrade.
2. Test impersonation/preview/`as_user` features for scope retention after exit.
3. Compare permission boundaries across API vs UI (UI may hide the mutation).

## Payloads / flow
```
POST /api/team/members/{id} { permission: "admin" }   (from a program-scoped account)
POST /api/admin/impersonate { user: victim }  → then continue without exiting
```

## Fix
Enforce role/scope on every mutation server-side; no self-service role changes; re-resolve privileges after impersonation exit; audit scope transitions.
