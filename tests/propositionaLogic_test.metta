!(import! &self ../helper)
!(import! &self ../def_matrix)
!(import! &self ../leancop21)
!(import! &self ../main)

;; Test 1: Pelletier Problem 1 — Propositional Equivalence
;; (p → q) ↔ (¬q → ¬p)
!(test
  (collapse
    (prove-matrix-core
      (And
        (Impl (Impl (pos p) (pos q)) (Impl (Not (pos q)) (Not (pos p))))
        (Impl (Impl (Not (pos q)) (Not (pos p))) (Impl (pos p) (pos q))))
      5))
  ((ProofSuccess 1 (Cons
    (ProofBranch
      (Cons # (Cons (pos q) Nil))
      (Cons
        (ProofBranch
          (Cons (Not (pos q)) (Cons (pos p) Nil))
          (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) Nil))
        Nil))
    Nil))))