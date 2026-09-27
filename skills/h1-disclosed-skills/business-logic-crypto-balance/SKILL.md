---
name: business-logic-crypto-balance
description: Manipulating an Ethereum/crypto account balance through a numeric/logic flaw in a wallet or exchange. Teaches financial-assertion testing (invariant checks) for wallet/exchange logic.
sources: hackerone_public
report_count: 1
---

# Business Logic: account balance manipulation (crypto)

**Report**: Coinbase — "Ethereum account balance manipulation" (hackerone.com/reports/300748). Related: streamlabs free-prime response manipulation (Logitech #1070510).

## Why it matters (the new lesson)
Money systems must preserve invariants (sum of balances = total supply; debits ≤ credits). Flaws let you inflate balances, double-spend, or withdraw more than deposited. Test the *invariants*, not just input validation.

## How it works
A rounding, off-by-one, race, or unsigned-integer issue lets a balance exceed what was deposited, or a transfer update the wrong ledger entry, so the attacker withdraws value that never existed.

## How to hunt for it
1. Identify wallet/exchange "deposit", "withdraw", "transfer", "convert" flows.
2. Fuzz amounts: tiny fractions, repeated identical transfers, maximum/overflow values, negative.
3. Check the ledger invariant: after N operations, does the account balance match the sum of credits minus debits?

## Payloads
```
amount: 0.000000000000000001, 1e18, 2^256-1, -1, duplicate transfer ids
```

## Fix
Use integer/uint arithmetic; enforce invariant checks; idempotent transfers; concurrency-safe ledger updates.
