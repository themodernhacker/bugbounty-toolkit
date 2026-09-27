---
name: mobile-biometric-2fa-bypass
description: Bypassing biometric auth / 2FA in mobile apps via client-side logic (returning true, toggling flags, stale sessions). Teaches Frida/hooking to defeat local auth controls.
sources: hackerone_public
report_count: 2
---

# Biometric / 2FA Bypass in Mobile Apps

**Reports**: Shopify — "Bypass biometrics in Android app (com.shopify.mobile)" (#637194, $500); TikTok — "Bypass 2FA in Android apps and web" (#1747978).

## Why it matters (the new lesson)
Biometric/2FA checks implemented *only client-side* can be bypassed by hooking the method that returns "success" (or toggling the flag). If the server trusts the app's word ("biometric verified") without a server-side proof, local bypass = full bypass. This is a repeatable mobile-audit finding.

## How it works
```js
// Frida: force the biometric callback to return true
Java.perform(() => {
  const Auth = Java.use('com.app.AuthManager');
  Auth.isBiometricValid.implementation = () => true;
});
```

## How to hunt for it
1. Identify auth gates (biometric prompt, 2FA step) in the app.
2. Hook the verification method with Frida; return success.
3. Confirm the protected action now completes.
4. Check whether the server independently validates the auth (a good sign is a server-issued token after auth).

## Tooling
Frida, Objection, apktool/jadx (find the method), Burp.

## Fix
Perform auth verification server-side; don't trust client boolean flags; issue short-lived server tokens only after server-side proof.
