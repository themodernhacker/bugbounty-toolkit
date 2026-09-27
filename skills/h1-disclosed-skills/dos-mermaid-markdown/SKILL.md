---
name: dos-mermaid-markdown
description: DoS (and potential RCE) via Mermaid diagram rendering in markdown/issues. Teaches abusing server-side diagram/markdown renderers with malicious syntax.
sources: hackerone_public
report_count: 1
---

# DoS via Mermaid Diagram Rendering

**Report**: GitLab — "DoS on Issue page exploiting Mermaid" (#470067, $3,000).

## Why it matters (the new lesson)
Markdown renderers that support diagrams (Mermaid, Kroki, Graphviz) run a parser/interpreter server-side. Malicious diagram syntax (huge graphs, deep nesting, `classDef` loops, `style` directives, links to huge resources) can hang the parser → DoS for everyone viewing the issue. Some renderers also expose XSS/RCE via `click` handlers and `javascript:` URLs.

## How it works
```mermaid
graph TD
  A-->A
  ... (deeply nested / cyclic graph)
```
Or Mermaid XSS (older versions): ```` ```mermaid ... click A "javascript:alert(1)" ``` ````.

## How to hunt for it
1. Find issue/comment/README markdown that renders Mermaid/Kroki/Graphviz.
2. Inject pathological diagrams; observe render time / server errors.
3. Try `click`/`style` handlers for XSS; test `javascript:` URLs.

## Payloads
```
graph TD; A[<img src=x onerror=alert(1)>]
click A href "javascript:alert(document.domain)"
```

## Fix
Sandbox the renderer; enforce size/time limits; disable `click`/`javascript:` handlers; render diagrams client-side.
