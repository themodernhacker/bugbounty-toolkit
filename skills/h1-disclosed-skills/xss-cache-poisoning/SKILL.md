---
name: xss-cache-poisoning
description: Turn a reflected XSS into a persistent (stored) XSS by poisoning the shared web cache. Teaches unkeyed-input cache poisoning — the highest-impact XSS variant because the payload is served to every subsequent visitor, not just the attacker's own session.
sources: hackerone_public
report_count: 1
---

# Web Cache Poisoning → Stored XSS

**Report**: PayPal — "Stored XSS on https://paypal.com/signin via cache poisoning" (hackerone.com/reports/488147, high, $18,900, albinowax). See also the Glassdoor cache-poisoning XSS chain (#1424094).

## Why it matters (the new lesson)
Most people hunt *reflected* XSS, which only fires in the victim's own request. If you find input that is (a) reflected and (b) **unkeyed by the cache**, the same response gets cached and replayed to *everyone* who hits that URL afterward. A single request turns a self-XSS into a site-wide persistent XSS.

## How it works
CDNs/caches (Cloudflare, Fastly, Varnish, Akamai) key cache entries on a subset of inputs — typically URL path + query, and `Host`. Anything **not** in the key (a header, a cookie, a query param the origin reflects but the cache ignores, or the URL's fragment) is "unkeyed". If the origin reflects an unkeyed value into the response body, you can prime the cache with your payload, and the poisoned response is served to all later users.

## How to hunt for it
1. Pick an endpoint that returns a `Cache-Control`/`X-Cache`-friendly 200 (static-ish pages, sign-in pages, CDN-served assets, `?lang=`, `?country=`, etc.).
2. For each reflected input, send two requests differing only in that input, and compare headers (`Age`, `X-Cache: HIT`, `Cf-Cache-Status`). If the response is cached, find which inputs are reflected but NOT in the cache key.
3. Inject a canary into an unkeyed reflected input and re-request with a *clean* value — if the canary comes back, you poisoned the cache.

## Reproduction / payloads
```
GET /signin?lang=<script>alert(91337)</script> HTTP/1.1
Host: victim.com
X-Forwarded-Host: evil.com            # often reflected but unkeyed
```
Test unkeyed candidates: `X-Forwarded-Host`, `X-Forwarded-Proto`, `X-Forwarded-Scheme`, `X-Original-URL`, `X-Rewrite-URL`, `Forwarded`, `X-Host`, `Host` override, and query params the origin reflects but doesn't vary the key on.

## Tooling
- Burp Suite: send to Repeater, toggle headers, watch `X-Cache`/`Age`. Use the "Cache key" probe.
- `curl -s -D- -o /dev/null https://target/path -H "X-Forwarded-Host: POISON"` then repeat clean.
- Param Miner (Burp extension) auto-discovers unkeyed inputs.

## Fix
Cache key should include *all* inputs that influence the response; strip/never-reflect routing headers; don't reflect untrusted input in cached responses; set `Vary` correctly.
