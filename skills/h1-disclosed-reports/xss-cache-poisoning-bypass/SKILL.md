---
name: xss-cache-poisoning-bypass
description: Bypass of a prior cache-poisoning/XSS fix — re-testing unkeyed inputs after a patch to re-enable stored XSS. Teaches that remediation is often incomplete and how to systematically re-audit patched endpoints.
sources: hackerone_public
report_count: 1
---

# Cache Poisoning Fix Bypass → stored XSS (again)

**Report**: PayPal — "Bypass for #488147 enables stored XSS on https://paypal.com/signin" (hackerone.com/reports/510152, high, $20,000).

## Why it matters (the new lesson)
After a company "fixes" your bug, the patch often covers only *your exact* input. There are usually many other unkeyed inputs (headers, query params, path segments) that still poison the cache. **Re-testing a fixed bug is one of the highest-ROI activities** — you already know the vulnerable logic; now find the sibling input the fix missed.

## How it works
1. Original #488147: an unkeyed input on `/signin` was reflected and cached → stored XSS.
2. Fix: that specific input was keyed/stripped.
3. Bypass: a *different* unkeyed header/param (or a variant: case, encoding, `X-Forwarded-*`) still reaches the reflection and cache → same stored XSS.

## How to hunt for it
1. Read the public fix / retest your old payloads.
2. Enumerate ALL inputs on the patched endpoint (Param Miner, manual header list).
3. For each, check unkeyed + reflected + cached, then inject.
4. Try variants: `X-Forwarded-Host`, `X-Host`, `Forwarded`, `X-Original-URL`, `X-Rewrite-URL`, `Host` override, query params with `;`/`.`/encoded separators.

## Payloads
```
GET /signin HTTP/1.1
Host: victim.com
X-Forwarded-Host: "><script>alert(document.domain)</script>
X-Original-URL: /signin?<svg onload=alert(1)>
```

## Fix
Cache key on ALL request inputs that affect output; normalize/allowlist; don't reflect routing headers; re-verify after every patch.
