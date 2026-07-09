-- ============================================================
-- x402-Sui: Basic Re-export Shim
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- Chain: Sui / SUI Coin / Cetus Protocol
--
-- Re-exports X402Sui.PaymentVerification as the single
-- authoritative source of all shared types and definitions.
-- Chain-prefixed theorem aliases are provided for ergonomic use.
-- ============================================================
import X402Sui.PaymentVerification

namespace X402Sui

/-- Alias: replay prevention under the Sui chain prefix.
    Delegates to replay_prevented; result type matches
    nonce_fresh: a.tx_digest ∉ s.settled_digests. -/
theorem sui_replay_prevented
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.tx_digest ∉ s.settled_digests :=
  replay_prevented a s h

/-- Alias: expiry enforcement under the Sui chain prefix.
    Delegates to within_expiry; result type matches
    not_expired: s.epoch_time ≤ a.expires_at. -/
theorem sui_not_expired
    (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    s.epoch_time ≤ a.expires_at :=
  within_expiry a s h

end X402Sui
