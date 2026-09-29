# ROUTER.md — model routing, MCP wiring, and permissions

Everything about *how the agent is driven and connected*. Read alongside
`CLAUDE.md` (the operating manual) and `.mcp.json` (the server declarations).

---

## A. Which harness? (pentagi vs Claude Code vs build-your-own)

Short version: **use Claude Code as the primary harness.** Reasons that matter
for *this* toolkit:

- Best-in-class agentic tool use — it drives the CLI tools, Burp/Caido MCP, and
  your 329 skills reliably, with subagents for parallel recon.
- Native skills + this repo's `CLAUDE.md` give you the "think like a top
  researcher" loop without you building an orchestrator.
- Your Cyber Verification approval (org `94f75d2d-…`) lifts the dual-use
  safeguards on **Anthropic models** for exactly this use case — so Claude Code
  is the supported, unblocked path.

PentAGI is a fine autonomous framework, but you own its model quality and
guardrails, and it won't use these skills natively. Keep it optional. Don't
build your own orchestrator yet — you'd be re-implementing what Claude Code +
subagents already give you.

**Recommended split brain:**
- **Driver = Claude** (agentic hunting, MCP, skills, planning, validation).
- **Cheap side-brain = DeepSeek**, *optional*, for bulk non-agentic grunt work
  (summarize crawl dumps, first-pass triage of `nuclei` JSON, explain a JS
  bundle, cluster 10k URLs). Not the driver.

---

## B. Running DeepSeek inside Claude Code

Claude Code speaks the **Anthropic Messages API**; DeepSeek is **OpenAI-shaped**.
You need a translating proxy. Use **claude-code-router** (`ccr`).

```bash
npm install -g @musistudio/claude-code-router
mkdir -p ~/.claude-code-router
```

`~/.claude-code-router/config.json`:
```json
{
  "Providers": [
    {
      "name": "deepseek",
      "api_base_url": "https://api.deepseek.com/chat/completions",
      "api_key": "${DEEPSEEK_API_KEY}",
      "models": ["deepseek-chat", "deepseek-reasoner"]
    }
  ],
  "Router": {
    "default":     "deepseek,deepseek-chat",
    "background":  "deepseek,deepseek-chat",
    "think":       "deepseek,deepseek-reasoner",
    "longContext": "deepseek,deepseek-chat"
  }
}
```
```bash
export DEEPSEEK_API_KEY=...      # keep it in env, never commit it
ccr code                          # launches Claude Code through the router
# switch models mid-session:  /model deepseek,deepseek-reasoner
```

**Honest tradeoffs — read before you rely on it:**
- **Agentic quality drops.** Non-Claude models produce more malformed tool
  calls, weaker long-horizon planning, and worse skill selection. This harness
  and the skills are tuned for Claude. Expect to babysit DeepSeek more.
- **The Cyber Verification approval does NOT apply to DeepSeek.** That approval
  lifts *Anthropic's* safeguards on *Anthropic's* models. DeepSeek enforces its
  own policies and may refuse or behave differently.
- **Data goes to DeepSeek.** Recon output, target hostnames, and request/response
  captures sent to `api.deepseek.com` leave your machine. For client/program
  targets under NDA, that's a real data-handling decision — prefer Claude, or a
  self-hosted model, for anything sensitive.
- On model names: DeepSeek's stable IDs are `deepseek-chat` and
  `deepseek-reasoner`. Marketing names like "V3.1 / V4.1 flash" are usually
  aggregator (e.g. OpenRouter) labels — confirm the exact ID in DeepSeek's
  current docs and swap it into the config. If you route through OpenRouter
  instead, set `api_base_url` to `https://openrouter.ai/api/v1/chat/completions`
  and use its model slug.

**Best-practice pattern:** run the main session on Claude; when you have a big,
dumb, parallelizable batch, either `/model` over to DeepSeek for that stretch,
or have the Claude agent shell out to a small `deepseek` CLI and read results
back. Keep the driver on Claude.

---

## C. Burp MCP wiring

Your existing setup reached Burp across containers at `172.17.0.1:9876` and had
to spoof `Host: localhost:9876` to pass Burp's Origin/Host check — that's the
whole reason `burp_client.py` exists.

**Cleanest fix: run Claude Code on the same host/namespace as Burp.** Then
`127.0.0.1:9876` works and the Origin is naturally allowed. That's what
`.mcp.json` uses. No spoofing, no gateway.

1. In Burp: **Extensions → BApp Store → "MCP Server"** → install → enable. It
   serves SSE on `127.0.0.1:9876`.
2. Confirm `.mcp.json` `burp.url` = `http://127.0.0.1:9876/`.
3. Launch Claude Code from the same host; run `/mcp` to verify `burp` connects.

**If you must run Claude Code in a different container from Burp**, the native
SSE handshake will 403 (Node can't override the `Host` header, and Burp checks
it). Two fallbacks:
- **Keep `burp_client.py`** (proven). The agent calls
  `python3 burp_client.py <tool> [json]` — it does the SSE+sessionId+Host dance
  itself. This is the most reliable cross-container option today.
- **Bridge with a stdio proxy** on Burp's host (e.g. `uvx mcp-proxy`) so Claude
  Code connects over stdio and the proxy talks localhost SSE to Burp.

Burp MCP gives you Repeater, Intruder, Scanner, Collaborator, and encode/decode
(`content` key). HTTP/2 tools use `pseudoHeaders`+`headers`+`requestBody`;
Collaborator `customData` ≤16 alphanumerics. Full dump: `tools.json`.

---

## D. Caido MCP wiring

Caido exposes MCP via its plugin system. Exact port/path depend on the plugin
build, so **verify before trusting `.mcp.json`**:

1. In Caido: enable the MCP plugin (Plugins → install the MCP/AI plugin), note
   the local URL it prints.
2. Update `.mcp.json` `caido.url` to match (the `127.0.0.1:8085/sse` there is a
   placeholder). If the plugin issues a token, add
   `"Authorization": "Bearer ${CAIDO_MCP_TOKEN}"` under `caido.headers` and
   export `CAIDO_MCP_TOKEN`.
3. `/mcp` in Claude Code to confirm it connects.

Default primary interceptor is **Burp** (`PRIMARY_PROXY=burp` in `CLAUDE.md`
§6). Flip to Caido by setting `PRIMARY_PROXY=caido`; the agent then prefers
Caido MCP tools for replay/match-&-replace and keeps Burp for Scanner +
Collaborator.

---

## E. Permissions (use all tools without constant prompts)

Two options, pick per risk appetite:

1. **Allowlist (recommended default).** `.claude/settings.json` in this repo
   pre-approves the security tools so Claude runs recon/scan/replay without
   prompting each time, while still gating truly destructive shell patterns.
   Extend the `allow` list as you add tools.
2. **Full auto in the disposable container.** Only because the Kali container is
   isolated and every target is authorized, you *may* run
   `claude --dangerously-skip-permissions` for hands-off hunting. Do this **only**
   inside the throwaway container, never on your host, never where non-authorized
   assets are reachable. It removes the last guardrail against a bad command, so
   keep §7 of `CLAUDE.md` (hard rules) firmly in the loop.

Tool paths are already on `PATH` (see `CLAUDE.md` §5). Claude executes anything
there; the only gate is the permission layer above.
