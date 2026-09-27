---
name: xss-config-injection
description: Reflected XSS by injecting into application configuration/state via an unvalidated query parameter that the SPA trusts. Teaches client-side config/state injection — a source class that yields XSS even when normal template sinks are escaped.
sources: hackerone_public
report_count: 1
---

# XSS via client-side config/state override

**Report**: Superhuman (Grammarly) — "Config override using non-validated query parameter allows at least reflected XSS by injecting configuration into state" (hackerone.com/reports/1082847, high).

## Why it matters (the new lesson)
SPAs sometimes bootstrap from query parameters or URL segments that get merged into a JS config/state object (`?theme=`, `?lang=`, `?redirect=`, debug flags). If that config object is later rendered or `eval`'d, you get XSS through a channel that isn't a normal template sink — scanners and manual testers miss it.

## How it works
```js
const cfg = { ...defaultConfig, ...parseQuery(location.search) };  // attacker keys merged
somewhere.innerHTML = cfg.welcomeMessage;                           // or eval(cfg.fn)
```
Attacker: `https://target/?welcomeMessage=<img src=x onerror=alert(1)>` — the value flows from query → state → sink.

## How to hunt for it
1. Look for JS that reads `location.search`/`location.hash` into an object (spread/merge).
2. Identify any merged value that reaches a DOM/eval sink.
3. Enumerate accepted config keys (from JS source) and inject HTML/JS into each.

## Payloads
```
?redirect=javascript:alert(1)
?theme="><img src=x onerror=alert(1)>
?config=<script>alert(1)</script>
```

## Fix
Whitelist config keys; never merge raw URL params into trusted config; escape at sink; strict CSP.
