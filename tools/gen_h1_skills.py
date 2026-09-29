#!/usr/bin/env python3
"""Generate hunting skills from reddelexc/hackerone-reports.

Source: the curated `docs/tops_by_bug_type/TOP*.md` files (each a ranked list of
disclosed HackerOne reports for one bug class). We distill each into a
`skills/hackerone-reports/h1-<slug>/SKILL.md` playbook:

  - YAML frontmatter (name, description, source, report_count, top_bounty) so
    Claude Code discovers it,
  - the top disclosed reports (title / program / bounty / link) — the real
    technique lives in the linked report; this is a curated on-ramp,
  - "patterns in the wild" auto-extracted from the report titles,
  - a class-specific hunting checklist,
  - pointers to the validation/reporting process skills.

These are an INDEX of public disclosures, not exploit code. Read the linked
report for the full write-up.

Usage:
    python3 tools/gen_h1_skills.py [PATH_TO_hackerone-reports_CLONE]

Default source path: ./.h1src  (gen-skills.sh clones the repo there first).
Idempotent: regenerates the whole skills/hackerone-reports/ tree each run.
"""
import os, re, sys, html, collections

NL = chr(10)
REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC  = sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, ".h1src")
BUGDIR = os.path.join(SRC, "docs", "tops_by_bug_type")
OUT  = os.path.join(REPO, "skills", "hackerone-reports")

LINE = re.compile(
    r"^\d+\.\s+\[(?P<title>.+?)\]\((?P<link>https?://\S+?)\)\s+to\s+"
    r"(?P<program>.+?)\s+-\s+(?P<up>\d+)\s+upvotes?,\s+\$(?P<bounty>[\d,]+)"
)

# TOP<FILE>.md  ->  (slug, human class, pairs-with core skill, scope note, checklist)
SCOPE_OOS = ("OUT OF SCOPE in almost every bug bounty program. Do NOT test "
             "without explicit written authorization for this exact class.")
