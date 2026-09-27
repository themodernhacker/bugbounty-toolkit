---
name: recon-http-fingerprint
description: HTTP/technology fingerprinting to prioritize targets (CMS, framework, exposed services, WAF detection). Teaches the httpx/whatweb/wafw00f pass that decides what to hunt next.
sources: hackerone_public
report_count: 1
---

# HTTP Tech Fingerprinting & WAF Detection

**Sources**: foundational recon; drives every downstream decision.

## Why it matters (the new lesson)
Before fuzzing, know the stack: a WordPress host → wpscan; a Spring Boot app → actuator; a GraphQL endpoint → introspection; a CDN/WAF → craft bypasses. Fingerprinting turns a flat list of hosts into a prioritized, per-target plan.

## How it works
```bash
httpx -l subs.txt -silent -status-code -title -tech-detect -web-server -cdn \
      -location -o http.txt
whatweb -i subs.txt --log-json=http_whatweb.json
wafw00f https://target  # identify WAF/CDN
```

## How to hunt for it
1. `httpx` with `-tech-detect` reveals stack (Express, Django, PHP, Cloudflare, React...).
2. Capture headers: `Server`, `X-Powered-By`, `Set-Cookie` (e.g. `PHPSESSID`, `JSESSIONID`, `django_language`).
3. Probe known paths per stack: `/wp-login.php` (WP), `/actuator` (Spring), `/graphql` + introspection, `/server-status`, `/status`.
4. Detect WAF (wafw00f) and note which payloads to use.

## Tooling
`httpx`, `whatweb`, `wafw00f`, `wappalyzer`, `nuclei -t technologies/`, `nmap -sV --script=http-enum`.

## Fix
(Defender) Strip server banners, hide version info, place WAF/CDN, remove unused endpoints.
