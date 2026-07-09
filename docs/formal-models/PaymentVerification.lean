-- x402-Sui Payment Verification Formal Model
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09

import Mathlib.Data.Finset.Basic

namespace X402Sui

structure PaymentAuth where
  nonce            : Nat
  amount           : Nat
  expires_at_epoch : Nat
  coin_object_id   : Nat
  deriving Repr

structure FacilitatorState where
  used_nonces      : Finset Nat
  consumed_objects : Finset Nat
  current_epoch    : Nat
  deriving Repr

def not_expired (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  s.current_epoch ≤ a.expires_at_epoch

def nonce_fresh (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.nonce ∉ s.used_nonces

def object_unspent (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  a.coin_object_id ∉ s.consumed_objects

def verify (a : PaymentAuth) (s : FacilitatorState) : Prop :=
  not_expired a s ∧ nonce_fresh a s ∧ object_unspent a s

theorem atomic_payment_safe (a : PaymentAuth) (s : FacilitatorState)
    (h : verify a s) : a.coin_object_id ∉ s.consumed_objects := h.2.2

end X402Sui
