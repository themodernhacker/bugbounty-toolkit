# HUNTING_RUNBOOK.md — how to run an elite hunt with this toolkit

End-to-end operating procedure: from opening a terminal to a validated, deduped,
written-up finding. Follow it top to bottom the first few times; it becomes muscle
memory. Everything here assumes you completed the one-time setup (see README /
SETUP): `bash make-inventory.sh`, `pip install fastmcp httpx --break-system-packages`,
and `bash link-skills.sh` have all been run at least once.

---

## 0. Before you start a program
- Read the program brief on Bugcrowd/HackerOne: **in-scope** assets, **out-of-scope**,
  reward focus, excluded classes (often DoS, self-XSS, missing headers), testing
  rules, required headers (e.g. `X-Bug-Bounty`), rate limits.
- Read that program's **disclosed reports** — they show the app's weak spots and the
  triager's bar.
- Have Burp Suite Pro open (MCP extension enabled, port 9876) and/or Caido running
  (API on 127.0.0.1:8080). Only ONE is the intercepting proxy per session — Burp by
  default.

## 1. Open the workspace and launch Claude Code
```bash
cd /home/themodernhacker/bugbounty-toolkit
# make sure PATH has your tools (once per shell if not in ~/.zshrc yet)
source ~/.zshrc
claude
```
On launch, Claude Code auto-loads `CLAUDE.md` (the operating manual) and the core
skills you linked (`orchestrator`, `methodology-elite`, `skill-author`,
`openapi-to-mcp`, all the `hunt-*` class skills, …). Verify:
```
/mcp          ← should list burp + caido tools
/skills       ← should list the core skills
```

## 2. Set scope, then create the target workspace + recon — one message
Type this to Claude Code (fill in the real program):
```
Program: acme.com. Scope: *.acme.com in scope; blog.acme.com out of scope.
Authorized bug bounty. First: set scope with scope.py, then create the target
workspace and run recon with hunt.sh. Summarize what you found and where the
promising surfaces are.
```
Claude Code will run (and you can also run these yourself):
```bash
python3 scope.py add "*.acme.com"
python3 scope.py add "!blog.acme.com"
bash hunt.sh acme.com --nuclei          # add --ports for nmap, --shots for screenshots
```
`hunt.sh` makes `work/acme.com/` and fills it: `subs.txt`, `live.txt`, `urls.txt`,
`params.txt`, `js.txt`, `gf/<class>.txt`, optional `nuclei.txt` / `nmap.txt`, and
logs hosts/endpoints into `state.py`. It uses **crt.name** for CT logs,
scope-filters everything, and rate-limits politely.

