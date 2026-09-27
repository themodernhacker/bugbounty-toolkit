#!/bin/bash
# Minimal MCP SSE+POST client for Burp MCP server
BASE="http://172.17.0.1:9876"
HOST="localhost:9876"
ORIGIN="http://localhost:9876"

# 1) Get session id from SSE endpoint
SSE=$(curl -s -m 5 "$BASE/" -H "Host: $HOST" -H "Origin: $ORIGIN" -H "Accept: text/event-stream")
echo "SSE response: [$SSE]"
SID=$(echo "$SSE" | sed -n 's/.*sessionId=\([^& ]*\).*/\1/p' | head -1)
echo "sessionId = $SID"
[ -z "$SID" ] && { echo "NO SESSION"; exit 1; }

# 2) POST initialize
echo "--- initialize ---"
curl -s -i -m 6 -X POST "$BASE/?sessionId=$SID" -H "Host: $HOST" -H "Origin: $ORIGIN" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"pa","version":"1.0"}}}'
