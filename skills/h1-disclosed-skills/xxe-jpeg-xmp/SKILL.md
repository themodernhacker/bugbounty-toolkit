---
name: xxe-jpeg-xmp
description: XXE through XMP metadata inside a JPEG/photo file. Teaches that EXIF/XMP image metadata is an XML document parsed server-side, making photo upload a blind XXE vector.
sources: hackerone_public
report_count: 1
---

# XXE via JPEG XMP metadata

**Report**: Informatica — "XXE through injection of a payload in the XMP metadata of a JPEG file" (hackerone.com/reports/836877, critical, XXE).

## Why it matters (the new lesson)
XMP metadata (embedded in JPEG/PNG) is a serialized **XML/RDF** block. Photo processing pipelines (EXIF parsers, photo libraries, search indexers) parse it server-side. Inject a DTD into XMP and the image upload becomes a blind XXE — no XML endpoint required.

## How it works
Embed an entity-bearing XMP packet into a JPEG (using exiftool or a hex edit):
```
<x:xmpmeta xmlns:x="adobe:ns:meta/">
  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
      <xmp:CreatorTool><!ENTITY xxe SYSTEM "file:///etc/passwd"></xmp:CreatorTool>
    </rdf:Description>
  </rdf:RDF>
</x:xmpmeta>
```
When the server's XMP parser processes the image, the entity fires.

## How to hunt for it
1. Find photo upload + processing (avatars, galleries, OCR, metadata extraction).
2. Inject an entity referencing a Collaborator URL into XMP/EXIF.
3. Watch OOB DNS/HTTP for the hit → confirms blind XXE; then target `file://`.

## Payloads / tooling
```
exiftool -xmp:all= -xmp='<?xml ... <!DOCTYPE ...>' photo.jpg
exiftool -Comment='<!DOCTYPE ...>' photo.jpg
```

## Fix
Disable external entities in XMP/EXIF parsers; strip metadata before processing; sandbox.
