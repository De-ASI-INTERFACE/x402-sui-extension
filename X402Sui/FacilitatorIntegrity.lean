-- ============================================================
-- x402-Sui: Facilitator State Integrity
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- ============================================================
import Mathlib.Data.Finset.Basic
import X402Sui.PaymentVerification

namespace X402Sui.Facilitator

theorem nonces_monotone (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    s.settled_digests ⊆ (settle a s).settled_digests := by simp [settle]; exact Finset.subset_union_left

theorem fresh_not_in_pre_state (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.tx_digest ∉ s.settled_digests := replay_prevented a s h

structure TimeStep where
  s_before : FacilitatorState; s_after : FacilitatorState
  mono : s_before.epoch_time ≤ s_after.epoch_time

theorem expiry_is_monotone (a : PaymentAuth) (ts : TimeStep) (h_valid : not_expired a ts.s_before) :
    ts.s_before.epoch_time ≤ a.expires_at := h_valid

end X402Sui.Facilitator
