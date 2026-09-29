# bugbounty-toolkit

Personal bug-bounty toolkit for **PentAGI** (ephemeral container) and **Claude Code**
(on a Kali box). Contains the idempotent install script, full tool inventory, boot
prompt, the Burp MCP client, MCP config (Burp + Caido), and a 350+ skill library so
a fresh machine can be restored in one command.

> Repo is **public** — clone with no token.

## Quick start — PentAGI (ephemeral container)

```bash
git clone --depth 1 https://github.com/themodernhacker/bugbounty-toolkit.git /work/kit
export PATH="$PATH:/root/go/bin:/usr/local/go/bin:/opt/venv/bin:/root/.local/bin"
bash /work/kit/setup.sh            # idempotent - skips installed tools
cat /work/kit/TOOL_INVENTORY.md    # full tool/path/wordlist inventory
```

## Quick start — Claude Code on Kali (full agent)

```bash
git clone https://github.com/themodernhacker/bugbounty-toolkit.git ~/bugbounty
cd ~/bugbounty

bash install-caido.sh      # install + authenticate the Caido MCP server
caido-mcp-server login     # OAuth device flow -> opens browser, long-lived token

bash link-skills.sh        # symlink 42 core skills + build skills/SKILL_INDEX.tsv

claude                     # auto-loads CLAUDE.md + .mcp.json + .claude/settings.json
```

What Claude Code picks up automatically:

- **`CLAUDE.md`** — the operating manual (identity, authorization, workflow phases,
  skills routing, tool paths, hard rules). Loaded every session.
- **`.mcp.json`** — Burp MCP (SSE `127.0.0.1:9876`) + Caido MCP
  (`caido-mcp-server serve`, `127.0.0.1:8080`).
- **`.claude/settings.json`** — permissions for the full recon/fuzz/exploit
  toolchain **plus** installers/builders (`go install`, `pipx`, `npm`, `apt-get`,
  `git`) so it can install and write its own tools.
- **`skills/`** — 350+ playbooks; 42 curated core are always-on, the rest load on
  demand via `grep` on `skills/SKILL_INDEX.tsv`.

## Files

- `setup.sh`            — idempotent install of the full bug-bounty toolset (corrected module paths)
- `install-caido.sh`    — install + authenticate the Caido MCP server (and optional `caido-cli`)
- `link-skills.sh`      — symlink curated core skills into `~/.claude/skills/` + build the grep-able index
- `CLAUDE.md`           — the Claude Code operating manual (auto-loaded every session)
- `.mcp.json`           — MCP servers: Burp + Caido
- `.claude/settings.json` — Claude Code permissions (allow/deny)
- `ROUTER.md`           — MCP wiring, fallbacks, and model-routing notes
- `TOOL_INVENTORY.md`   — every tool, binary path, wordlist, and gf pattern location
- `BOOTPROMPT.txt`      — paste-in prompt that re-establishes full context + permissions (PentAGI)
- `burp_client.py`      — Burp MCP client (27 tools): `python3 burp_client.py <tool> [json_args]`
- `mcp.sh` / `mcp2.sh`  — Burp MCP handshake helpers (SSE + sessionId)
- `mcp_fetch.py`        — routes raw HTTP requests through Burp via `send_http1_request`
- `recon.sh`            — recon chain helper
- `tools.json`          — full Burp MCP `tools/list` dump
- `skills/`             — 350+ playbooks (see `skills/README.md` + `skills/CATEGORY_MAP.md`)

## MCP notes

### Burp

- On your own Kali host: `127.0.0.1:9876`
- From a PentAGI container: `172.17.0.1:9876` (Docker gateway; NOT 127.0.0.1)
- Handshake headers: `Host: localhost:9876`, `Origin: http://localhost:9876`
- `GET /` -> SSE `endpoint` event with `sessionId` -> `POST /?sessionId=<id>`
- Fallback if the native handshake 403s: `python3 burp_client.py <tool> [json_args]`

### Caido (`c0tton-fluff/caido-mcp-server`)

- 67 tools + 6 resources: history, replay, `caido_batch_send` (50-parallel BAC/IDOR
  sweeps), `caido_race_window_send`, tamper rules, findings, scopes, workflows.
- Stdio; Claude Code launches it as `caido-mcp-server serve`.
- Auth: `caido-mcp-server login` (OAuth device flow, auto-refresh) **or**
  `CAIDO_ACCESS_TOKEN` (7-day static — grab it in the Caido GUI console with
  `JSON.parse(localStorage.CAIDO_AUTHENTICATION).accessToken`).
- Optional standalone CLI: `caido-cli status -u http://127.0.0.1:8080`.

## Enforcement, memory & extras

- `scope.py` — code-enforced in/out-of-scope guard (`check` / `filter` / `add`). Call before touching any host.
- `state.py` — SQLite findings/host/endpoint store with dedup and `new-since` (cross-session memory).
- `skills/openapi-to-mcp/` — turn a target's OpenAPI/Swagger spec into a live MCP toolset via FastMCP.
- `config/claude-deepseek-settings.json` — optional DeepSeek "grinder" profile for Claude Code (`claude --settings ...`). Keep exploitation/validation on Claude.

See `CLAUDE.md` §8 for usage.
