#!/usr/bin/env python3
import json, sys, threading, time, urllib.request, urllib.error

BASE = "http://172.17.0.1:9876"
HOST = "localhost:9876"
ORIGIN = "http://localhost:9876"

def http_req(method, url, headers, body=None, timeout=8):
    req = urllib.request.Request(url, method=method)
    for k, v in headers.items():
        req.add_header(k, v)
    data = body.encode() if body else None
    try:
        with urllib.request.urlopen(req, data=data, timeout=timeout) as r:
            return r.status, r.headers, r.read().decode(errors="replace")
    except urllib.error.HTTPError as e:
        return e.code, e.headers, e.read().decode(errors="replace")
    except Exception as e:
        return None, {}, str(e)

class BurpMCP:
    def __init__(self):
        self.sid = None
        self.responses = {}
        self._stop = threading.Event()

    def _read_sse(self):
        req = urllib.request.Request(BASE + "/", method="GET")
        req.add_header("Host", HOST)
        req.add_header("Origin", ORIGIN)
        req.add_header("Accept", "text/event-stream")
        req.add_header("Cache-Control", "no-cache")
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                buf = ""
                while not self._stop.is_set():
                    chunk = r.read(1).decode(errors="replace")
                    if not chunk:
                        break
                    buf += chunk
                    buf = buf.replace("\r\n", "\n")
                    while "\n\n" in buf:
                        block, buf = buf.split("\n\n", 1)
                        ev = None; data = None
                        for line in block.split("\n"):
                            if line.startswith("event:"):
                                ev = line[6:].strip()
                            elif line.startswith("data:"):
                                data = line[5:].strip()
                        if ev == "endpoint" and data:
                            self.sid = data.split("sessionId=")[-1].strip()
                        elif ev == "message" and data:
                            try:
                                msg = json.loads(data)
                                if "id" in msg:
                                    self.responses[msg["id"]] = msg
                            except Exception:
                                pass
        except Exception:
            pass

    def connect(self):
        t = threading.Thread(target=self._read_sse, daemon=True)
        t.start()
        for _ in range(30):
            if self.sid:
                return self.sid
            time.sleep(0.1)
        raise RuntimeError("no sessionId obtained from SSE stream")

    def call(self, method, params=None, rpc_id=1, timeout=15):
        params = params or {}
        body = json.dumps({"jsonrpc": "2.0", "id": rpc_id, "method": method, "params": params})
        url = f"{BASE}/?sessionId={self.sid}"
        headers = {"Host": HOST, "Origin": ORIGIN, "Content-Type": "application/json",
                   "Accept": "application/json, text/event-stream"}
        self.responses.pop(rpc_id, None)
        status, hdr, resp = http_req("POST", url, headers, body)
        deadline = time.time() + timeout
        while time.time() < deadline:
            if rpc_id in self.responses:
                return self.responses.pop(rpc_id)
            time.sleep(0.1)
        return {"_error": "timeout", "_post_status": status, "_post_body": resp}

    def close(self):
        self._stop.set()

def main():
    if len(sys.argv) < 2:
        print("usage: python3 burp_client.py <tool_name> [json_args]"); sys.exit(1)
    tool = sys.argv[1]
    args = {}
    if len(sys.argv) > 2:
        args = json.loads(sys.argv[2])
    c = BurpMCP()
    try:
        c.connect()
        if tool == "initialize":
            res = c.call("initialize", {"protocolVersion": "2024-11-05", "capabilities": {},
                        "clientInfo": {"name": "pa", "version": "1.0"}})
        elif tool == "tools/list":
            res = c.call("tools/list")
        else:
            res = c.call("tools/call", {"name": tool, "arguments": args})
        print(json.dumps(res, indent=2))
    finally:
        c.close()

if __name__ == "__main__":
    main()
