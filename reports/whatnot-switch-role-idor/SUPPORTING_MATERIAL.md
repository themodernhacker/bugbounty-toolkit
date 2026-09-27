# Supporting Material / References

* `Step1.png` — Burp Repeater **request** pane: `POST /api/v1/auth/switch-role` carrying the attacker's own cookie (`bugstestbyabhi@gmail.com`, `sub=73582060`) and the victim `id=VXNlck5vZGU6MTAyNjEwMTQ=` (`coolkicks`). Proves the attacker is authenticated as themselves while targeting the victim.
* `Step2.png` — Burp Repeater **response** pane: `HTTP/2 200 OK` with `Set-Cookie: __Secure-team-owner-id=VXNlck5vZGU6MTAyNjEwMTQ%3D; Max-Age=31536000000; Secure; HttpOnly; SameSite=lax`. Proves the server accepted the switch with no authorization check (no 403/error).
* GraphQL `getUser` response resolving `coolkicks` -> `PublicUserNode:10261014` (public username -> ID enumeration; no auth required).
* PoC script `poc.py` (attached) — reproduces ID resolution + unauthorized team-owner switch.
* JS evidence: `/assets/client.*.js` — `fetch("/api/v1/auth/switch-role",...)`; `TEAM_OWNER_ID_COOKIE` -> `__Secure-team-owner-id`; seller GraphQL operations `GetSellerLiveReadiness`, `GetSellerAnalyticsChart`, `GetSellerBreakDetails`, `SetSellerLiveReadinessState`.
* Confirmed result matrix (all `200`, no authorization check): `UserNode:1`, `UserNode:2`, `UserNode:73581719`, `UserNode:10261014` (`coolkicks`), `UserNode:70991864` (`invictaflagship`).
