#!/usr/bin/env bash
# crtname.sh — Certificate Transparency subdomain source via crt.name
# (crt.sh replacement). Returns one hostname per line for an apex domain.
#
#   bash crtname.sh example.com                 # print subdomains
#   bash crtname.sh example.com | anew subs.txt # merge into a file
#   bash crtname.sh example.com | python3 scope.py filter   # keep in-scope only
#
# Endpoint format: https://crt.name/v1/search?apex=<domain>  (plain text list)
set -euo pipefail
apex="${1:?usage: crtname.sh <apex-domain>}"
curl -s --max-time 30 "https://crt.name/v1/search?apex=${apex}" \
  | tr 'A-Z' 'a-z' | grep -E "(^|\.)${apex//./\\.}$" | sort -u
