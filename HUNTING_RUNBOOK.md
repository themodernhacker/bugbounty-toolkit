# HUNTING_RUNBOOK.md — the full operating procedure

The step-by-step loop for a hunt, from a fresh container to a submitted report.
Read `CLAUDE.md` first (identity, scope rules, hard rules) — this runbook is
*how*, `CLAUDE.md` is *who / what you never break*. Nothing here overrides the
§7 hard rules or the scope model in §0.

---

## 0. Fresh container

```bash
git clone --depth 1 https://github.com/themodernhacker/bugbounty-toolkit.git ~/bugbounty-toolkit
cd ~/bugbounty-toolkit
export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH"
bash setup.sh            # idempotent install (logs to setup.log)
bash link-skills.sh      # core skills -> ~/.claude/skills/
bash make-inventory.sh   # confirm what's actually on PATH; install anything MISSING
```

Interceptor up? Burp on the same host (`127.0.0.1:9876`, MCP Server BApp) or
Caido (`bash install-caido.sh` then `caido-mcp-server serve`). Verify with `/mcp`.

---

## 1. Confirm scope — always first

One out-of-scope request can end a program. Before any host is touched:

```bash
python3 scope.py add "*.target.com"        # in-scope apex/wildcard
python3 scope.py add "!dev.target.com"     # exclusions from the program's rules
python3 scope.py check https://api.target.com/x   # exit 0 = in scope, 2 = out
```

Load the program's brief: rate limits, excluded paths/classes, testing windows,
required `X-Bug-Bounty` header. If scope is unclear, **stop and ask the user.**
Third-party infra seen in traffic (CDNs, analytics, payment, OAuth) is out of
scope unless separately listed.

---

## 2. Recon (Phase 1)

```bash
bash hunt.sh target.com                 # passive+active discovery, scope-gated, -> state.py
bash hunt.sh target.com --nuclei        # add safe/default nuclei templates
bash hunt.sh target.com --ports --shots # nmap top-ports + gowitness (louder — mind RoE)
```

`hunt.sh` refuses an apex that isn't in `scope.txt`, filters every result through
`scope.py`, and logs hosts/endpoints to `.bbstate.db`. Artifacts land in
`work/target/` (`subs.txt live.txt urls.txt params.txt js.txt gf/*.txt`).
CT discovery uses **crt.name** (`crtname.sh`), not crt.sh.

Open the `gf/` buckets and `params.txt` — this is where hypotheses come from.

---

## 3. Attack-surface mapping (Phase 2)

For each live app note: auth model + roles, API shape (REST/GraphQL/gRPC),
state-changing actions, file upload/fetch, redirects, SSRF-able fetchers,
injection sinks. Tag each surface with candidate vuln classes. On an OpenAPI /
Swagger spec, load the `openapi-to-mcp` skill and walk the API with two accounts.

---

## 4. Targeted hunting by severity (Phase 3)

Work highest-impact-first, one hypothesis at a time. For each candidate class
load its `hunt-*` playbook **plus** the `h1-<class>` companion (real disclosed
patterns), pick from `skills/CATEGORY_MAP.md`, and grep the index for anything
niche:

```bash
grep -i "<keyword>" skills/SKILL_INDEX.tsv
cat skills/<collection>/<skill>/SKILL.md
```

Rough order (adjust to the target): auth/session bypass & IDOR/BOLA → SSRF/RCE/
injection → account takeover chains → business-logic → info leak / misconfig /
open redirect / CORS as chain material. Manual confirmation goes through
Burp/Caido Repeater; blind bugs (SSRF/XXE/RCE) confirmed via
Collaborator/interactsh. Never submit something you only saw from a scanner.

Dedup as you go:

```bash
python3 state.py seen <signature>       # exit 0 = already recorded -> skip
python3 state.py finding SSRF https://target/fetch url "blind ssrf via url="
```

---

## 5. Validation & dedupe (Phase 4)

Reproduce every finding from a **clean session/account**. Rule out WAF
reflections, cached responses, and your own session state. Establish the real
impact and the chain. Check disclosed reports, program known-issues, and your
own `state.py` notes — assume duplicate until proven novel; the chain + impact is
what separates a dupe from an accept.

---

## 6. Reporting (Phase 5)

Minimal reproducible PoC, clear impact, remediation, CVSS/severity, redacted
evidence (timestamp everything, redact PII). Load `report-writing` /
`bugcrowd-reporting`. Report faithfully — if it doesn't reproduce, say so; no
inflated severity, no fabricated PoCs. After submission:

```bash
python3 state.py report <finding_id> H1-123456
python3 state.py new-since 2026-09-01    # what you found this cycle
```

---

## 7. When to STOP and flag a human

These are the **user's** to do — never attempt them yourself:

- creating/verifying accounts, solving CAPTCHAs
- entering real credentials or 2FA
- manual browser actions the tools can't script
- **submitting** reports
- anything destructive, or anything touching an asset you can't confirm is in scope

When you hit one, stop and tell the user exactly what to do.

---

## 8. DeepSeek fallback (optional)

For big, dumb, parallelizable batches only (summarise crawl dumps, first-pass
nuclei-JSON triage, cluster URLs). Route through claude-code-router:
`claude --settings config/claude-deepseek-settings.json` (see `ROUTER.md` §B).
Keep the driver — exploitation, validation, severity — on Claude. The Cyber
Verification approval does **not** cover DeepSeek, and target data sent there
leaves your machine: never for NDA'd program data.
