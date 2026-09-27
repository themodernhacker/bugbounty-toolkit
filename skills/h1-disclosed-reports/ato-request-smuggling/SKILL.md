---
name: ato-request-smuggling
description: Mass account takeover by using HTTP Request Smuggling to steal other users' session cookies off a shared reverse proxy. Teaches the smuggling-to-session-theft chain (the highest-impact HRS outcome).
sources: hackerone_public
report_count: 1
---

# Mass ATO via HTTP Request Smuggling (session theft)

**Report**: Slack — "Mass Account Takeovers using HTTP Request Smuggling on https://slackb.com to steal session cookies" (hackerone.com/reports/737140). Also LINE admin (#740037), Zomato token theft (#771666), New Relic password theft (#498052).

## Why it matters (the new lesson)
Request smuggling turns a front-end/back-end parsing mismatch into the ability to **prepend your request to the next victim's request** on the same connection. If the smuggled request captures/redirects a cookie or the victim's request gets your crafted body, you steal sessions at scale — a single CL:TE/TE:CL desync becomes mass ATO.

## How it works
```http
POST / HTTP/1.1
Host: target.com
Content-Length: 49
Transfer-Encoding: chunked

0

GET / HTTP/1.1
Host: target.com
X-Evil: 
```
The front-end uses TE, the back-end uses CL (or vice-versa); the leftover bytes are treated as the start of the *next* request, letting you poison responses/cookies for the following user.

## How to hunt for it
1. Enumerate CL:TE and TE:CL desyncs (send ambiguous requests, observe timeouts/differences).
2. Confirm with a smuggled request that triggers a visible effect (e.g. a 2nd request to a different host that 404s).
3. Escalate: smuggle a request that reflects a victim's request (`POST /` with a body that echoes the next request) or redirects cookie-bearing requests to your host.

## Tooling
- Burp HTTP Request Smuggler (extension), `smuggler.py` (defparam), `http2smugl`.
- Burp MCP `send_http2_request` for HTTP/2 smuggling.

## Fix
Reject ambiguous requests; disable TE where unused; ensure front-end and back-end parse identically; enable HTTP/2 end-to-end.