M = {
 "TOPACCOUNTTAKEOVER": ("account-takeover","Account Takeover","hunt-ato",None,[
    "Map every auth-state transition: password reset, email change, OAuth link, session, JWT.",
    "Password reset: host-header poisoning, token predictability, token leak via Referer, no-expiry/reuse.",
    "Chain low-sev primitives: open redirect at redirect_uri -> auth-code theft -> ATO.",
    "Prove takeover of a SECOND test account from the attacker's session; never touch real users."]),
 "TOPAPI": ("api","API abuse / insecure API","hunt-api-misconfig",None,[
    "Pull every spec (Swagger/OpenAPI/GraphQL); diff versions (v1/v2/beta/legacy).",
    "Test BOLA/BFLA, mass assignment, missing rate limits, verbose error leakage.",
    "Recover undocumented/legacy endpoints from JS bundles + the Wayback Machine.",
    "Replay privileged calls as a low-priv user; sweep object IDs across tenants."]),
 "TOPAUTH": ("auth","Authentication flaws","hunt-auth-bypass",None,[
    "Trace the full login/SSO flow in the proxy; find every state check.",
    "SAML: signature stripping/XSW, comment injection; JWT: alg confusion, alg:none.",
    "Alternate-channel bypass (legacy endpoint, mobile API, XMLRPC) skipping SSO.",
    "Brute/rate-limit gaps on login and OTP; credential reuse from breaches (own accounts only)."]),
 "TOPAUTHORIZATION": ("authorization","Authorization / access control","hunt-idor",None,[
    "Enumerate roles and every object reference; build a permission matrix.",
    "Horizontal (other users' data) and vertical (admin functions) escalation.",
    "Forced browsing to function-level endpoints; missing server-side checks behind hidden UI.",
    "Prove with two accounts A/B; read/modify B's data from A."]),
 "TOPBUSINESSLOGIC": ("business-logic","Business logic flaws","hunt-business-logic",None,[
    "Model the intended money/trust flow; look for skipped or reorderable steps.",
    "Negative/decimal quantities, price/coupon tampering, currency confusion.",
    "Race conditions on redeem/transfer/vote (see h1-race-condition).",
    "Demonstrate concrete financial/impact loss to the target."]),
 "TOPCLICKJACKING": ("clickjacking","Clickjacking / UI redressing","hunt-clickjacking",None,[
    "Only sensitive state-changing actions matter; ignore bare header absence.",
    "Confirm the page frames in a real browser AND the action survives SameSite/framebusting.",
    "Chain to OAuth confirm, money transfer, or account settings for real impact."]),
 "TOPCSRF": ("csrf","Cross-Site Request Forgery","hunt-csrf",None,[
    "Find state-changing requests with no/again-usable anti-CSRF token.",
    "SameSite gaps: Lax sibling-subdomain, JSON via text/plain, GET-based mutations.",
    "Chain to email/password change -> ATO; test WebSocket CSRF (CSWSH).",
    "Prove cross-site execution from an attacker origin."]),
 "TOPDOS": ("dos","Denial of Service","triage-validation",SCOPE_OOS,[
    "Read the program policy FIRST — DoS is almost always explicitly excluded.",
    "Study these reports for patterns (ReDoS, algorithmic complexity, resource amplification) as DEFENSIVE knowledge.",
    "If (and only if) a program authorizes it in writing, use the smallest possible PoC and stop at proof."]),
 "TOPFILEREADING": ("file-reading","File disclosure / LFI / path traversal","hunt-lfi",None,[
    "Hit every path/file/template parameter with traversal + wrappers (php://, file://).",
    "PHP filter-chain to RCE; log poisoning; blind read confirmed OOB.",
    "Cloud/app secrets: /proc, config files, source, AWS creds.",
    "Escalate read -> source leak -> further chains."]),
 "TOPGRAPHQL": ("graphql","GraphQL vulnerabilities","hunt-graphql",None,[
    "Introspect the schema; enumerate queries/mutations and their authz.",
    "IDOR via node()/global IDs; SSRF/SQLi through arguments.",
    "Batching/alias abuse for rate-limit bypass and cost DoS (scope permitting).",
    "Field-level authz gaps leaking PII across tenants."]),
 "TOPIDOR": ("idor","Insecure Direct Object Reference","hunt-idor",None,[
    "Collect every object identifier (numeric, UUID, hash, encoded).",
    "Swap IDs across two accounts; test read, update, delete separately.",
    "Look in APIs, GraphQL node(), export/download, and 'share' features.",
    "Decode obfuscated IDs (base64, hashids) before concluding it's safe."]),
 "TOPINFODISCLOSURE": ("info-disclosure","Information disclosure","hunt-source-leak",None,[
    "Source maps, .git/.env exposure, Swagger, debug/stack traces, verbose errors.",
    "GitHub/dorking for secrets; JS bundles for keys and internal endpoints.",
    "Directory listing, backup files, and cache/CDN leakage of other users' data.",
    "Rate impact by the sensitivity of what's exposed (PII/creds >> version banners)."]),
 "TOPMFA": ("mfa","MFA / 2FA bypass","hunt-mfa-bypass",None,[
    "Is MFA middleware-gated or per-endpoint? Try direct navigation past the challenge.",
    "OTP: brute (no rate limit), replay, race on validate, backup-code dump via /api/me.",
    "Factor downgrade; 'remember me' persistence bypass.",
    "Reach a post-MFA authenticated state as the attacker to prove it."]),
 "TOPMOBILE": ("mobile","Mobile app vulnerabilities","triage-validation",None,[
    "Decompile (jadx/apktool); grep for secrets, endpoints, Firebase, pinned certs.",
    "Insecure storage, exported components, deeplink abuse, weak SSL pinning.",
    "Test the mobile API surface — often older/weaker than the web app.",
    "Reverse the client to reach hidden/privileged endpoints."]),
 "TOPOAUTH": ("oauth","OAuth / OIDC misconfiguration","hunt-oauth",None,[
    "redirect_uri validation: prefix/suffix/regex bypass, open-redirect chain to code theft.",
    "state parameter: CSRF, null-byte, missing; scope escalation; leaking code in Referer.",
    "Account-link CSRF; IdP confusion; token audience misuse.",
    "Prove auth-code/token theft leading to ATO."]),
 "TOPOPENID": ("openid","OpenID Connect flaws","hunt-oauth",None,[
    "ID token validation: signature, iss/aud/exp, alg confusion (see hunt-jwt-crypto).",
    "Nonce/state handling; PKCE downgrade; discovery/JWKS spoofing.",
    "Chain to ATO via forged/replayed ID token."]),
 "TOPOPENREDIRECT": ("open-redirect","Open redirect","hunt-open-redirect",None,[
    "Every redirect param (next, url, return, callback); test //evil.com and whitelist-host bypasses.",
    "Low-sev alone — always chain: OAuth code theft, SSRF pivot, phishing.",
    "Header/meta/JS redirect variants; parameter pollution to smuggle the target."]),
 "TOPRACECONDITION": ("race-condition","Race conditions","hunt-race-condition",None,[
    "Single-packet attack (HTTP/2) / last-byte sync for near-simultaneous requests.",
    "Targets: coupon/gift-card redeem, balance transfer, vote, OTP validate, signup.",
    "Measure the limit-overrun (e.g. redeemed N times); reset state between tries.",
    "Confirm it's a real TOCTOU window, not just retries."]),
 "TOPRCE": ("rce","Remote Code Execution","hunt-rce",None,[
    "Injection sinks: template (SSTI), deserialization, command, file-include, upload.",
    "SSRF -> internal management agents (Jolokia/Actuator/Redis) -> RCE.",
    "Confirm execution OOB (Collaborator/interactsh); non-destructive proof only (id/hostname).",
    "This is Critical — stop at proof, never pivot beyond what the report needs."]),
 "TOPREQUESTSMUGGLING": ("request-smuggling","HTTP request smuggling","hunt-http-smuggling",None,[
    "CL.TE / TE.CL / H2.CL / H2.TE on CDN+origin stacks; use HTTP Request Smuggler.",
    "Confirm with the time-delay technique before impact.",
    "Escalate: cache poisoning, credential capture, auth bypass via smuggled prefix.",
    "Be careful — poisoning affects other users; keep PoC self-targeted."]),
 "TOPSQLI": ("sqli","SQL injection","hunt-sqli",None,[
    "Every param, header, and JSON field; error-based, boolean/time blind, second-order.",
    "ORM raw fragments, GraphQL/SOQL args, WAF bypass encodings.",
    "sqlmap for confirmation; prove data access minimally (version(), one benign row).",
    "Never dump real customer data — one-row proof is enough."]),
 "TOPSSRF": ("ssrf","Server-Side Request Forgery","hunt-ssrf",None,[
    "Every URL-fetch/import/webhook/preview/PDF feature; blind cases OOB-confirmed.",
    "Cloud metadata (169.254.169.254, IMDSv1), internal ports, gopher->Redis.",
    "Filter bypass: DNS rebinding, decimal/hex IP, redirects, alternate schemes.",
    "Escalate to credential theft / internal RCE; stop at proof."]),
 "TOPSSTI": ("ssti","Server-Side Template Injection","hunt-ssti",None,[
    "Probe math in {{ }} / ${ } across Jinja2/Twig/Freemarker/ERB/Velocity.",
    "Fingerprint engine from behavior, then use the engine-specific RCE gadget.",
    "Targets: email/PDF/report templates, CMS preview, error pages with input.",
    "Confirm code exec OOB; benign proof only."]),
 "TOPSUBDOMAINTAKEOVER": ("subdomain-takeover","Subdomain takeover","hunt-subdomain",None,[
    "Enumerate CNAMEs; match dangling targets against can-i-take-over-xyz fingerprints.",
    "Claim only on assets you control to prove it; screenshot and release.",
    "Escalate: cookie scope, OAuth redirect_uri, email — chain to ATO.",
    "Never serve content that could harm real users."]),
 "TOPUPLOAD": ("file-upload","File upload vulnerabilities","hunt-file-upload",None,[
    "Bypass tables: double ext, magic bytes, content-type, .htaccess, SVG/HTML.",
    "Webshell -> direct request -> RCE; SVG/HTML -> stored XSS; DOCX/ZIP -> XXE/zip-slip.",
    "Path traversal in filename; overwrite sensitive files.",
    "Prove execution/XSS on a resource you uploaded."]),
 "TOPWEBCACHE": ("web-cache","Web cache poisoning / deception","hunt-cache-poison",None,[
    "Find unkeyed inputs (X-Forwarded-Host/-Scheme, headers) reflected in cached responses.",
    "Web Cache Deception: static-ext trick to cache authenticated pages.",
    "Confirm the poisoned/deceived response is served to ANOTHER user (self-targeted PoC).",
    "CDN path-normalization differences (Cloudflare/Fastly/GCP)."]),
 "TOPXSS": ("xss","Cross-Site Scripting","hunt-xss",None,[
    "Reflected/stored/DOM; every sink; context-aware payloads and WAF bypass.",
    "DOM: sources (location, postMessage) -> sinks (innerHTML, eval).",
    "Escalate: steal session, CSRF token, or chain to ATO — self-targeted PoC.",
    "Prove JS execution (not just HTML injection -> that's html-injection)."]),
 "TOPXXE": ("xxe","XML External Entity","hunt-xxe",None,[
    "Any XML/SVG/DOCX/SOAP/SAML parser; classic and blind OOB (DTD callback).",
    "Escalate XXE -> LFI, SSRF, and occasionally RCE.",
    "OOB-or-it-didn't-happen for blind; Collaborator confirmation.",
    "Parameter entities when inline entities are filtered."]),
}

