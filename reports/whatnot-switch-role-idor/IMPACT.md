# Impact

## What an attacker can do

Any registered user — including a brand-new, free, non-seller account — can call
`POST /api/v1/auth/switch-role` with the base64 GraphQL global ID of **any other
user** and have the server set their `__Secure-team-owner-id` cookie to that user's
ID. No check verifies the caller belongs to (or is authorized to act for) the target
user's team. The cookie is the application's "acting team-owner" context, which the
backend consumes to scope seller- and team-level operations.

In practice this means a low-privileged attacker can impersonate **top sellers**
(such as `coolkicks`, the platform's #1 seller, or `invictaflagship`) and act within
their team-owner context.

## Concrete business impact

- **Seller account impersonation / takeover.** The attacker's account adopts the
  seller's team-owner context, gaining access to seller-scoped operations:
  - `GetSellerLiveReadiness`, `GetSellerAnalyticsChart`, `GetSellerBreakDetails` —
    live-readiness, analytics, and break/schedule data.
  - Payout and order listing (`GetSellerCommissionSource`, payout verification state).
  - Team management (member administration for the seller's team).
  - The `SetSellerLiveReadinessState` mutation — the attacker can change a seller's
    live-readiness state, directly disrupting that seller's ability to stream/sell.
- **Financial data exposure.** Seller commission and payout information is exposed to
  an attacker with no legitimate relationship to the seller.
- **Reputational and operational harm to sellers.** An attacker changing a top
  seller's readiness state or team configuration can interrupt their live auctions
  and revenue, eroding trust in the platform.
- **Scale.** User IDs are sequential and publicly resolvable (username → numeric ID
  via the public GraphQL `getUser` query), so an attacker can enumerate and target
  **every** seller on the platform — no brute-forcing, phishing, or special access
  required.

## Why this is High severity (not lower)

- **Low privilege required:** any authenticated account (free sign-up).
- **No user interaction:** a single crafted request per target.
- **High confidentiality + integrity impact:** exposure of seller financial data and
  the ability to modify seller state.
- **Broad blast radius:** every seller is reachable via sequential ID enumeration.

CVSS 3.1: **8.1** — `AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N`

## Exploitation prerequisites (minimal)

1. A free Whatnot account (attacker's own, no seller status).
2. The victim's numeric user ID (publicly resolvable).
3. One `POST /api/v1/auth/switch-role` request per target.

No seller approval, no team invitation, and no victim interaction are needed.
