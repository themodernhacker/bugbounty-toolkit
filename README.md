# bugbounty-toolkit

Personal bug-bounty research toolkit, driven by **Claude Code** on a Kali box
with Burp Suite Pro + Caido Pro. Stores the operating manual (`CLAUDE.md`), the
skills library, the idempotent install script, the full tool inventory, and the
Burp/Caido MCP wiring so a fresh (ephemeral) container can be restored in one
command.

> Repo is **public** — clone with no token. Never commit secrets, keys, tokens,
> `.env`, cookies, or captured session material (see `.gitignore`).

## Quick start (fresh Kali container)
```bash
git clone --depth 1 https://github.com/themodernhacker/bugbounty-toolkit.git ~/bugbounty-toolkit
cd ~/bugbounty-toolkit
# User dirs go FIRST so ~/go/bin/httpx (ProjectDiscovery) wins over Kali's /usr/bin/httpx:
export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:/usr/local/bin:$PATH"
bash setup.sh              # idempotent — skips already-installed tools; logs to setup.log
cat TOOL_INVENTORY.md      # full tool / path / wordlist inventory
bash link-skills.sh        # symlink the core skills into ~/.claude/skills/
```
Then launch `claude` from this directory — it auto-loads `CLAUDE.md` (the
operating manual) and discovers the skills.

## Files
- `CLAUDE.md`           — the operating manual Claude Code auto-loads every session (identity, scope rules, workflow, tools, hard rules)
- `ROUTER.md`           — model routing, Burp/Caido MCP wiring, and permissions
- `setup.sh`            — idempotent install of the full bug-bounty toolset (`$HOME`-based; override with `BB_PREFIX`)
- `TOOL_INVENTORY.md`   — every tool, binary path, wordlist, and gf pattern location
- `link-skills.sh`      — symlinks the curated core skills into `~/.claude/skills/`
- `scope.py`            — scope guard (apex + wildcard + CIDR, exclusion-first); gate every new host through it
- `state.py`            — SQLite cross-session memory: hosts, endpoints, params, findings, dedup
- `hunt.sh`             — scope-gated recon pipeline (passive + active discovery → state.py)
- `crtname.sh`          — Certificate-Transparency subdomain discovery via crt.name
- `burp_client.py`      — Burp MCP fallback client: `python3 burp_client.py <tool> [json_args]`
- `mcp.sh` / `mcp2.sh`  — Burp MCP handshake helpers (SSE + sessionId)
- `mcp_fetch.py`        — routes raw HTTP requests through Burp via `send_http1_request`
- `recon.sh`            — recon environment/tool/network check + chain helper
- `tools.json`          — full Burp MCP `tools/list` dump
- `skills/`             — the skills library (see `skills/CATEGORY_MAP.md` and `skills/SKILL_INDEX.tsv`)

## Burp MCP notes
- Cleanest path: run Claude Code on the **same host as Burp** → `127.0.0.1:9876` works, Origin is naturally allowed (see `.mcp.json`).
- Cross-container fallback: Burp checks the `Host`/`Origin` header, so reach it at the Docker gateway `172.17.0.1:9876` and spoof `Host: localhost:9876`, `Origin: http://localhost:9876`. `burp_client.py` does exactly this dance.
- `GET /` → SSE `endpoint` event with `sessionId` → `POST /?sessionId=<id>`.
- Full wiring, Caido setup, and the DeepSeek side-brain: `ROUTER.md`.
