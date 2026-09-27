---
name: mobile-hardcoded-secrets
description: Hardcoded API keys/secrets in mobile apps (Cloudinary, AWS, third-party) → data disclosure or cloud takeover. Teaches extracting and validating secrets from APK/IPA binaries.
sources: hackerone_public
report_count: 2
---

# Hardcoded Secrets in Mobile Apps

**Reports**: Reverb — "Disclosure of all uploads to Cloudinary via hardcoded API secret in Android app" (#351555); Zenly — "Insecure storage & overly permissive API keys in Android app" (#753868, $750).

## Why it matters (the new lesson)
Mobile apps ship secrets in the binary (API keys, Cloudinary `api_secret`, AWS tokens, map keys). An attacker extracts them statically — no runtime instrumentation needed — and abuses the third-party account directly (list/delete all uploads, incur charges). This is one of the fastest recon wins on mobile targets.

## How it works
Decompile APK/IPA, grep for key patterns:
```
strings app.apk | grep -iE "api_key|secret|AKIA|AIza|sk_live|cloudinary|BEGIN"
grep -r "cloudinary" --include=*.smali --include=*.xml .
```

## How to hunt for it
1. `apktool d app.apk` / `jadx` / `dex2jar`.
2. Grep for secrets; note context (which service).
3. Validate each key (KeyHacks, `aws sts get-caller-identity`, provider APIs).
4. Demonstrate impact (read/delete Cloudinary assets, S3 buckets).

## Tooling
jadx, apktool, `apkleaks`, trufflehog, KeyHacks, MobSF (static analyzer).

## Fix
Don't embed secrets; use short-lived tokens issued by a backend; proxy third-party calls server-side; rotate exposed keys.
