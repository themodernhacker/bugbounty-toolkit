---
name: idor-private-reports
description: IDOR exposing private report details via an unauthenticated /bugs.json endpoint that leaks object IDs. Teaches object-ID discovery + reference-enumeration IDOR (the most common and most misrated bug class).
sources: hackerone_public
report_count: 1
---

# IDOR: view private report details via /bugs.json

**Report**: HackerOne — "IDOR view private report details via /bugs.json" (hackerone.com/reports/2487889). Related: IDOR delete any Campaigns (#1969141), IDOR delete all Licenses via GraphQL (#2122671).

## Why it matters (the new lesson)
IDOR is usually a *missing per-object authorization check*, not a broken "ID" scheme. The key skill is finding a second identifier (a numeric ID, UUID, or a field like `team_id`/`report_id`) and swapping it between two accounts to see if the server enforces ownership. Don't assume IDs are unguessable — test the reference.

## How it works
```http
GET /bugs.json?report_id=12345   # returns JSON with private fields for ANY id
```
The endpoint trusts the client-supplied ID and never verifies the requester owns/`can_view` the object.

## How to hunt for it
1. Create two accounts (A and B).
2. With A, create/access an object, capture its ID.
3. With B (or unauthenticated), request that same ID.
4. Compare responses — if B sees A's data, it's IDOR.
5. Enumerate sequential IDs and watch for new object classes in JSON/GraphQL responses.

## Tooling
- Burp Repeater (swap IDs), Autorize (Burp plugin auto-replays as a lower-priv user), Burp MCP `send_http1_request`.
- Watch for `id`, `*_id`, `uuid`, `slug`, `filename`, `account_id` in responses to map attack surface.

## Fix
Enforce per-object authorization server-side on every read/write; use non-guessable IDs (but don't rely on them — still authorize); centralize access-control checks.
