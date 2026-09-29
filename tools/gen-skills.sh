#!/usr/bin/env bash
# gen-skills.sh — build the hackerone-reports skills, then reindex.
#
# 1. Clone (or update) reddelexc/hackerone-reports into ./.h1src
# 2. Run gen_h1_skills.py -> skills/hackerone-reports/h1-*/SKILL.md
# 3. Rebuild skills/SKILL_INDEX.tsv via link-skills.sh --index
#
# Re-run any time to refresh from newly disclosed reports. Idempotent.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO/.h1src"
UP="https://github.com/reddelexc/hackerone-reports"

if [[ -d "$SRC/.git" ]]; then
  echo "[*] Updating $SRC"
  git -C "$SRC" pull --ff-only --depth 1 2>/dev/null || echo "  (pull skipped)"
else
  echo "[*] Cloning $UP -> .h1src (shallow)"
  GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 "$UP" "$SRC"
fi

python3 "$REPO/tools/gen_h1_skills.py" "$SRC"
bash "$REPO/link-skills.sh" --index
echo "[*] Done. New skills are in skills/hackerone-reports/ and indexed in skills/SKILL_INDEX.tsv"
