---
name: path-traversal-to-rce
description: Path traversal chained to RCE — write a file into a web-accessible/executable path. Teaches how a "read/write" path traversal becomes code execution via overwrite of config, hooks, templates, or shell files.
sources: hackerone_public
report_count: 1
---

# Path Traversal → RCE

**Report**: GitLab — "Path traversal, to RCE" (hackerone.com/reports/733072, high, $12,000). Related: Ruby on Rails file-write→RCE via page caching (#519220).

## Why it matters (the new lesson)
Path traversal isn't only "read `/etc/passwd`". If the traversal is in a **write** operation (upload, extract, export, config save), you can drop a file into a path the server later executes: overwrite `.git/hooks`, a template/partial, a plugin, `cron` script, SSH `authorized_keys`, or a webroot PHP/JSP file → RCE.

## How it works
```
PUT /upload/../../.git/hooks/post-receive   (body = malicious script)
```
or overwrite a view/partial that's rendered on the next request, or write `shell.php` into the webroot.

## How to hunt for it
1. Find write operations with a user-controlled destination (filename, path, archive extraction, template name).
2. Inject `../` to escape the sandbox dir.
3. Target executable/auto-loaded locations; verify execution.

## Payloads
```
filename=../../../../var/www/html/shell.php
filename=../../.git/hooks/pre-commit
path=../../../config/settings.yml
archive with path: ../../webroot/x.php
```

## Fix
Resolve and verify the canonical path stays within the intended directory; use server-side filenames (IDs), never user paths; restrict write permissions; don't auto-execute uploaded/extracted content.
