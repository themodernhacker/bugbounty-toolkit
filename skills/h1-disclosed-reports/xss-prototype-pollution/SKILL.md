---
name: xss-prototype-pollution
description: Prototype pollution leading to XSS — poisoning Object.prototype via URL fragment/JSON merge, then hitting a gadget sink. Teaches prototype pollution as a client-side XSS vector and gadget discovery.
sources: hackerone_public
report_count: 1
---

# Prototype Pollution → XSS

**Report**: Elastic (Swiftype) — "Prototype Pollution leads to XSS on https://blog.swiftype.com/#__proto__[x]=..." (hackerone.com/reports/998398, high, DOM XSS).

## Why it matters (the new lesson)
Client-side prototype pollution (`__proto__`, `constructor.prototype`) lets you redefine properties on `Object.prototype`, which then "magically" appear on every object. When a sink reads a polluted property (e.g. a config flag, a template variable, `innerHTML` builder options), you get XSS — even with no direct reflection of your input into a dangerous sink.

## How it works
```js
// vulnerable deep-merge/assignment with a __proto__ key
merge({}, JSON.parse(location.hash.slice(1)));
// now Object.prototype.isAdmin = true, or Object.prototype.someOption = "<img onerror=...>"
```
Polluting a property that a rendering function later uses:
```
https://target/#__proto__[innerHTML]=<img src=x onerror=alert(1)>
```

## How to hunt for it
1. Find JS that merges/assigns URL params or JSON into objects (deep-merge, `Object.assign`, `_.merge`, `$.extend(true,...)`).
2. Inject `__proto__` / `constructor.prototype` keys and check `Object.prototype` is polluted (DevTools console).
3. Discover gadgets: grep the codebase for reads of properties that, if set, reach a sink. Use tools like `pp-finder` / `DOMInvader` (Burp).

## Payloads
```
?__proto__[x]=y
?constructor[prototype][polluted]=<img/src/onerror=alert(1)>
#__proto__[srcdoc]=<script>alert(1)</script>
```

## Fix
Block `__proto__`/`constructor`/`prototype` keys in merges; use `Object.freeze(Object.prototype)` / `Object.create(null)`; avoid deep-merge of untrusted JSON.
