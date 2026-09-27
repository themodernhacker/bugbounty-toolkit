---
name: rce-git-flag-injection
description: Git flag injection — a filename starting with '-' is passed to git as an option, enabling local file overwrite and RCE. Teaches argument/flag injection into subprocess command lines.
sources: hackerone_public
report_count: 1
---

# RCE via Git flag injection (filename → argument)

**Report**: GitLab — "Git flag injection – local file overwrite to RCE" (hackerone.com/reports/658013). Related: ExifTool metadata RCE (GitLab #1154542), Kramdown options RCE (#1125425).

## Why it matters (the new lesson)
When an app shells out to a CLI (`git`, `tar`, `curl`, `ffmpeg`, `exiftool`) and interpolates attacker data *without a `--` separator or proper quoting*, a value beginning with `-` is parsed as a **flag**, not a value. This is argument injection — a whole class separate from command injection (no shell metacharacters needed).

## How it works
```sh
git commit -m "$filename"        # filename = "--help" or an option
```
If a filename is `--output=...` or a git option that writes files, the attacker controls an option. In GitLab's case a crafted repo/file name let the attacker overwrite `.git/config`/hooks → then a hook runs → RCE.

## How to hunt for it
1. Find subprocess calls with user input (file names, repo names, branch names).
2. Check for missing `--` (end-of-options) separator or missing quoting.
3. Inject `-`-prefixed values and observe option parsing (`--help`, `--version`, `--output=/tmp/x`).

## Payloads (per tool)
```
git:   --output=/path/to/hook  (overwrite)  ;  --upload-pack=<cmd>
tar:   --checkpoint=1 --checkpoint-action=exec=<cmd>
curl:  -o /path  / --output
ffmpeg/convert:  -f  /  -write
```

## Fix
Always use `--` before user values when calling CLIs that accept options; avoid shells; use exec-array APIs (no shell string).
