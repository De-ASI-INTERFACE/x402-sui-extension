-- ============================================================
-- x402-Sui: Cetus Protocol CLMM Routing Invariants
-- Author: Richard Patterson (@De-ASI-INTERFACE)
-- Date: 2026-07-09
-- ============================================================
import Mathlib.Data.Nat.Basic
import X402Sui.PaymentVerification

namespace X402Sui.Cetus

structure CLMMPool where
  coin_type_a : Nat; coin_type_b : Nat
  current_tick : Int
  deriving Repr

structure SwapRoute where
  pool       : CLMMPool
  amount_in  : Nat
  min_amount_out : Nat
  a2b        : Bool  -- swap direction
  deriving Repr

structure GatedSwap where
  auth : PaymentAuth; route : SwapRoute
  deriving Repr

def route_authorized (gs : GatedSwap) (s : FacilitatorState) : Prop := verify gs.auth s
def route_sane (gs : GatedSwap) : Prop := 0 < gs.route.min_amount_out ∧ gs.auth.amount = gs.route.amount_in
def gated_swap_valid (gs : GatedSwap) (s : FacilitatorState) : Prop := route_authorized gs s ∧ route_sane gs

theorem gated_swap_requires_payment (gs : GatedSwap) (s : FacilitatorState) (h : gated_swap_valid gs s) :
    gs.auth.tx_digest ∉ s.settled_digests := replay_prevented gs.auth s h.1

end X402Sui.Cetus
