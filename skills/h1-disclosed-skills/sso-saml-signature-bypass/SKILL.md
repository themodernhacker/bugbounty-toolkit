---
name: sso-saml-signature-bypass
description: SAML signature verification bypass to log in as any user. Teaches SAML assertion tampering, signature-stripping, and common verification bugs (none found / not checked / wrong element).
sources: hackerone_public
report_count: 1
---

# SAML Signature Verification Bypass

**Report**: GitHub — "SAML Signature verification bypass allows logging into any user" (#2579939). Related: HackerOne #888930 (SAML response reuse).

## Why it matters (the new lesson)
SSO trust is anchored on verifying the IdP's signature on the SAML assertion. If the SP's verification is flawed (signature not checked when `Response` vs `Assertion` is signed, `None` algorithm accepted, signature stripped, comment/whitespace tricks, or duplicate `Assertion` where the signed one is dropped), an attacker can forge `NameID`/attributes → log in as anyone.

## How it works
1. Intercept a SAML response; modify `NameID`/attributes to the victim.
2. Strip or relocate the signature (or use `signatureMethod Algorithm="None"`).
3. Replay; the SP accepts because verification is bypassed.

## How to hunt for it
1. Capture a SAML response; identify what's signed (`Response` vs `Assertion`).
2. Tamper `NameID`/`uid`/`email`; strip/alter signature; test acceptance.
3. Try `Algorithm="None"`, comment injection, XML signature wrapping.

## Payloads / tools
`saml-raider` (Burp), `SAMLReQuest`/`SAMLResponse` decode+re-encode; `XML Signature Wrapping`.

## Fix
Verify the signature on the *assertion* the app consumes, enforce strong algorithms, reject unsigned/`None`, validate `InResponseTo`/`Audience`/`Recipient`, pin IdP cert.
