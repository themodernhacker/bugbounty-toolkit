---
name: xss-postmessage-dom
description: DOM XSS through window.postMessage handlers that don't validate message origin, then sink user data into innerHTML/eval/location. Teaches the postMessage source-to-sink tracing method — a huge class of client-side bugs most scanners miss.
sources: hackerone_public
report_count: 1
---

# DOM XSS via postMessage (origin not validated)

**Report**: HackerOne — "DOM Based XSS in www.hackerone.com via PostMessage" (hackerone.com/reports/398054, high, $500). Also the Reddit response-type-switch chain (#1567186) abuses a related flow.

## Why it matters (the new lesson)
Dynamic web apps pass data between frames/windows with `postMessage`. If the receiving handler reads `event.data` and writes it into a sink (`.innerHTML`, `eval`, `document.write`, `location`) **without checking `event.origin`**, any site the victim opens can frame the target and send a malicious message — triggering XSS without any reflection in the HTTP response.

## How it works
```js
window.addEventListener('message', function(e){
  // MISSING: if (e.origin !== 'https://trusted.com') return;
  document.getElementById('x').innerHTML = e.data.name;   // sink
});
```
Attacker page:
```js
var w = window.open('https://target.com/page');
setTimeout(function(){ w.postMessage({name:'<img src=x onerror=alert(1)>'}, '*'); }, 2000);
```

## How to hunt for it
1. Grep JS for `addEventListener('message'`, `.onmessage`, `postMessage(`.
2. For each listener, check whether `event.origin` / `event.source` is validated.
3. Trace `event.data` into a sink (innerHTML, insertAdjacentHTML, eval, new Function, document.write, location, href, `$()`/jQuery html()).
4. If no origin check + dangerous sink → exploit with `postMessage(payload, '*')`.

## Tooling
- DevTools → Sources → global search "postMessage" / "onmessage".
- Burp + manual; `semgrep`/`eslint` rules; grep with `gf`-style patterns.

## Fix
Always verify `event.origin` against an allowlist and validate/whitelist the shape of `event.data` before using it.
