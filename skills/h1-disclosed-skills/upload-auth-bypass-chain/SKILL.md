---
name: upload-auth-bypass-chain
description: Chaining an auth bypass (blocking redirect via path confusion) with a malicious upload to reach RCE. Teaches the "blocked redirect → bypass auth" path-confusion trick and chaining bugs.
sources: hackerone_public
report_count: 1
---

# Auth Bypass (blocked redirect) + Malicious Upload → RCE

**Report**: Mail.ru — "RCE by bypassing auth via redirect stop in /admin/* + malicious file upload" (#683957). Related: Razer #736273 (blocking redirect → sensitive data).

## Why it matters (the new lesson)
Reverse proxies / auth middleware protect paths like `/admin/*` by redirecting unauthenticated users. If you can make the *backend* see the protected path while the *proxy* sees a different one (path confusion: `//admin`, `/admin/.`, `/admin%2f`, `;/admin`, encoded chars), the auth check is skipped. Chain that with a file-upload inside the now-exposed admin area → RCE. This is the classic "front-end/back-end path normalization mismatch".

## How it works
```
GET /..;/admin/upload  (proxy sees /..; , backend normalizes to /admin/upload)
```
Proxy doesn't enforce auth (path mismatch); backend routes to admin → upload shell.

## How to hunt for it
1. Map auth-protected paths (`/admin/*`, `/internal/*`).
2. Fuzz path-normalization variants; find one that bypasses auth (returns 200 vs 302).
3. Then exercise privileged actions (upload, config, exec) in the bypassed context.

## Payloads
```
/admin/..;/admin/
//admin/
/admin/./
/admin%2f
/admin/;foo
/anything/../admin/
```

## Fix
Normalize + canonicalize the path consistently in proxy and backend before auth decisions; deny-by-default; re-check auth at the backend.
