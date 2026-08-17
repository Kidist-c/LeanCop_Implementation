!(import! &self ../helper)
!(import! &self ../def_matrix)
!(import! &self ../leancop21)
!(import! &self ../main)

;; Test 1: Pelletier's Problem 18: ∃x ∀y (P(x) → P(y))

; !(test((collapse((prove-matrix-core
;     (Ex $x (All $y (Impl (pos (p $x)) (pos (p $y)))))
;     5))))
; (
; (((ProofSuccess 2 ((Cons (ProofBranch (Cons # (Cons (pos (subst-expr $_19608 (Skolem 1 (Cons $_19644 Nil)) (subst-expr $_19668 $_19608 (subst-expr $_19668 $_19644 (p $_19668))))) Nil)) (Cons 
; (ProofBranch (Cons (Not (pos (subst-expr $_19608 (Skolem 1 
; (Cons $_19644 Nil)) (subst-expr $_19668 $_19608
;  (subst-expr $_19668 $_19644 (p $_19668)))))) Nil) Nil) Nil)) Nil))))))
; )

;; Test 2: Pelletier's problem 19:∃x ∀y∀z ((P(y) → Q(z)) → (P(x) → Q(x)))

; !(collapse (prove-matrix-core
;     (Ex $x (All $y (All $z
;       (Impl
;         (Impl (pos (p $y)) (pos (q $z)))
;         (Impl (pos (p $x)) (pos (q $x)))))))
;     5))
; !(test ((collapse (prove-matrix-core
;     (Ex $x (All $y (All $z
;       (Impl
;         (Impl (pos (p $y)) (pos (q $z)))
;         (Impl (pos (p $x)) (pos (q $x)))))))
;     5)))
; (((ProofSuccess 3 ((Cons (ProofBranch (Cons # (Cons (pos (subst-expr $_21334 (Skolem 2 (Cons $_21370 Nil)) (subst-expr $_21394 (Skolem 1 (Cons $_21370 Nil))
;  (subst-expr $_21454 $_21334 (subst-expr $_21454 $_21394 (subst-expr $_21454 $_21370 (q $_21454))))))) Nil)) (Cons (ProofBranch (Cons (Not (pos (subst-expr $_21334 (Skolem 2 (Cons $_21370 Nil)) (subst-expr $_21394 (Skolem 1 (Cons $_21370 Nil)) 
;  (subst-expr $_21454 $_21334 (subst-expr $_21454 $_21394 (subst-expr $_21454 $_21370 (q $_21454)))))))) (Cons (pos (subst-expr $_21334 (Skolem 2 (Cons $_21370 Nil)) (subst-expr $_21394 (Skolem 1 (Cons $_21370 Nil)) (subst-expr $_21454 $_21334 (subst-expr $_21454 $_21394 (subst-expr $_21454 $_21370 (p $_21454))))))) Nil)) 
;  (Cons (ProofBranch (Cons (Not (pos (subst-expr $_21334 (Skolem 2 (Cons $_21370 Nil)) (subst-expr $_21394 (Skolem 1 (Cons $_21370 Nil)) (subst-expr $_21454 $_21334 (subst-expr $_21454 $_21394 (subst-expr $_21454 $_21370 (p $_21454)))))))) Nil) Nil) Nil)) Nil)) Nil))))))




    