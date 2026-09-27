---
name: cache-poisoning-stored-xss
description: Web cache poisoning leading to stored XSS and DoS via unkeyed header/query reflection. Complements xss-cache-poisoning with a second real-world chain and DoS angle.
sources: hackerone_public
report_count: 1
---

# Web Cache Poisoning → Stored XSS / DoS

**Report**: Glassdoor — "Web Cache Poisoning → Stored XSS" (hackerone.com/reports/1424094) and "→ XSS and DoS" (#1621540). Also PayPal DoS (#622122), GSA catalog defacement (#303730).

## Why it matters (the new lesson)
Beyond XSS, cache poisoning can cause **DoS** (cache a 4xx/5xx or a resource-hungry response for everyone) and **defacement** (poison a JS/CSS asset served to all visitors). The same unkeyed-input primitive has multiple severities — always check the full blast radius.

## How it works
An unkeyed header (e.g. `X-Forwarded-Host`) or query is reflected into a cached response. Poisoning with HTML/JS → stored XSS; poisoning with a redirect/error → DoS; poisoning an asset URL → defacement.

## How to hunt for it
1. Identify cached endpoints (see xss-cache-poisoning skill).
2. Inject into unkeyed inputs and observe what's reflected: body, `Location`, asset links, CSP.
3. Re-request clean to confirm the cache is poisoned, then escalate to XSS/DoS/defacement.

## Payloads
```
X-Forwarded-Host: "><script>alert(1)</script>
X-Forwarded-Scheme: nothttps   # force http links / mixed content
?cb=1337                        # cache-bust a path then poison
```

## Fix
Key cache on all reflected inputs; strip routing headers; don't reflect untrusted data in cached responses.
