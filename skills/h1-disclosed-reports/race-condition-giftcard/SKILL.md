---
name: race-condition-giftcard
description: Race condition redeeming a gift card multiple times (or duplicating credits/withdrawals) by firing parallel requests before balance is committed. Teaches TOCTOU/race testing of money flows.
sources: hackerone_public
report_count: 1
---

# Race Condition: redeem gift card / credit multiple times

**Report**: Reverb.com — "Race Condition redeems gift cards multiple times" (hackerone.com/reports/759247). Related: HackerOne 2FA bypass race (#2598548), duplicated payments (#220445), loyalty bonus race (Vend #331940).

## Why it matters (the new lesson)
Many "spend/consume" operations are check-then-act: verify balance, then debit. If two requests interleave between check and debit (TOCTOU), the same card/credit/2FA code is consumed multiple times. Parallelizing requests reveals these — a class that pays well on financial features.

## How it works
```http
POST /redeem  {code:"GC-123", amount:100}   # fire this N times in parallel
```
Server checks balance (valid), then debits; concurrent requests all pass the check before any debit lands → double-spend.

## How to hunt for it
1. Find single-use/redeem/withdraw/verify-code endpoints.
2. Fire 10–30 identical requests in parallel (same gift code, same 2FA code).
3. Check if the balance decreased by N× or by 1× (and whether all succeeded).

## Tooling
- Burp Intruder (parallel), `turbo intruder`/`race.py` (single-packet), Python `aiohttp`/`requests` threads, `ffuf`/`race`.

## Fix
Idempotency + atomic transactions; mark consumed in a single atomic DB update (`UPDATE ... WHERE status='unused'`); unique constraint on redemption.
