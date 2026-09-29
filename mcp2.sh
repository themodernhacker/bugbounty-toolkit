#!/bin/bash
BASE="http://172.17.0.1:9876"
HOST="localhost:9876"
ORIGIN="http://localhost:9876"
OUT="${TMPDIR:-/tmp}/bbt-sse.log"
rm -f "$OUT"

# 1) Open SSE stream in background (long-lived)
curl -sN -m 12 "$BASE/" -H "Host: $HOST" -H "Origin: $ORIGIN" -H "Accept: text/event-stream" > "$OUT" 2>&1 &
CURLPID=$!
sleep 1

# 2) Extract session id
SID=$(sed -n 's/.*sessionId=\([^&[:space:]]*\).*/\1/p' "$OUT" | head -1)
echo "sessionId = $SID"
[ -z "$SID" ] && { echo "no sessionId — is Burp MCP up on $BASE?"; kill $CURLPID 2>/dev/null; exit 1; }

# 3) POST initialize
echo "--- POST initialize ---"
curl -s -m 6 -X POST "$BASE/?sessionId=$SID" -H "Host: $HOST" -H "Origin: $ORIGIN" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"pa","version":"1.0"}}}'
echo "[POST done, http=$?]"

# 4) notifications/initialized
curl -s -m 6 -X POST "$BASE/?sessionId=$SID" -H "Host: $HOST" -H "Origin: $ORIGIN" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'
echo "[initialized sent]"

# 5) tools/list
curl -s -m 6 -X POST "$BASE/?sessionId=$SID" -H "Host: $HOST" -H "Origin: $ORIGIN" \
  -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'
echo "[tools/list sent]"

sleep 3
kill $CURLPID 2>/dev/null
echo "======== SSE STREAM CONTENT ========"
cat "$OUT"
