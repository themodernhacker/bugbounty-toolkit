---
name: dos-cache-poisoning
description: Denial of service via web cache poisoning — poisoning a shared cache entry that serves errors/redirects (or huge responses) to all users. Teaches cache poisoning as a DoS/availability primitive.
sources: hackerone_public
report_count: 2
---

# DoS via Web Cache Poisoning

**Reports**: PayPal — "DoS on PayPal via web cache poisoning" (#622122, $9,700); HackerOne — "Denial of service via cache poisoning" (#409370, $2,500).

## Why it matters (the new lesson)
Cache poisoning isn't just XSS. Poison a popular URL's cached entry with a 4xx/5xx response (or a huge body) via an unkeyed input, and every visitor to that URL receives the poisoned response — a sustained site-wide DoS that survives until the cache purges. The exploit is one request; the impact is mass.

## How it works
```
GET /popular-page?x=1 HTTP/1.1
Host: target.com
X-Forwarded-Host: <unkeyed input that forces an error>
```
The error response gets cached under `/popular-page` → all users get the error.

## How to hunt for it
1. Find cache-hit responses (`X-Cache: hit`) and identify unkeyed inputs (Param Miner / header fuzz).
2. Force an error/redirect/large response via an unkeyed input; confirm it caches under the clean URL.
3. Verify a second request (without the input) returns the poisoned response.

## Payloads
```
X-Forwarded-Host: a"  (malformed → 500)
X-Forwarded-For: 0.0.0.0/8  (blocked → error)
X-Original-URL: /nonexistent  (404)
```

## Fix
Key the cache on all inputs affecting the response; don't cache error responses; sanitize routing headers.
