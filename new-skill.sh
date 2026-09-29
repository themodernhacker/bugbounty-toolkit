#!/usr/bin/env bash
# new-skill.sh — scaffold a learned-live skill and link it into ~/.claude/skills/.
# Usage: bash new-skill.sh <slug> "<one-line description>"
# Never put credentials, live tokens, or a target's private data in a skill — techniques only.
set -eu
SLUG="${1:?usage: new-skill.sh <slug> \"<description>\"}"
DESC="${2:-}"
[ -n "$DESC" ] || { echo "usage: new-skill.sh <slug> \"<description>\"" >&2; exit 1; }

# normalise slug: lowercase, spaces->dashes, strip anything but [a-z0-9-]
SLUG="$(printf '%s' "$SLUG" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')"
[ -n "$SLUG" ] || { echo "empty slug after normalisation" >&2; exit 1; }

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$REPO/skills/learned-live/$SLUG"
FILE="$DIR/SKILL.md"
if [ -e "$FILE" ]; then echo "already exists: $FILE" >&2; exit 1; fi
mkdir -p "$DIR"

cat > "$FILE" <<SKILL
---
name: $SLUG
description: $DESC
collection: learned-live
---

# $SLUG

$DESC

## When to load
<!-- the exact target signal that should trigger this skill -->

## Method
<!-- minimal, reproducible commands / requests -->

## Confirming response
<!-- what a positive result looks like (status, header, body marker, OOB hit) -->

## Escalation / chain
<!-- what this chains into and the real impact -->

## Validation
<!-- reproduce from a clean session/account; rule out false positives -->
SKILL

# link into ~/.claude/skills/ so Claude Code discovers it live
LINKDIR="$HOME/.claude/skills"
mkdir -p "$LINKDIR"
ln -sfn "$DIR" "$LINKDIR/$SLUG"

echo "[ok] created $FILE"
echo "[ok] linked  $LINKDIR/$SLUG -> $DIR"
echo "Fill it in, then run /reload-skills in Claude Code. Add a ROUTER.md / CATEGORY_MAP.md line if it generalises."
