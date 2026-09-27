---
name: ato-leaked-cookie
description: Account takeover via a session cookie leaked in a shared/third-party request or log. Teaches session-token leak detection (referer, mixed-content, CDN logs, third-party embeds) as an ATO vector.
sources: hackerone_public
report_count: 1
---

# ATO via leaked session cookie

**Report**: HackerOne — "Account takeover via leaked session cookie" (hackerone.com/reports/745324). Related: Yelp XSS keylogger → link Google account (#2010530), ATO via cookie manipulation + XSS (#534450).

## Why it matters (the new lesson)
Cookies leak in subtle ways: in `Referer` headers to third parties, in `document.cookie` read by injected script, in image/analytics requests, in mixed HTTP↔HTTPS transitions, and in URLs (session in query). Find where the session token travels and you find ATO without touching auth logic.

## How it works
1. A page sends the session cookie (or full URL containing it) to a third-party domain via `Referer`, an `<img src>`, a beacon, or a redirect.
2. The third party (or any MitM on mixed content) captures it.
3. Replay the cookie → full account takeover.

## How to hunt for it
1. Browse while watching request logs; identify any request carrying `Cookie` to a non-first-party host or over plain HTTP.
2. Check for `Referrer-Policy` misconfigs leaking full URL (with session) to external links/analytics.
3. Test mixed content (HTTPS page loading HTTP subresource), and session-in-URL (`?sid=`, `?token=`) cases.
4. Look for reflection of cookies in responses/logs.

## Fix
`HttpOnly` + `Secure` + `SameSite` on cookies; `Referrer-Policy: no-referrer` (or strict); HSTS; never put sessions in URLs; scope cookies tightly.
