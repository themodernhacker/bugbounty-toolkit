---
name: sso-xml-signature-wrapping
description: SAML authentication bypass via XML Signature Wrapping (XSW) — moving the signed element while injecting an unsigned attacker-controlled sibling. Teaches the XSW technique family.
sources: hackerone_public
report_count: 1
---

# SAML Auth Bypass via XML Signature Wrapping (XSW)

**Report**: Rocket.Chat — "Authentication Bypass via XML Signature Wrapping in SAML SSO" (#3827674). Related: Rocket.Chat #812064.

## Why it matters (the new lesson)
XML signature wrapping exploits the gap between the element the app *verifies* and the element it *consumes*. The signature over the original element stays valid, but the app's parser reads a *different* (attacker-injected) element — so verification passes while the consumed identity is attacker-controlled. This is a whole family (XSW1–XSW8) that repeatedly defeats naive SAML validators.

## How it works
```xml
<Assertion>
  <Signature>...</Signature>          <!-- verifies fine -->
  <Subject><NameID>attacker</NameID></Subject>   <!-- app reads THIS -->
</Assertion>
<Assertion>
  <Subject><NameID>victim-admin</NameID></Subject>  <!-- signed, ignored -->
</Assertion>
```
App verifies one `Assertion` but consumes the injected unsigned sibling.

## How to hunt for it
1. Capture SAML; identify the consumed assertion + signature location.
2. Inject a duplicate `Assertion`/`Subject`/`NameID` and shuffle order.
3. Test XSW variants (prefix/namespace tricks, `ID` relocation).

## Payloads / tools
`saml-raider` (Burp) XSW templates; `XmlSignatureWrapping` scripts.

## Fix
Consume exactly the element that was signature-verified (same node reference); use hardened SAML libraries; reject duplicate elements.
