---
name: rce-markup-options
description: RCE via unsafe inline options passed to a markup renderer (Kramdown/Markdown) in wiki pages. Teaches how template-option injection into parser/renderer libraries becomes code execution.
sources: hackerone_public
report_count: 1
---

# RCE via unsafe inline Markdown renderer options

**Report**: GitLab — "RCE via unsafe inline Kramdown options in Wiki pages" (hackerone.com/reports/1125425). Also "RCE on Basecamp.com" (#365271) via template rendering.

## Why it matters (the new lesson)
Markup parsers (Kramdown, AsciiDoc, Jinja/Smarty, Liquid) accept per-block options. If untrusted content can supply options that name a renderer/template/helper or a `template`/`include` path, it escalates to file read or RCE — even when the surrounding app is "just rendering markdown".

## How it works
Kramdown allows inline attribute lists that can pass options to the renderer. Certain options (e.g. a custom `template` option or a `syntax_highlighter`/`format`) let the attacker point at an arbitrary file or invoke code. GitLab's wiki rendered these without a safe-options allowlist → RCE.

## How to hunt for it
1. Find markdown/asciidoc/wiki/README renderers.
2. Fuzz inline attribute/option syntax for the specific parser.
3. Try option names that load templates, filters, includes, or custom renderers.

## Payloads (illustrative)
```
{:options => "template=/etc/passwd"}
{::options template="..." /}
@@... with custom option ...
```

## Fix
Render untrusted markup with a strict option allowlist; disable custom template/include options; sandbox the renderer.
