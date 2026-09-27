# Supporting Material / References

* Burp Repeater capture of `POST /api/v1/auth/switch-role` -> `HTTP/1.1 200 OK` with `Set-Cookie: __Secure-team-owner-id=VXNlck5vZGU6MTAyNjEwMTQ%3D` (attacker `bugstestbyabhi@gmail.com` adopting top seller `coolkicks`).
* GraphQL `getUser` response resolving `coolkicks` -> `PublicUserNode:10261014` (public username -> ID enumeration; no auth required).
* PoC script `poc.py` (attached) — reproduces ID resolution + unauthorized team-owner switch.
* JS evidence: `/assets/client.*.js` — `fetch("/api/v1/auth/switch-role",...)`; `TEAM_OWNER_ID_COOKIE` -> `__Secure-team-owner-id`; seller GraphQL operations `GetSellerLiveReadiness`, `GetSellerAnalyticsChart`, `GetSellerBreakDetails`, `SetSellerLiveReadinessState`.
* Confirmed result matrix (all `200`, no authorization check): `UserNode:1`, `UserNode:2`, `UserNode:73581719`, `UserNode:10261014` (`coolkicks`), `UserNode:70991864` (`invictaflagship`).
