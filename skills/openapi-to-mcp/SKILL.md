---
name: openapi-to-mcp
description: >-
  When a target exposes an OpenAPI/Swagger spec, turn it into a live MCP server so
  Claude Code can call every documented endpoint as a typed tool during testing —
  great for methodically probing REST APIs for BOLA/BFLA, mass assignment, and
  missing authz. Load when you find /swagger.json, /openapi.json, /v3/api-docs,
  or any API documentation on an in-scope target.
---

# Turn a target's OpenAPI spec into an MCP server (FastMCP)

An OpenAPI spec is a free map of the API's every route, method, param, and
schema. FastMCP can convert it into an MCP server in a few lines, giving the
agent a tool per operation. You then drive the whole API through Claude Code and
hunt authz/logic bugs systematically instead of guessing endpoints.

## Only do this for in-scope, authorised targets. Route all traffic through your
proxy (Burp) so every call is logged and rate-limited, and confirm scope first.

## Steps

1. Grab the spec (must be in scope):
   ```bash
   python3 scope.py check https://api.target.com/openapi.json && \
   curl -s https://api.target.com/openapi.json -o /tmp/target-openapi.json
   ```

2. Install FastMCP:
   ```bash
   pip install fastmcp httpx --break-system-packages
   ```

3. Generate + run the MCP server with the helper below. Point its base_url at the
   API, and set the proxy so traffic goes through Burp (127.0.0.1:8080), plus any
   auth header for the account you're testing with:
   ```bash
   export TARGET_API=https://api.target.com
   export HTTP_PROXY=http://127.0.0.1:8080        # log everything in Burp
   export AUTH_HEADER="Authorization: Bearer <low-priv-account-token>"
   python3 openapi_mcp.py /tmp/target-openapi.json
   ```

4. Register it in Claude Code (stdio):
   ```bash
   claude mcp add target-api -- python3 /full/path/openapi_mcp.py /tmp/target-openapi.json
   ```
   or add to `.mcp.json`:
   ```json
   "target-api": { "command": "python3",
     "args": ["/full/path/openapi_mcp.py", "/tmp/target-openapi.json"] }
   ```

5. Hunt: ask the agent to walk every operation with a low-priv token, then repeat
   with a second account and diff — that surfaces BOLA/BFLA and missing
   function-level authz fast. Combine with `class-skills/api-security`,
   `class-skills/idor`, and Caido Autorize.

## Helper: openapi_mcp.py
Save this next to the skill (also generated into `tools/openapi_mcp.py`):

```python
import os, sys, httpx
from fastmcp import FastMCP

spec_path = sys.argv[1]
base = os.environ["TARGET_API"]
headers = {}
if os.environ.get("AUTH_HEADER"):
    k, v = os.environ["AUTH_HEADER"].split(":", 1)
    headers[k.strip()] = v.strip()
proxy = os.environ.get("HTTP_PROXY")

client = httpx.AsyncClient(base_url=base, headers=headers,
                           proxy=proxy, verify=False, timeout=30)
import json
spec = json.load(open(spec_path))
mcp = FastMCP.from_openapi(openapi_spec=spec, client=client,
                           name="target-api")
if __name__ == "__main__":
    mcp.run()   # stdio transport for Claude Code
```

Notes: `verify=False` is for testing self-signed staging only; the proxy env
ensures every generated tool call is captured in Burp for manual follow-up. Tear
the server down when done, and never point it at out-of-scope hosts.
