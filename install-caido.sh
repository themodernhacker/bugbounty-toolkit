#!/usr/bin/env bash
# install-caido.sh — install & authenticate the Caido MCP server for Claude Code.
# Server: https://github.com/c0tton-fluff/caido-mcp-server  (67 tools, 6 resources)
# The local Caido app must be running and reachable at CAIDO_URL.
set -euo pipefail

CAIDO_URL="${CAIDO_URL:-http://127.0.0.1:8080}"

echo "==> Checking for caido-mcp-server ..."
if command -v caido-mcp-server >/dev/null 2>&1; then
  echo "    [ok] already installed: $(command -v caido-mcp-server)"
else
  echo "    [..] installing caido-mcp-server ..."
  if command -v go >/dev/null 2>&1; then
    go install github.com/c0tton-fluff/caido-mcp-server/v4/cmd/caido-mcp-server@latest
    echo "    [ok] installed to $(go env GOPATH)/bin/caido-mcp-server"
  else
    echo "    [..] no 'go' found, using install.sh ..."
    curl -fsSL https://raw.githubusercontent.com/c0tton-fluff/caido-mcp-server/main/install.sh | bash
  fi
  export PATH="$PATH:$(go env GOPATH 2>/dev/null || echo $HOME/go)/bin"
fi

echo "==> (optional) installing caido-cli (standalone replay CLI) ..."
if ! command -v caido-cli >/dev/null 2>&1 && command -v go >/dev/null 2>&1; then
  go install github.com/c0tton-fluff/caido-mcp-server/v4/cmd/caido-cli@latest
  echo "    [ok] caido-cli installed"
fi

echo
echo "==> Verify binary"
caido-mcp-server --version 2>/dev/null || echo "    (run 'caido-mcp-server --version' manually to confirm)"

cat <<MSG

==> AUTHENTICATION (do ONE)
   Option A (recommended, long-lived + auto-refresh — OAuth device flow):
       caido-mcp-server login        # opens a browser, saves token to ~/.caido-mcp/tokens/

   Option B (static token, expires ~7 days):
       1. Caido GUI -> DevTools (Ctrl+Shift+I) -> Console tab
       2. Run:  JSON.parse(localStorage.CAIDO_AUTHENTICATION).accessToken
       3. export CAIDO_ACCESS_TOKEN="<that-value>" before Claude Code starts

==> NEXT STEPS
   1. Ensure Caido is running at ${CAIDO_URL}
   2. bash link-skills.sh      # link core skills + build index
   3. claude                    # from repo root (auto-loads CLAUDE.md + .mcp.json)

   Sanity test once auth'd:  caido-cli status -u ${CAIDO_URL}
MSG
