; test_petta.metta
; Test harness for the leanCoP-in-MeTTa implementation, written for the
; PeTTa (Prolog-based) MeTTa interpreter.
   ;
   ; Run from inside your PeTTa install directory with:
   ;   sh run.sh path/to/test_petta.metta
   ;
   ; Make sure clausify.metta and prove.metta sit in the SAME folder as this
; file (or adjust the import! paths below to point at them).

!(import! &self clausify)
!(import! &self prove)

; PeTTa needs a space to be a bound named atom (created with bind!),
; not passed inline as (new-space).
!(bind! &s1 (new-space))
!(bind! &s2 (new-space))
!(bind! &s3 (new-space))

   ; ---------------------------------------------------------------------
; Test 1: trivial tautology  P(a) -> P(a)
; Negating a valid formula and refuting it should succeed (ProofFound).
   ; ---------------------------------------------------------------------
!(println! "Test 1: P(a) -> P(a)  (expect ProofFound)")
!(refute &s1 (Neg (Imp (P a) (P a))) 6)

   ; ---------------------------------------------------------------------
; Test 2: a NON-theorem   P(a) -> Q(a)   (no relation between P and Q)
   ; This should NOT be provable within the depth limit -> NoProofFound.
   ; ---------------------------------------------------------------------
!(println! "Test 2: P(a) -> Q(a)  (expect NoProofFound)")
!(refute &s2 (Neg (Imp (P a) (Q a))) 5)

   ; ---------------------------------------------------------------------
   ; Test 3: quantified formula sanity check (clausify + skolemization run
   ; through refute without errors -- not a provability check by itself).
   ; ---------------------------------------------------------------------
!(println! "Test 3: quantified formula sanity check")
!(refute &s3 (All $x (Ex $y (And (P $x) (Q $y)))) 5)
