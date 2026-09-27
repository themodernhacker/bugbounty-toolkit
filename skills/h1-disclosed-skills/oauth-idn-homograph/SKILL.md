---
name: oauth-idn-homograph
description: OAuth redirect_uri bypass using IDN homograph domains to steal authorization codes/tokens. Teaches Unicode normalization flaws in OAuth redirect validation.
sources: hackerone_public
report_count: 1
---

# OAuth redirect_uri bypass via IDN homograph

**Report**: Semrush — "OAuth redirect_uri bypass using IDN homograph to get access token" (hackerone.com/reports/861940). Related: stealing OAuth code via redirect_uri (pixiv #1861974), GSA #665651.

## Why it matters (the new lesson)
OAuth servers validate `redirect_uri` against a whitelist. Unicode normalization mismatches (IDN homographs, `％`/full-width chars, dot/hostname tricks) let an attacker register/own a look-alike domain and receive the `code`/token. This is a subtle, high-value class separate from the classic open-redirect-in-redirect_uri.

## How it works
`https://example.com` vs `https://exаmple.com` (Cyrillic 'а'). The OAuth provider normalizes/puny-codes inconsistently, so a homograph of an allowed domain passes validation, and the authorization code is sent to the attacker's domain.

## How to hunt for it
1. Register an OAuth app / trigger a login flow and capture the `redirect_uri` handling.
2. Enumerate allowed redirect URIs (client registration, leaked config).
3. Try Unicode variants: homograph letters, full-width characters, `\u3002` dots, `\uFF0F` slashes, trailing dot, extra dot segments, `@`, `%2f`.
4. Confirm the `code`/token is delivered to the crafted host.

## Payloads
```
https://exаmple.com        # Cyrillic а (U+0430) homograph
https://example.com。evil.com   # U+3002 dot
https://example.com%2f%2fevil.com
https://example.com@evil.com
https://example.com.evil.com
```

## Fix
Strict exact-match after normalization + punycode; register/whitelist exact ASCII+punycode domains; reject any non-ASCII in hostname.
