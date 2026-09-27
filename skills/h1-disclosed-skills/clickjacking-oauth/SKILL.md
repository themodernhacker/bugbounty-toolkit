---
name: clickjacking-oauth
description: Clickjacking OAuth authorization pages (incl. double clickjacking) to trick users into authorizing an attacker app. Teaches clickjacking as an OAuth/consent attack and double-clickjacking technique.
sources: hackerone_public
report_count: 2
---

# Clickjacking OAuth / Consent Pages (incl. double clickjacking)

**Reports**: "Double Clickjacking on WakaTime OAuth flow" (#3287060); Coinbase — "OAuth authorization page vulnerable to clickjacking" (#65825).

## Why it matters (the new lesson)
The OAuth consent page ("App X wants access to your account — Authorize?") is the highest-value clickjacking target: a transparent iframe over an invisible "Authorize" button lets you obtain the victim's OAuth authorization → account/data access. **Double clickjacking** defeats framebusting/X-Frame-Options by placing two nested layers so the *second* click lands on the real button.

## How it works
- Classic: transparent iframe of `oauth/authorize` aligned over a decoy button; victim's click hits "Authorize".
- Double clickjacking: first click sets focus/opens a popup, second click lands on the target button (evades `X-Frame-Options` + JS framebusters).

## How to hunt for it
1. Check OAuth/consent/confirm pages for `X-Frame-Options`/`frame-ancestors`/framebusting.
2. Build a PoC overlay; verify a click authorizes.
3. If protected, test double-clickjacking (two-step) and `sandbox`-escape variants.

## Payloads
```html
<iframe src="https://target/oauth/authorize?client_id=...&response_type=code" style="opacity:0.001;position:fixed"></iframe>
<button style="position:fixed;top:...">Click me</button>
```

## Fix
`frame-ancestors 'none'`/`self` in CSP + `X-Frame-Options: DENY`; require re-authentication/confirmation for sensitive consent; consider `X-Frame-Options` on ALL pages.
