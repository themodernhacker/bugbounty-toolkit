---
name: business-logic-negative-quantity
description: Price/order manipulation using negative quantities, decimals, and rounding to get items free or manipulate totals. Teaches numeric edge-case fuzzing of checkout/order APIs.
sources: hackerone_public
report_count: 1
---

# Business Logic: negative quantity / price manipulation

**Report**: Upserve — "OLO Total price manipulation using negative quantities" (hackerone.com/reports/364843). Related: Reverb gift-card race (#759247), Ethereum balance manipulation (Coinbase #300748).

## Why it matters (the new lesson)
Order totals are often computed client-side or with naive arithmetic (`price * qty + fee`) that doesn't handle negative/zero/overflow/rounding values. Fuzzing numeric fields (quantity, price, tip, discount, currency amount) with edge cases yields free items, negative totals, or bypassed limits.

## How it works
```http
POST /order  {"items":[{"id":1,"qty":-1,"price":100}], "tip":-50}
```
A negative quantity or a negative tip/discount drives the computed total below the intended amount (or refunds money).

## How to hunt for it
1. Place an order and capture the checkout API calls.
2. Fuzz each numeric field: `-1`, `-100`, `0`, `0.0000001`, `1e9`, `2147483648`, `NaN`, `Infinity`, negative discounts/tips/taxes.
3. Watch the computed total, and any coupons/loyalty/credit fields.

## Payloads
```
qty: -1, -5, 0, 1.5, 2.999999999
price/tip/discount: -100, 999999999999, -0.01
```

## Fix
Server-side total calculation; validate numeric ranges (integers, positive, bounded); round consistently; never trust client-computed totals.
