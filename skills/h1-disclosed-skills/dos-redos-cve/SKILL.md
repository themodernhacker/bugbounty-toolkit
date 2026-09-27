---
name: dos-redos-cve
description: ReDoS and algorithmic-complexity DoS via regex/URL parsing (CVE-2024-41990 in django.utils.html.urlize). Teaches finding catastrophic backtracking and O(n^2) parsing DoS.
sources: hackerone_public
report_count: 1
---

# ReDoS / Algorithmic-Complexity DoS (CVE-2024-41990)

**Report**: Internet Bug Bounty — "CVE-2024-41990: DoS in django.utils.html.urlize()" (#2795558, $2,162).

## Why it matters (the new lesson)
A single crafted string can make a regex with nested quantifiers (or a URL/HTML parser) backtrack exponentially, pinning a CPU core and taking the app down. You don't need a botnet — one request. Input-sanitization functions (`urlize`, `markdown`, linkify) are common sinks.

## How it works
`urlize()` turns URLs into links; its regex had a catastrophic-backtracking pattern. A long string of chars that almost-match the pattern (e.g. many `<` without `>`) causes exponential backtracking.

## How to hunt for it
1. Find input fed to regex/parsers (linkify, markdown, validation, search).
2. Send strings designed to trigger backtracking: `"a"*N + "<"*N`, `("a")*N + "!"`.
3. Measure response time vs input size — superlinear growth = ReDoS.

## Payloads
```
<a href=" + "a"*100000  (urlize/autolink)
"(" * 10000 + "x"       (many validators)
```

## Tooling
`rxxr2`/`RegexStaticAnalysis`/`frida`; time-based measurement in Burp.

## Fix
Use RE2/re2j (linear-time) engines; rewrite risky regexes; impose input-length limits; timeouts on parsers.
