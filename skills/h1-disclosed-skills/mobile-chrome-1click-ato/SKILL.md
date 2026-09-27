---
name: mobile-chrome-1click-ato
description: One-click account takeover on Android via Chrome's exported ContentProviders (CVE-2019-5765) — reading private data of any app through unprotected intents. Teaches Android intent/content-provider pivots.
sources: hackerone_public
report_count: 1
---

# 1-Click Account Takeover on Android (CVE-2019-5765)

**Report**: Chrome — "CVE-2019-5765: 1-click account takeover on all Android devices" (#563870).

## Why it matters (the new lesson)
Android apps expose `ContentProvider`s that other apps (or a malicious page → intent) can query. If a provider isn't permission-protected, it leaks another app's private data — session tokens, cookies, credentials — enabling cross-app account takeover. This is a *platform-level* class, not app-specific.

## How it works
A malicious app (or deeplink) sends an intent targeting Chrome's provider, reading stored site data/session info without the required permission because the provider lacked `android:permission`.

## How to hunt for it
1. Audit the target's exported `ContentProvider`s (manifest + `drozer`, `adb`).
2. Check for missing `android:permission` / missing `exported=false`.
3. Query providers via `content://` URIs from a test app / `adb shell content query`.
4. Look for stored tokens/cookies/credentials in the responses.

## Tooling
`drozer`, `adb shell content query`, jadx (manifest review), Frida for dynamic tracing.

## Fix
Mark providers `android:exported="false"` or add `android:permission`; validate caller package/UID; don't persist plaintext secrets.
