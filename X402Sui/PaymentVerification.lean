-- ============================================================
-- x402-Sui: Payment Verification Formal Proofs
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- Chain: Sui / SUI Coin / Cetus Protocol
-- ============================================================
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Basic
import Mathlib.Logic.Basic

namespace X402Sui

structure PaymentAuth where
  tx_digest  : Nat    -- PTB transaction digest
  amount     : Nat    -- MIST (SUI base units)
  expires_at : Nat    -- epoch timestamp
  coin_type  : Nat    -- Sui Coin<T> type identifier
  deriving Repr, DecidableEq

structure FacilitatorState where
  settled_digests : Finset Nat
  epoch_time      : Nat
  deriving Repr

def not_expired (a : PaymentAuth) (s : FacilitatorState) : Prop := s.epoch_time ≤ a.expires_at
def nonce_fresh (a : PaymentAuth) (s : FacilitatorState) : Prop := a.tx_digest ∉ s.settled_digests
def amount_positive (a : PaymentAuth) : Prop := 0 < a.amount
def verify (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  not_expired a s ∧ nonce_fresh a s ∧ amount_positive a

theorem replay_prevented (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) : a.tx_digest ∉ s.settled_digests := h.2.1
theorem within_expiry (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) : s.epoch_time ≤ a.expires_at := h.1
theorem positive_amount (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) : 0 < a.amount := h.2.2

def settle (a : PaymentAuth) (s : FacilitatorState) : FacilitatorState :=
  { s with settled_digests := s.settled_digests ∪ {a.tx_digest} }

theorem settled_nonce_used (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.tx_digest ∈ (settle a s).settled_digests := by
  simp [settle, Finset.mem_union, Finset.mem_singleton]

theorem post_settlement_replay_blocked (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) :
    a.tx_digest ∈ (settle a s).settled_digests ∧ ¬a.tx_digest ∉ (settle a s).settled_digests := by
  constructor
  · exact settled_nonce_used a s h
  · simp [settle, Finset.mem_union, Finset.mem_singleton]

end X402Sui
