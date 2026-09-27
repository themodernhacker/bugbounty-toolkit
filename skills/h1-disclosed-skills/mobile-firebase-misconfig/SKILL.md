---
name: mobile-firebase-misconfig
description: Exposed Firebase (RTDB/Firestore/Storage) takeover via misconfigured security rules. Teaches finding and abusing open Firebase instances referenced by mobile/web apps.
sources: hackerone_public
report_count: 1
---

# Firebase Database / Storage Misconfiguration → takeover

**Report**: "Firebase Database takeover in Zego Sense Android" (#1065134).

## Why it matters (the new lesson)
Apps embed a Firebase project name/API key; if the Realtime Database / Firestore / Storage rules are `.read/.write: true`, anyone with the project URL can read/write the entire database — mass PII and write-injection (defacing, privilege escalation by editing user records). Extremely common in mobile targets.

## How it works
```
https://<PROJECT>.firebaseio.com/.json           # RTDB read
https://<PROJECT>.firebaseio.com/users.json?auth=  # write
```
If rules are open, a plain GET dumps data; a PUT injects records.

## How to hunt for it
1. Extract the Firebase URL/API key from the app (strings, `google-services.json`, network traffic).
2. `GET /.json` — if it returns data without auth, it's open.
3. Try `PUT`/`POST` to write a canary node.
4. Also check Firestore (`https://firestore.googleapis.com/...`) and Storage.

## Tooling
`firebase` CLI, `firebase-database-urls` wordlists, nuclei `exposed-firebase` templates.

## Fix
Deny-by-default rules (`read/write: false`), authenticate + per-user rules, never ship service-account keys.
