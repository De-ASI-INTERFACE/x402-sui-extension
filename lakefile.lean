import Lake
open Lake DSL
package «x402-sui» where
  name := "x402-sui"
require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.14.0"
lean_lib «X402Sui» where
  roots := #[`X402Sui]
