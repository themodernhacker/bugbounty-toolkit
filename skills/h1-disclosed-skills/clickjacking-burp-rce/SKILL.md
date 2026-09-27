---
name: clickjacking-burp-rce
description: Clickjacking a security tool (Burp Scanner/Crawler) to achieve RCE — abusing the trust that security tools render arbitrary HTML in privileged contexts. Teaches targeting the tester's own tooling.
sources: hackerone_public
report_count: 1
---

# RCE via Clickjacking a Security Tool (Burp)

**Report**: PortSwigger — "RCE of Burp Scanner/Crawler via Clickjacking" (#1274695, $3,000).

## Why it matters (the new lesson)
Security tools render attacker HTML in privileged environments (Burp's embedded Chromium has access to filesystem/network APIs). Clickjacking the tool's UI — or its embedded browser loading a malicious page — can pivot to the scanner host. The lesson: **the tools themselves are attack surface**, and clickjacking works against desktop/embedded-browser UIs, not just websites.

## How it works
Burp's crawler renders pages; a malicious page (or a clickjacked Burp UI element) can trigger privileged actions in the embedded browser (e.g., navigation to `burp://` or local APIs), leading to code execution on the tester's machine.

## How to hunt for it
1. Map the target tool's embedded browser / privileged URL schemes / UI actions.
2. Craft a page that overlays or drives a privileged action (e.g., drag-drop, navigation to a privileged scheme).
3. Confirm the action executes outside the sandbox.

## Payloads / notes
Target privileged schemes (`burp://`, `chrome://`, `file://`), drag-and-drop, and paste-to-UI vectors in the embedded browser.

## Fix
Restrict embedded-browser privileges + schemes; confirm sensitive UI actions; treat rendered content as untrusted in tooling too.