## 3. Map the attack surface (Claude leads, you steer)
Ask:
```
Read work/acme.com/. Read the JS in js.txt for endpoints/params/keys. Cluster the
surface into testable targets (auth flows, object IDs, GraphQL, uploads, redirects,
SSRF sinks, admin funcs). Rank by impact×likelihood and give me the top 5 to hunt.
```
The agent reads JS by hand (that's where the good bugs hide), and uses the
`orchestrator` loop + `ROUTER.md`/`CATEGORY_MAP.md` to plan.

## 4. Hunt each surface — by severity, with advanced methods
Work the ranked list. For each surface the agent loads the matching class skill and
tests **manually through Burp Repeater** (Caido for races/authz), assisted by your
Kali tools. Guidance by tier:

**Critical (aim here first — best ROI):**
- **RCE / SSTI / deserialization** → `hunt-rce`, `hunt-ssti`, `hunt-deserialization`;
  confirm OOB via Burp Collaborator/`interactsh-client`.
- **SQLi** → manual signal first, then `sqlmap -r req.txt --batch --level 3 --risk 2`
  or `ghauri`. Never mass-run; one endpoint at a time.
- **SSRF → cloud metadata** → `hunt-ssrf`, `Gopherus`; prove with Collaborator then
  reach 169.254.169.254.
- **Auth/ATO chains** → `hunt-ato`, `hunt-oauth`, `hunt-jwt-crypto` (`jwt_tool -M at`),
  password-reset host-header poisoning.

**High:**
- **IDOR/BOLA** → `hunt-idor` + **Caido Autorize** (auto-replays as a second account).
- **Broken access control / priv-esc** → `hunt-auth-bypass`; two accounts, diff responses.
- **Stored XSS in privileged views**, **request smuggling** (`hunt-http-smuggling`),
  **cache poisoning** (Param Miner), **subdomain takeover** (`subzy`).

**Medium:**
- Reflected/DOM XSS (`dalfox`, `kxss`, DOM Invader), CSRF on sensitive actions,
  open redirect chained into OAuth, CORS misconfig (`Corsy`), SSRF (blind).

**Low (report only if in-scope & rewarded):**
- Security-header/clickjacking/info-disclosure — usually only worth it chained.

For APIs: if you find `/openapi.json` or `/swagger.json`, the agent loads
`openapi-to-mcp` to turn the spec into MCP tools and walk every endpoint with two
accounts. Kali tools (nmap, sqlmap, ffuf, dalfox, nuclei, kiterunner, etc.) are used
**per-target as needed** — tell the agent "use sqlmap here" or let it decide; it has
standing permission within scope.

## 5. Deduplicate BEFORE writing anything
For each candidate:
```bash
# signature = class|endpoint|param ; state.py computes + checks it
python3 state.py finding IDOR https://acme.com/api/orders id "peer order access"
# -> RECORDED (new) or DUPLICATE (skip)
```
Ask the agent: "dedupe this against state.py before we treat it as real."

## 6. Validate (no unproven reports)
- Reproduce from a **clean** browser profile / fresh session.
- Blind classes (SSRF, blind SQLi/XXE, RCE): capture the **OOB** interaction as proof.
- Races: prove with Caido last-byte / Turbo Intruder single-packet.
- Minimise the PoC to the smallest request(s) that prove impact.
- Establish concrete impact (data, accounts, money, RCE) — severity follows impact.

## 7. PoC + report
Ask:
```
Write the report with the report-writing skill: title, severity (CVSS if required),
affected endpoint(s), numbered repro a triager can follow blind, request/response
evidence, OOB proof, concrete impact, remediation. Save a copy under work/acme.com/reports/.
```
Then log it:
```bash
python3 state.py report <finding_id> H1-XXXXXX
```

## 8. Capture what you learned as a skill
If a technique worked and isn't already a skill:
```bash
bash new-skill.sh acme-oauth-state-bypass "OAuth state param not validated -> ATO on acme"
# edit skills/learned-live/acme-oauth-state-bypass/SKILL.md, then /reload-skills
```
This is how the toolkit compounds. Commit `skills/learned-live/` with the repo.

## 9. Come back tomorrow
```bash
python3 state.py new-since 2026-09-01   # what changed since a date
python3 state.py stats
```
Staying on one program and re-hunting scope changes is where recurring income comes from.

---

## When to tell Claude "a human is needed"
Some steps you must do yourself, and the agent should **stop and flag** rather than
attempt. Put this line in your kickoff message:

> "Whenever a step needs a human — creating or verifying an account, solving a CAPTCHA,
> entering real credentials/2FA, a manual browser action, submitting a report, or
> anything destructive or out-of-scope — STOP and tell me exactly what to do; don't
> attempt it yourself."

The agent will pause and hand those to you. This is correct: account creation,
credential entry, CAPTCHAs, and report submission are yours, not the tool's.

---

## Model & effort — what to run Claude Code on
- **Default: Opus, high thinking**, for the reasoning-heavy phases (surface mapping,
  exploitation, validation, report). This is where bugs are won. In Claude Code use
  `/model` to select Opus and prompt with "think hard" / extended thinking for the
  tough calls.
- **Stretch quota: Sonnet**, for recon orchestration, JS skimming, and running the
  tools — still strong tool use, lighter on quota. Switch with `/model`.
- Rule of thumb: **Sonnet to gather, Opus to exploit.**

## When your Claude Code limit runs out → DeepSeek fallback
Your MCP servers (Burp/Caido), your CLI tools, and your skills are **Claude Code
harness features** — they keep working under any Anthropic-compatible backend, so a
DeepSeek session still fetches/uses tools, MCP, and skills. What drops is reasoning
quality, so use it only for the grind, not exploitation.

Launch a DeepSeek session:
```bash
# put your DeepSeek key in config/claude-deepseek-settings.json (ANTHROPIC_AUTH_TOKEN)
alias claude-cheap='claude --settings /home/themodernhacker/bugbounty-toolkit/config/claude-deepseek-settings.json'
claude-cheap
```
Inside it, confirm the harness is intact before relying on it:
```
/mcp     ← Burp + Caido still listed?
/skills  ← core skills still listed?
```
If yes, use `claude-cheap` for wide recon, endpoint classification, and first-pass JS
skimming. When you get quota back, return to `claude` (Claude) for the exploitation,
validation, and report — never let the cheap model make the severity call.
(Confirm the current DeepSeek model id at api-docs.deepseek.com; set it in that
settings file's `ANTHROPIC_MODEL`.)

---

## The one-line kickoff you'll reuse
```
Program: <apex>. Scope: <in/out>. Authorized. Load orchestrator, methodology-elite,
skill-author. Set scope with scope.py, run hunt.sh, read the JS, map + rank the
surface, hunt the top 5 by impact using the class skills through Burp/Caido, dedup
with state.py, validate OOB, write reports with PoCs, and author a skill for anything
new. If a human step is needed (account, CAPTCHA, creds, submit, destructive/out-of-scope),
STOP and tell me. Use Opus-level care on exploitation; use my Kali tools (sqlmap, nmap,
ffuf, dalfox, nuclei, kiterunner) as needed within scope.
```
