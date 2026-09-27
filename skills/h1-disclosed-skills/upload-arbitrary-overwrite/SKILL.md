---
name: upload-arbitrary-overwrite
description: Avatar/upload filename traversal → arbitrary file overwrite. Teaches using uploads to overwrite server files (config, `.htaccess`, hooks) and escalate to RCE.
sources: hackerone_public
report_count: 1
---

# Avatar Upload → Arbitrary File Overwrite

**Report**: Mail.ru — "Avatar upload allows arbitrary file overwriting" (#671605, $750).

## Why it matters (the new lesson)
Uploads are writes. If the filename/path is user-influenced, `filename=../../.htaccess` or `../../config.php` overwrites server files. Overwriting `.htaccess` (to enable PHP in the upload dir) or a hook/template is a clean upload→RCE path — the file-content side of path traversal.

## How it works
```
filename=../../.htaccess   body: AddType application/x-httpd-php .jpg
filename=../../../config/settings.php  body: attacker config
```
Then upload `shell.jpg` (now executed as PHP) in the upload dir.

## How to hunt for it
1. Upload with `filename` containing `../`; check if the file lands outside the upload dir.
2. Target `.htaccess` (Apache), `web.config` (IIS), `*.html` templates, `.git/hooks`.
3. Verify by reading the overwritten path / executing a follow-up.

## Payloads
```
filename=../../.htaccess
filename=..%2f..%2f.htaccess
filename=../../web.config
```

## Fix
Use server-generated filenames; strip all path components (`basename`); write into a non-webroot dir with no overwrite rights.
