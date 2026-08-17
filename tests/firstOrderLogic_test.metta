!(import! &self ../helper)
!(import! &self ../def_matrix)
!(import! &self ../leancop21)
!(import! &self ../main)

;; Test 1: Pelletier's Problem 18: ∃x ∀y (P(x) → P(y))

!(test((collapse((prove-matrix-core
    (Ex $x (All $y (Impl (pos (p $x)) (pos (p $y)))))
    5))))
(
(((ProofSuccess 2 ((Cons (ProofBranch (Cons # (Cons (pos (subst-expr $_19608 (Skolem 1 (Cons $_19644 Nil)) (subst-expr $_19668 $_19608 (subst-expr $_19668 $_19644 (p $_19668))))) Nil)) (Cons 
(ProofBranch (Cons (Not (pos (subst-expr $_19608 (Skolem 1 
(Cons $_19644 Nil)) (subst-expr $_19668 $_19608
 (subst-expr $_19668 $_19644 (p $_19668)))))) Nil) Nil) Nil)) Nil))))))
)


