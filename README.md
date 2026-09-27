# bugbounty-toolkit

Personal bug-bounty toolkit for the PentAGI security assistant. Stores the
idempotent install script, full tool inventory, boot prompt, and the Burp MCP
client so a fresh (ephemeral) container can be restored in one command.

> Repo is **public** — clone with no token.

## Quick start (in any new PentAGI chat)
```bash
git clone --depth 1 https://github.com/themodernhacker/bugbounty-toolkit.git /work/kit
export PATH="$PATH:/root/go/bin:/usr/local/go/bin:/opt/venv/bin:/root/.local/bin"
bash /work/kit/setup.sh            # idempotent - skips installed tools
cat /work/kit/TOOL_INVENTORY.md    # full tool/path/wordlist inventory
```

## Files
- `setup.sh`            — idempotent install of the full bug-bounty toolset (corrected module paths)
- `TOOL_INVENTORY.md`   — every tool, binary path, wordlist, and gf pattern location
- `BOOTPROMPT.txt`      — the paste-in prompt that re-establishes full context + permissions
- `burp_client.py`      — Burp MCP client (27 tools): `python3 burp_client.py <tool> [json_args]`
- `mcp.sh` / `mcp2.sh`  — Burp MCP handshake helpers (SSE + sessionId)
- `mcp_fetch.py`        — routes raw HTTP requests through Burp via `send_http1_request`
- `recon.sh`            — recon chain helper
- `tools.json`          — full Burp MCP `tools/list` dump

## Burp MCP notes
- Host = `172.17.0.1:9876` (Docker gateway; NOT 127.0.0.1)
- Handshake headers: `Host: localhost:9876`, `Origin: http://localhost:9876`
- `GET /` -> SSE `endpoint` event with `sessionId` -> `POST /?sessionId=<id>`
