#!/usr/bin/env bash
# install-caido.sh — install/build the Caido MCP server (c0tton-fluff/caido-mcp-server)
# into ~/go/bin so .mcp.json can launch `caido-mcp-server serve`. Idempotent.
set -u
PREFIX="${BB_PREFIX:-$HOME}"
BIN="$PREFIX/go/bin/caido-mcp-server"
REPO_URL="${CAIDO_MCP_REPO:-https://github.com/c0tton-fluff/caido-mcp-server.git}"
SRC="$PREFIX/tools/caido-mcp-server"

export PATH="$PREFIX/go/bin:/usr/local/go/bin:$PATH"
mkdir -p "$PREFIX/go/bin" "$PREFIX/tools"

if command -v caido-mcp-server >/dev/null 2>&1 || [ -x "$BIN" ]; then
  echo "[ok] caido-mcp-server already installed: $(command -v caido-mcp-server || echo "$BIN")"
  exit 0
fi

if ! command -v go >/dev/null 2>&1; then
  echo "[FAIL] Go toolchain not found — install Go first (apt-get install -y golang-go)." >&2
  exit 1
fi

echo "[build] fetching + building caido-mcp-server from $REPO_URL"
if [ -d "$SRC/.git" ]; then git -C "$SRC" pull --ff-only || true
else git clone --depth 1 "$REPO_URL" "$SRC" || { echo "[FAIL] clone failed" >&2; exit 1; }
fi

# Build whatever main package the repo exposes (root or ./cmd/...).
( cd "$SRC" && go build -o "$BIN" ./... 2>/dev/null ) || \
( cd "$SRC" && go build -o "$BIN" . 2>/dev/null ) || true

if [ ! -x "$BIN" ]; then
  echo "[FAIL] build did not produce $BIN — check the repo's build instructions." >&2
  exit 1
fi
echo "[ok] built $BIN"
echo "Next: authenticate once with 'caido-mcp-server login' (OAuth) or export CAIDO_ACCESS_TOKEN."
