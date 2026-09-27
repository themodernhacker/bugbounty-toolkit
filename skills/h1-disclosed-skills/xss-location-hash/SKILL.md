---
name: xss-location-hash
description: Reflected/DOM XSS where the vulnerable parameter is read from the URL fragment (location.hash), which is never sent to the server — so server-side filters and WAFs can't see it. Teaches hash-based XSS and why it bypasses WAF.
sources: hackerone_public
report_count: 1
---

# XSS via a vulnerable parameter in the location hash

**Report**: Slack — "XSS vulnerable parameter in a location hash" (hackerone.com/reports/146336, high). Reflected XSS in TikTok endpoints (#1350887) and the Superhuman config-override XSS (#1082847) are related.

## Why it matters (the new lesson)
The URL fragment (`#...`) is **not sent to the server**. If a page reads `location.hash` and writes it into the DOM, the XSS is invisible to server-side WAFs and input filters — and it never shows up in HTTP logs. This is why "reflected" XSS in the fragment is really DOM XSS.

## How it works
```js
// page.js
var q = decodeURIComponent(location.hash.slice(1)); // e.g. #/xss/<img onerror>
$('#content').html(q);                              // sink
```
The value comes from the client, is reflected client-side, and never transits the server.

## How to hunt for it
1. Find JS that references `location.hash`, `location.href`, `location.search`.
2. Trace into `.html()`, `.innerHTML`, `eval`, `document.write`.
3. Confirm the fragment is not sanitized and that `document.domain`/CSP doesn't block it.
4. Test with a canary: `https://target/path#<img src=x onerror=alert(91337)>`.

## Payloads
```
#"><img src=x onerror=alert(document.domain)>
#<script>alert(document.domain)</script>
#javascript:alert(document.domain)   (if passed to location/href)
```

## Fix
Never write `location.hash`/`location`-derived data into DOM sinks; use `textContent` or sanitize; set a strict CSP.
