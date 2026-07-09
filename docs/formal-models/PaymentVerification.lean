-- x402-Sui Payment Verification | Author: Richard Patterson
import X402Sui.Basic

namespace X402Sui.Verification

def settle (a : PaymentAuth) (s : FacilitatorState) (h : verify a s) : FacilitatorState :=
  { s with settled_digests := s.settled_digests ∪ {a.tx_digest} }

theorem settled_digest_recorded (a : PaymentAuth) (s : FacilitatorState) (h : verify a s)
    : a.tx_digest ∈ (settle a s h).settled_digests := by
  simp [settle, Finset.mem_union, Finset.mem_singleton]

end X402Sui.Verification
