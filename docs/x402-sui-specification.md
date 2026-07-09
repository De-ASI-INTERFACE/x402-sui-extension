# x402-Sui: HTTP 402 Payment-Gated Routing Specification

**Author:** Richard Patterson (@De-ASI-INTERFACE)
**Version:** 1.0.0 | **Date:** 2026-07-09
**Reference ID:** RP-DEASI-SUI-2026-0709-001

## 1. Overview

Sui's object model requires a fundamentally different payment gate design: instead of approvals and allowances, payment is authorized by transferring a `Coin<T>` object to the Facilitator within the same programmable transaction block (PTB). The payment gate executes atomically inside the PTB before the swap call to DeepBook v3.

## 2. Payment Request Schema

```json
{
  "scheme": "sui-coin",
  "network": "mainnet",
  "coinType": "0x2::sui::SUI",
  "amount": "<u64-mist>",
  "facilitatorAddress": "0x<sui-address>",
  "paymentObjectId": "0x<coin-object-id>",
  "expiresAtEpoch": "<u64-epoch-number>",
  "nonce": "<u64-unique>",
  "signature": "<sui-ed25519-or-zk-login-sig>"
}
```

## 3. Move PTB Payment Gate (Pseudocode)

```move
public fun pay_and_route<T>(
    payment: Coin<T>,
    auth: PaymentAuth,
    facilitator: &mut Facilitator,
    clock: &Clock,
    ctx: &mut TxContext
) {
    assert!(clock::epoch(clock) <= auth.expires_at_epoch, EPaymentExpired);
    assert!(!table::contains(&facilitator.used_nonces, auth.nonce), ENonceReplayed);
    assert!(coin::value(&payment) >= auth.amount, EInsufficientPayment);
    table::add(&mut facilitator.used_nonces, auth.nonce, true);
    transfer::public_transfer(payment, facilitator.treasury);
}
```

## 4. Sui-Specific Invariants

1. **Atomic PTB Execution:** Payment and swap execute in same transaction; partial execution is impossible
2. **Object ID Uniqueness:** `Coin<T>` object ID is globally unique; consumed objects cannot be replayed
3. **Epoch Expiry:** `clock::epoch(clock) <= expiresAtEpoch` checked at execution time
4. **zkLogin Support:** Facilitator accepts zkLogin proofs as valid payment authorization
5. **Sponsored Transactions:** Gas sponsorship allows gasless payment authorization for end users

## 5. Attribution
Originated and authored by Richard Patterson (@De-ASI-INTERFACE), 2026-07-09.
