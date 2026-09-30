#!/usr/bin/env python3
import sys, json, re, os
# Import burp_client from this script's own directory, wherever the repo lives.
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from burp_client import BurpMCP

HOST = "ginandjuice.shop"
PORT = 443
HTTPS = True

def call_tool(name, args):
    c = BurpMCP()
    try:
        c.connect()
        return c.call("tools/call", {"name": name, "arguments": args})
    finally:
        c.close()

def fetch(path, extra_headers=None):
    headers = {"Host": HOST,
               "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
               "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
    if extra_headers:
        headers.update(extra_headers)
    hdr = "".join(f"{k}: {v}\r\n" for k, v in headers.items())
    content = f"GET {path} HTTP/1.1\r\n{hdr}\r\nConnection: close\r\n\r\n"
    res = call_tool("send_http1_request", {
        "content": content, "targetHostname": HOST, "targetPort": PORT, "usesHttps": HTTPS})
    try:
        txt = res["result"]["content"][0]["text"]
    except Exception:
        return None, res
    if "httpResponse=" in txt:
        resp = txt.split("httpResponse=", 1)[1]
        # split headers/body on first \r\n\r\n
        if "\r\n\r\n" in resp:
            head, body = resp.split("\r\n\r\n", 1)
            status = head.split("\r\n")[0]
            return {"status": status, "headers": head, "body": body}, res
        return {"status": resp.split("\r\n")[0], "headers": resp, "body": ""}, res
    return None, res

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "/vulnerabilities"
    # default: last_body.html in the current dir (git-ignored), overridable via arg or $BB_OUT
    out = sys.argv[2] if len(sys.argv) > 2 else os.environ.get("BB_OUT", "last_body.html")
    info, raw = fetch(path)
    if info is None:
        print("RAW:", json.dumps(raw)[:2000])
    else:
        open(out, "w").write(info["body"])
        print("STATUS:", info["status"])
        print("BODY LEN:", len(info["body"]))
        print("Saved to", out)