VOCAB = ["blind","stored","reflected","dom","chain","chained","bypass","account takeover","ato",
 "metadata","aws","gcp","azure","oauth","saml","jwt","graphql","api","admin","internal",
 "rce","ssrf","idor","csrf","privilege","escalation","unauthenticated","pre-auth","2fa","mfa",
 "redirect","upload","cache","smuggling","race","mass assignment","cors","subdomain","token",
 "leak","disclosure","path traversal","lfi","sqli","ssti","xxe","deserialization","webhook"]

def parse(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        for ln in f:
            m = LINE.match(ln.strip())
            if not m:
                continue
            d = m.groupdict()
            rows.append({
                "title": html.unescape(d["title"]).strip(),
                "link": d["link"].strip(),
                "program": d["program"].strip(),
                "up": int(d["up"]),
                "bounty": int(d["bounty"].replace(",", "")),
            })
    return rows

def patterns(rows):
    text = " ".join(r["title"].lower() for r in rows)
    hits = [(kw, text.count(kw)) for kw in VOCAB]
    hits = [(k, n) for k, n in hits if n >= 2]
    hits.sort(key=lambda x: -x[1])
    return hits[:12]

def money(n):
    return f"${n:,}" if n else "$0"

def gen(file_base, meta, rows):
    slug, cls, pairs, scope, checklist = meta
    rows = sorted(rows, key=lambda r: (-r["up"], -r["bounty"]))
    n = len(rows)
    top_b = max((r["bounty"] for r in rows), default=0)
    name = f"h1-{slug}"
    desc = (f"{cls}: real-world techniques and chains distilled from {n} disclosed "
            f"HackerOne reports (top bounty {money(top_b)}). Use when hunting {cls.lower()} "
            f"for battle-tested patterns, filter bypasses and escalation chains from public "
            f"disclosures; pairs with {pairs}.")
    out = []
    out.append("---")
    out.append(f"name: {name}")
    out.append(f"description: {desc}")
    out.append("source: reddelexc/hackerone-reports")
    out.append(f"report_count: {n}")
    out.append(f"top_bounty: {top_b}")
    out.append("---")
    out.append("")
    out.append(f"# {cls} — disclosed-report playbook (H1)")
    out.append("")
    if scope:
        out.append(f"> **SCOPE WARNING:** {scope}")
        out.append("")
    out.append(f"Distilled from **{n}** disclosed HackerOne reports for this class "
               f"(top bounty **{money(top_b)}**). This is a curated on-ramp — the full "
               f"technique lives in each linked report. Pair with the `{pairs}` skill for "
               f"the hunting methodology.")
    out.append("")
    out.append("## How to hunt")
    for c in checklist:
        out.append(f"- {c}")
    out.append("")
    pats = patterns(rows)
    if pats:
        out.append("## Patterns in the wild (from report titles)")
        out.append("")
        out.append(" · ".join(f"`{k}` ×{v}" for k, v in pats))
        out.append("")
    out.append("## Top disclosed reports")
    out.append("")
    for r in rows[:30]:
        t = r["title"].replace(chr(92), "/")
        out.append(f"- [{t}]({r['link']}) — {r['program']}, {money(r['bounty'])} · {r['up']}↑")
    out.append("")
    out.append("## Validate & report")
    out.append("- Reproduce from a clean session/account; rule out false positives.")
    out.append("- Gate the finding through `triage-validation`; capture evidence per `evidence-hygiene`.")
    out.append("- Write it up with `report-writing` / `bugcrowd-reporting`. Prove impact; never inflate.")
    out.append("")
    return name, desc, n, top_b, NL.join(out)

def main():
    if not os.path.isdir(BUGDIR):
        sys.exit(f"[!] source not found: {BUGDIR}" + NL + "    clone reddelexc/hackerone-reports "
                 f"first (gen-skills.sh does this), or pass its path as arg 1.")
    os.makedirs(OUT, exist_ok=True)
    made = []
    for fb, meta in M.items():
        p = os.path.join(BUGDIR, f"{fb}.md")
        if not os.path.isfile(p):
            print(f"  ! missing source file: {fb}.md — skipped")
            continue
        rows = parse(p)
        if not rows:
            print(f"  ! no rows parsed from {fb}.md — skipped")
            continue
        name, desc, n, top_b, body = gen(fb, meta, rows)
        d = os.path.join(OUT, name)
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, "SKILL.md"), "w", encoding="utf-8") as f:
            f.write(body)
        made.append((name, n, top_b))
        print(f"  + {name:28s}  {n:4d} reports  top {money(top_b)}")
    # collection README
    made.sort()
    with open(os.path.join(OUT, "README.md"), "w", encoding="utf-8") as f:
        lines = ["# hackerone-reports (generated)", "",
                 "Skills distilled from [reddelexc/hackerone-reports]"
                 "(https://github.com/reddelexc/hackerone-reports) disclosed-report lists.",
                 "Regenerate with `bash tools/gen-skills.sh`. Each skill is an indexed "
                 "on-ramp to real public disclosures for one bug class.", ""]
        for name, n, top_b in made:
            lines.append(f"- `{name}` — {n} reports, top {money(top_b)}")
        f.write(NL.join(lines) + NL)
    print(NL + f"[*] Generated {len(made)} skills into skills/hackerone-reports/")

if __name__ == "__main__":
    main()
