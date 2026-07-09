-- x402-Sui Basic | Author: Richard Patterson (@De-ASI-INTERFACE)
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Basic

namespace X402Sui

structure PaymentAuth where
  tx_digest  : Nat  -- hash of PTB digest
  amount     : Nat
  expires_at : Nat
  deriving Repr, DecidableEq

structure FacilitatorState where
  settled_digests : Finset Nat
  epoch_time      : Nat
  deriving Repr

def verify (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.tx_digest ∉ s.settled_digests ∧ s.epoch_time ≤ a.expires_at

theorem sui_replay_prevented (a : PaymentAuth) (s : FacilitatorState) (h : verify a s)
    : a.tx_digest ∉ s.settled_digests := h.1

theorem sui_not_expired (a : PaymentAuth) (s : FacilitatorState) (h : verify a s)
    : s.epoch_time ≤ a.expires_at := h.2

end X402Sui
