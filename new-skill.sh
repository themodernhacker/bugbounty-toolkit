#!/usr/bin/env bash
# new-skill.sh — scaffold a new skill and link it into Claude Code immediately.
# Used by the agent (and you) to capture a reusable technique DURING a hunt so it
# is available in this and every future session.
#
#   bash new-skill.sh <slug> "<one-line description>"
#   # then edit skills/learned-live/<slug>/SKILL.md with the technique
#
# It creates skills/learned-live/<slug>/SKILL.md and symlinks it into
# ~/.claude/skills/ so it loads without a restart ( /reload-skills picks up edits ).
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
slug="${1:?usage: new-skill.sh <slug> \"<description>\"}"
desc="${2:-Captured technique: $slug}"
dir="$REPO/skills/learned-live/$slug"
mkdir -p "$dir"
if [ ! -f "$dir/SKILL.md" ]; then
cat > "$dir/SKILL.md" <<EOF
---
name: $slug
description: >-
  $desc Load when the current target matches this pattern. Captured during a live
  hunt on $(date -u '+%Y-%m-%d'); refine as you learn more.
---

# $slug

## When this applies
<what target signal / behaviour triggers this technique>

## Steps that worked
1. <exact request / tool / payload>
2. <what response confirmed it>
3. <how to escalate / prove impact>

## Tools / commands
\`\`\`bash
<the exact commands, with real flags>
\`\`\`

## Validation & impact
<how to reproduce cleanly, OOB proof if blind, concrete impact>

## References
<disclosed reports / notes this came from>
EOF
fi
CLAUDE_SKILLS="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$CLAUDE_SKILLS"
ln -sfn "$dir" "$CLAUDE_SKILLS/$slug"
echo "[ok] created $dir/SKILL.md and linked into $CLAUDE_SKILLS"
echo "     edit it with the technique, then it's live (run /reload-skills in Claude Code)."
