---
name: mobile-deeplink-abuse
description: Android/iOS deep link (custom URL scheme) abuse — host validation bypass, deeplink CSRF, and scheme takeover. Teaches exploiting exported components and custom schemes to trigger privileged actions or steal data.
sources: hackerone_public
report_count: 2
---

# Mobile Deep Link (custom URL scheme) Abuse

**Reports**: "Bypass host validations in Android apps" (#431002); "Periscope Android deeplink leads to CSRF in follow action" (#583987, $1,540).

## Why it matters (the new lesson)
Mobile apps register custom URL schemes (`myapp://...`, `twitter://...`). If an exported Activity/Handler is reachable via a deeplink and doesn't validate its host/path/parameters, an attacker can invoke privileged actions (follow a user, transfer, change settings) from a malicious web page or another app — the mobile equivalent of CSRF + open redirect combined.

## How it works
```xml
<!-- AndroidManifest exported activity with intent-filter -->
<intent-filter>
  <action android:name="android.intent.action.VIEW"/>
  <data android:scheme="myapp" android:host="follow"/>
</intent-filter>
```
Attacker loads `myapp://follow?user=attacker` via a page → the app follows/re-routes without user consent (if host/params aren't validated).

## How to hunt for it
1. Decompile the app (jadx/apktool); read AndroidManifest for exported components + intent-filters.
2. Map every custom scheme + host + path; find ones that trigger state changes.
3. Test host/param validation bypasses (subdomain, `@`, encoding, trailing chars).
4. For iOS, check `Info.plist` URL types + `application:openURL:` handlers.

## Payloads
```
myapp://follow?user=attacker
myapp://deep/path?next=evil
myapp://host.evil.com/...   (host bypass)
```

## Fix
Validate scheme+host+path strictly; require user gesture for privileged actions; don't export components unnecessarily.
