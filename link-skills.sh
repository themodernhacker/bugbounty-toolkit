#!/usr/bin/env bash
# link-skills.sh — wire the bug-bounty skills into Claude Code.
#
# Strategy (why not link all 329?):
#   Claude Code loads EVERY skill's frontmatter description into context at
#   startup. 329 descriptions = huge context + degraded skill selection. So we
#   symlink only a CURATED CORE (~42) for always-on discovery, and generate a
#   grep-able index of ALL skills so the agent can load the other ~290 on demand
#   (see CLAUDE.md §4).
#
# Usage:
#   bash link-skills.sh            # link core + (re)build index
#   bash link-skills.sh --index    # only rebuild skills/SKILL_INDEX.tsv
#   bash link-skills.sh --unlink   # remove the core symlinks again
#
# Idempotent. Safe to re-run.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO/skills"
CLAUDE_SKILLS="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
INDEX="$SKILLS_SRC/SKILL_INDEX.tsv"

# --- Curated core: collection/skill (unique names, no collisions) -------------
CORE=(
  # recon & process
  claude-bughunter/recon-scope-triage
  claude-bughunter/osint-methodology
  claude-bughunter/bb-methodology
  claude-bughunter/triage-validation
  claude-bughunter/evidence-hygiene
  claude-bughunter/report-writing
  claude-bughunter/bugcrowd-reporting
  claude-bughunter/security-arsenal
  agentic-bug-hunter/web2-recon
  # top web vuln classes
  claude-bughunter/hunt-xss
  claude-bughunter/hunt-sqli
  claude-bughunter/hunt-ssrf
  claude-bughunter/hunt-ssti
  claude-bughunter/hunt-xxe
  claude-bughunter/hunt-idor
  claude-bughunter/hunt-lfi
  claude-bughunter/hunt-rce
  claude-bughunter/hunt-csrf
  claude-bughunter/hunt-cors
  claude-bughunter/hunt-open-redirect
  claude-bughunter/hunt-auth-bypass
  claude-bughunter/hunt-jwt-crypto
  claude-bughunter/hunt-oauth
  claude-bughunter/hunt-business-logic
  claude-bughunter/hunt-race-condition
  claude-bughunter/hunt-file-upload
  claude-bughunter/hunt-graphql
  claude-bughunter/hunt-api-misconfig
  claude-bughunter/hunt-deserialization
  claude-bughunter/hunt-http-smuggling
  claude-bughunter/hunt-cache-poison
  claude-bughunter/hunt-subdomain
  claude-bughunter/hunt-nosqli
  claude-bughunter/hunt-host-header
  claude-bughunter/hunt-clickjacking
  claude-bughunter/hunt-ato
  claude-bughunter/hunt-mfa-bypass
  claude-bughunter/hunt-llm-ai
  claude-bughunter/hunt-source-leak
  claude-bughunter/hunt-shadow-api
  claude-bughunter/hunt-cloud-misconfig
  claude-bughunter/hunt-k8s
  # capability skills (top-level, not under a collection)
  openapi-to-mcp
  skill-author
)

build_index() {
  echo "[*] Building skill index -> ${INDEX#$REPO/}"
  : > "$INDEX"
  # name <TAB> collection <TAB> path <TAB> description(one line)
  find "$SKILLS_SRC" -mindepth 3 -maxdepth 3 -name SKILL.md 2>/dev/null | sort | while read -r f; do
    rel="${f#$REPO/}"
    coll="$(basename "$(dirname "$(dirname "$f")")")"
    awk '
      BEGIN{infm=0; name=""; desc=""; grabbing=0}
      /^---[[:space:]]*$/ { infm++; if(infm==2) exit; next }
      infm==1 {
        if ($0 ~ /^name:[[:space:]]*/)        { sub(/^name:[[:space:]]*/,""); gsub(/^["'"'"']|["'"'"']$/,""); name=$0; grabbing=0 }
        else if ($0 ~ /^description:[[:space:]]*/) { sub(/^description:[[:space:]]*/,""); gsub(/^[>|]-?[[:space:]]*/,""); desc=$0; grabbing=1 }
        else if (grabbing==1 && $0 ~ /^[[:space:]]+[^[:space:]]/) { sub(/^[[:space:]]+/," "); desc=desc $0 }
        else if ($0 ~ /^[a-zA-Z_]+:/) { grabbing=0 }
      }
      END{
        gsub(/\t/," ",desc); gsub(/  +/," ",desc);
        if(length(desc)>220) desc=substr(desc,1,217) "...";
        printf "%s\t%s\t%s\t%s\n", name, COLL, REL, desc
      }
    ' COLL="$coll" REL="$rel" "$f" >> "$INDEX"
  done
  echo "[*] Indexed $(wc -l < "$INDEX") skills."
}

link_core() {
  mkdir -p "$CLAUDE_SKILLS"
  local linked=0 missing=0 skipped=0
  for entry in "${CORE[@]}"; do
    local src="$SKILLS_SRC/$entry"
    local name="$(basename "$entry")"
    local dst="$CLAUDE_SKILLS/$name"
    if [[ ! -f "$src/SKILL.md" ]]; then
      echo "  ! missing: $entry"; missing=$((missing+1)); continue
    fi
    if [[ -e "$dst" && ! -L "$dst" ]]; then
      echo "  ~ skip (real dir exists, not a symlink): $name"; skipped=$((skipped+1)); continue
    fi
    ln -sfn "$src" "$dst"
    linked=$((linked+1))
  done
  echo "[*] Core skills -> $CLAUDE_SKILLS : linked=$linked missing=$missing skipped=$skipped"
}

unlink_core() {
  for entry in "${CORE[@]}"; do
    local name="$(basename "$entry")"
    local dst="$CLAUDE_SKILLS/$name"
    [[ -L "$dst" ]] && rm -f "$dst" && echo "  - unlinked $name"
  done
  echo "[*] Core symlinks removed from $CLAUDE_SKILLS"
}

case "${1:-}" in
  --index)  build_index ;;
  --unlink) unlink_core ;;
  "" )      link_core; build_index
            echo
            echo "Done. Core skills are auto-discovered by Claude Code."
            echo "On-demand: grep -i '<keyword>' ${INDEX#$REPO/} , then cat the matching SKILL.md"
            ;;
  * ) echo "usage: bash link-skills.sh [--index|--unlink]"; exit 1 ;;
esac
