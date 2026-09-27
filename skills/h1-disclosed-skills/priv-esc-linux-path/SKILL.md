---
name: priv-esc-linux-path
description: Linux privilege escalation via trusted $PATH hijacking — a privileged binary calls a command by name, and you control PATH or CWD. Teaches $PATH/relative-command priv-esc.
sources: hackerone_public
report_count: 1
---

# Linux Privilege Escalation via Trusted $PATH

**Report**: Keybase — "Linux privilege escalation via trusted $PATH in keybase-redirector" (#426944, $5,000).

## Why it matters (the new lesson)
A setuid/privileged helper that calls a command *by name* (relying on `$PATH`) can be hijacked: place a malicious `whoami`/`curl`/`tar` earlier in `$PATH` (or use relative paths / `./`) and the privileged process executes your code. This is a classic and still-common local priv-esc.

## How it works
1. A root/privileged process invokes `system("tar ...")` or `execvp("git", ...)`.
2. Attacker writes `~/evil/tar` (or `./tar`) and prepends `~/evil` to `$PATH`.
3. Privileged process runs the attacker binary as root.

## How to hunt for it
1. Find setuid binaries / privileged daemons and their subprocess calls (`strace`, `strings`, `ldd`).
2. Check for relative paths or `$PATH`-resolved commands.
3. Prepend a writable dir with a malicious same-named binary; trigger it.

## Payloads / flow
```
export PATH=/tmp:$PATH
echo -e '#!/bin/sh\n/bin/sh' > /tmp/tar && chmod +x /tmp/tar
# trigger the privileged process that calls `tar`
```

## Fix
Use absolute paths; sanitize `$PATH`/`$CWD` before exec; drop privileges; don't call external binaries from setuid code.
