---
name: mobile-pkce-ato
description: PKCE OAuth flow vulnerability in mobile apps leading to account takeover. Teaches attacking the PKCE code-verifier/challenge exchange (missing, predictable, or client-side verifier).
sources: hackerone_public
report_count: 1
---

# PKCE Flow Vulnerability → Account Takeover (mobile)

**Report**: Grammarly Keyboard Android — "PKCE flow vuln → account takeover" (#824931).

## Why it matters (the new lesson)
Mobile OAuth uses PKCE (`code_challenge`/`code_verifier`) instead of a client secret. If the app fails to *actually verify* the verifier (or it's missing/predictable/leaked), an attacker who steals the authorization `code` (via redirect interception) can exchange it → ATO. PKCE is only as strong as the verifier generation + validation.

## How it works
1. App starts OAuth with `code_challenge=hash(code_verifier)`.
2. Attacker intercepts the `code` (intercept redirect_uri, logcat, MITM).
3. If the app doesn't bind/verify `code_verifier` (or it's a constant), attacker exchanges the code.

## How to hunt for it
1. Intercept the app's OAuth flow (Burp/mitmproxy with cert pinning bypass).
2. Check `code_challenge`/`code_verifier`: is the verifier random? Is it re-sent and verified server-side?
3. Try replaying a captured `code` with a *different/no* verifier.
4. Check `redirect_uri` validation for interception.

## Tooling
mitmproxy, Burp, Frida (bypass pinning), apktool.

## Fix
Generate cryptographically random `code_verifier`, require `S256` challenge, verify server-side, bind to `redirect_uri`, single-use codes.
