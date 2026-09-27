---
name: csrf-graphql-get
description: CSRF by executing GraphQL mutations over GET requests. Teaches that GraphQL endpoints accepting mutations via GET (or ignoring HTTP method) are CSRF-able and how to craft the exploit.
sources: hackerone_public
report_count: 1
---

# CSRF via GraphQL mutations over GET

**Report**: GitLab — "CSRF on /api/graphql allows executing mutations through GET requests" (hackerone.com/reports/1122408, high, $3,370, CSRF).

## Why it matters (the new lesson)
Many GraphQL servers accept queries over both POST and GET. If a *mutation* can be sent as a GET with the query in the URL (or the server doesn't enforce POST-only for mutations), an attacker can trigger it via `<img>`/auto-submitted form — classic CSRF. Developers often assume "GraphQL = safe from CSRF", which is wrong.

## How it works
```html
<img src="https://target/api/graphql?query=mutation{...}&variables=...">
```
Or a GET endpoint that reads the operation from query params and executes it regardless of method.

## How to hunt for it
1. Find `/graphql` / `/api/graphql`; confirm it accepts GET.
2. Take a state-changing mutation (delete, update settings, add collaborator) and issue it as GET with query+variables in the URL.
3. Confirm it executes without a CSRF token / custom header.

## Payload
```
GET /api/graphql?query=mutation{deleteProject(input:{id:"x"})}&variables={} HTTP/1.1
```

## Fix
Require POST for mutations; require a CSRF token or custom header (`X-Requested-With`) on state-changing operations; enforce `Content-Type: application/json` (triggers CORS preflight).
