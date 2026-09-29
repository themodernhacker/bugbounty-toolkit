---
name: skill-author
description: >-
  How and when to capture a reusable technique as a NEW skill during a hunt, so
  the toolkit gets smarter every session. Load this whenever you discover a
  working technique, a target-specific trick, a custom script worth keeping, or a
  pattern from a disclosed report that isn't already covered by an existing skill.
  Keep it loaded across engagements — authoring skills is part of the job, not an
  afterthought.
---

# Skill-author — grow the toolkit as you hunt

A world-class hunter compounds knowledge: every non-obvious technique that works
becomes a reusable play. Your job is to notice those moments and write them down
as skills, immediately, so they load automatically next time.

## When to author a new skill
Create one when, during a hunt, you:
- find a technique that worked and **isn't already** an existing skill (check
  `ROUTER.md`, `CATEGORY_MAP.md`, and `grep -i "<kw>" skills/SKILL_INDEX.tsv` first
  — don't duplicate);
- write a custom script/one-liner you'd want again (bespoke signing, a param
  format, an auth dance);
- distil a pattern from a disclosed report (`skills/hackerone-reports/`) into a
  concrete, repeatable play;
- discover a target/stack-specific quirk worth remembering for that program.

Do **not** author a skill for one-off trivia, secrets/tokens, or anything
target-confidential — skills are techniques, not loot. Never paste credentials,
live tokens, or a specific target's private data into a skill.

## How to author (exact steps)
1. Pick a short slug and one-line description. Check it's not a duplicate.
2. Scaffold + link it in one command:
   ```bash
   bash new-skill.sh <slug> "<one-line description of the technique>"
   ```
   This creates `skills/learned-live/<slug>/SKILL.md` and symlinks it into
   `~/.claude/skills/` so it's discoverable immediately.
3. Fill the template with the **exact** commands, payloads, the response that
   confirmed it, how to escalate, how to validate (OOB proof for blind classes),
   and the concrete impact. Write it so a future session with no memory of this
   hunt could follow it cold.
4. Run `/reload-skills` in Claude Code so the edit takes effect this session.
5. If it generalises a class, add a row to `CATEGORY_MAP.md` / a line to
   `ROUTER.md` so the router points at it.

## Quality bar
- Concrete over vague: real flags, real payloads, real endpoints-shape (not the
  target's actual private URLs).
- One technique per skill; keep the description sharp so skill-selection stays good.
- Cite where it came from (a report link, your own hunt date).

## Housekeeping
New skills live in `skills/learned-live/`. Commit them with the rest of the repo
(`git add skills/learned-live && git commit`). They are yours — over time this
folder becomes your personal edge.
