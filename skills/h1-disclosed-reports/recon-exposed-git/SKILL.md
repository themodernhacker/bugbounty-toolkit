---
name: recon-exposed-git
description: Exposed .git directory (or source-download misconfig) → full source + secrets + commit history. Teaches .git enumeration, Dumper recovery, and nginx/php source-disclosure misconfigs.
sources: hackerone_public
report_count: 2
---

# Exposed .git / Source-Code Disclosure

**Reports**: Semrush — "Github information leaked" (hackerone.com/reports/676212, high); GSA — "Nginx misconfiguration leading to direct PHP source code download" (hackerone.com/reports/268382).

## Why it matters (the new lesson)
If `.git` is web-exposed, an attacker can `git-dumper`/`git clone` the entire repository (source + full history + hardcoded secrets). Similarly, misconfigured nginx/php (`try_files`, missing `fastcgi` pass) serves raw source instead of executing it. Source disclosure is the fastest path to deep, permanent bugs.

## How it works
```
curl -s https://target/.git/HEAD            # "ref: refs/heads/main" => exposed
curl -s https://target/.git/config
python3 git-dumper.py https://target/.git /out/
```
Nginx/PHP source leak: request a `.php` that isn't routed to php-fpm, or append `/index.php~`, `.bak`, `.swp`.

## How to hunt for it
1. Probe `/.git/HEAD`, `/.git/config`, `/.git/index`, `/.svn/entries`, `/.env`, `/.DS_Store`, `/.hg/`.
2. If present, dump with `git-dumper` / `dvcs-ripper`; grep history for secrets.
3. Fuzz common source/backup names: `index.php~`, `.php.bak`, `.php.swp`, `config.php.old`, `www.zip`, `backup.tar.gz`.

## Tooling
`git-dumper` (`arthaud/git-dumper`), `dvcs-ripper`, `gitleaks`/`trufflehog` on the recovered repo; nuclei `exposures/configs/`.

## Fix
Deny dotfile access; don't deploy `.git`; route all `.php` to FPM; remove backup/editor temp files.
