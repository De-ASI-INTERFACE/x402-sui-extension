# x402-Sui Extension

**HTTP 402 Payment-Gated Routing on Sui**

**Author:** Richard Patterson (@De-ASI-INTERFACE)
**Version:** 1.0.0 | **Date:** 2026-07-09 | **License:** MIT

## Overview

The x402-Sui Extension adapts the x402 HTTP 402 payment standard to the Sui blockchain using Sui's object-centric Move VM, sponsored transactions, and zkLogin. It defines `scheme: sui-coin` for SUI and Coin<T> object payments, with DeepBook v3 as the canonical CLOB routing surface. Payment authorization uses Sui's ed25519/secp256k1/zkLogin signature schemes. Lean 4 formal proofs verify object ownership transfer, epoch-based expiry, and object ID replay prevention.

**Reference ID:** RP-DEASI-SUI-2026-0709-001
