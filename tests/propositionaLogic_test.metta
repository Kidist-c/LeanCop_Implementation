!(import! &self ../helper)
!(import! &self ../def_matrix)
!(import! &self ../leancop21)
!(import! &self ../main)

;; Test 1: Pelletier Problem 1 — Propositional Equivalence
;; (p → q) ↔ (¬q → ¬p)
; !(test
;    (collapse
;      (prove-matrix-core
;        (And
;         (Impl (Impl (pos p) (pos q)) (Impl (Not (pos q)) (Not (pos p))))
;          (Impl (Impl (Not (pos q)) (Not (pos p))) (Impl (pos p) (pos q))))
;       5))
;  ((ProofSuccess 1 ((Cons (ProofBranch (Cons # (Cons (pos q) Nil)) (Cons
;  (ProofBranch (Cons (Not (pos q)) (Cons (pos p) Nil)) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) Nil)) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (Def 1 Nil) (Cons (Def 2 Nil) Nil))) (Cons (ProofBranch (Cons (Not (Def 1 Nil)) Nil) Nil)  (Cons (ProofBranch (Cons (Not (Def 2 Nil)) Nil) Nil) Nil))) Nil))))
;       )
;Test 2: PELLETIER PROBLEM 17 (Propositional Equivalence Benchmark)
      ;       ; ( (P ∧ (Q → R)) → S )  ↔  ( (¬P ∨ Q ∨ S) ∧ (¬P ∨ ¬R ∨ S) )
      ;       (= (pelletier-17-lhs)
      ;       (Impl (And (pos p) (Impl (pos q) (pos r)))
      ;       (pos s)))

      ;       (= (pelletier-17-rhs)
      ;       (And (Or (Not (pos p)) (Or (pos q) (pos s)))
      ;       (Or (Not (pos p)) (Or (Not (pos r)) (pos s)))))

      
      ; !(test (collapse (prove-matrix-core (And (Impl (pelletier-17-lhs)
      ;  (pelletier-17-rhs)) (Impl (pelletier-17-rhs) (pelletier-17-lhs))) 5))
      ;  ((ProofSuccess 1 ((Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons 
      ;  (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (pos r) Nil))) 
      ;  (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch 
      ;  (Cons (Not (pos r)) (Cons (pos q) Nil)) (Cons (ProofBranch (Cons 
      ;  (Not (pos q)) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) Nil) Nil) Nil))) Nil)) Nil))) Nil)) Nil)
      ;   (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (pos r) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (Not (pos r)) (Cons (pos q) Nil)) (Cons (ProofBranch (Cons (Not (pos q)) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil))) Nil))
      ;    Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) 
      ;    (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (pos r) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (Not (pos r)) (Cons (pos q) Nil)) (Cons (ProofBranch (Cons (Not (pos q)) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) Nil) Nil) Nil))) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (pos r) Nil))) (Cons (ProofBranch
      ;     (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (Not (pos r)) (Cons (pos q) Nil)) (Cons (ProofBranch 
      ;    (Cons (Not (pos q)) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons
      ;     (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons 
      ;     (pos s) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil))) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (pos r) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (Not (pos r)) (Cons (pos q) Nil)) (Cons (ProofBranch (Cons (Not (pos q)) Nil) Nil) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (pos r) Nil)))
      ;     (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch 
      ;     (Cons (Not (pos r)) Nil) Nil) Nil))) Nil)) Nil) (Cons (ProofBranch
      ;      (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (Not (pos q)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos q) (Cons (Not (pos r)) Nil)) (Cons (ProofBranch (Cons (pos r) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) Nil) Nil) Nil))) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) 
      ;     (Cons (pos p) (Cons (Not (pos q)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos q) (Cons (Not (pos r)) Nil)) (Cons (ProofBranch (Cons (pos r) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil))) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (Not (pos q)) Nil))) (Cons (ProofBranch 
      ;     (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos q) (Cons 
      ;     (Not (pos r)) Nil)) (Cons (ProofBranch (Cons (pos r) (Cons (pos p) 
      ;     (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) Nil) Nil) Nil))) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (Not (pos q)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos q) (Cons (Not (pos r)) Nil)) (Cons (ProofBranch (Cons (pos r) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil))) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons
      ;      (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (Not (pos q)) Nil))) (Cons (ProofBranch (Cons (Not (pos p))
      ;      Nil) Nil) (Cons (ProofBranch (Cons (pos q) (Cons (Not (pos r)) Nil)) (Cons (ProofBranch (Cons (pos r) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (Not (pos q)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos q) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos s) Nil)) (Cons (ProofBranch (Cons (Not (pos s)) (Cons (pos p) (Cons (Def 1 Nil) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (Not (Def 1 Nil)) Nil) Nil) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos q) Nil)) (Cons (ProofBranch (Cons (Not (pos q))
      ;       (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil))) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos q) Nil)) (Cons (ProofBranch (Cons (Not (pos q)) Nil) Nil) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos r) Nil)) (Cons (ProofBranch (Cons (Not (pos r)) (Cons (pos q) Nil)) (Cons (ProofBranch (Cons (Not (pos q)) (Cons (pos p) (Cons (Not (pos s)) Nil))) (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) (Cons (ProofBranch (Cons (pos s) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil))) Nil)) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos r) Nil)) (Cons (ProofBranch (Cons
      ;        (Not (pos r)) (Cons (pos q) Nil)) (Cons (ProofBranch (Cons (Not (pos q)) Nil) Nil) Nil)) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (pos r) Nil)) (Cons (ProofBranch (Cons (Not (pos r)) Nil) Nil) Nil)) Nil) (Cons (ProofBranch (Cons # (Cons (Def 2 Nil) (Cons (Def 3 Nil) Nil))) (Cons (ProofBranch (Cons (Not (Def 2 Nil)) Nil) Nil) (Cons (ProofBranch (Cons (Not (Def 3 Nil)) Nil) Nil) Nil))) Nil) (Cons (ProofBranch (Cons # (Cons (Def 4 Nil) (Cons (Def 5 Nil) Nil))) (Cons (ProofBranch (Cons (Not (Def 4 Nil)) Nil) Nil) 
      ;  (Cons (ProofBranch (Cons (Not (Def 5 Nil)) Nil) Nil) Nil))) Nil))))
; )
;; Test 3:Pelletier Problem 2: Double Negation
;;¬¬P ↔ P

; !(test (collapse (prove-matrix-core
;   (And (Impl (Not (Not (pos p))) (pos p))
;        (Impl (pos p) (Not (Not (pos p)))))
;   5))
;   ((ProofSuccess 1 ((Cons (ProofBranch
;     (Cons # (Cons (pos p) Nil))
;     (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) Nil)) Nil)
;     (Cons (ProofBranch
;       (Cons # (Cons (Def 1 Nil) (Cons (Def 2 Nil) Nil)))
;       (Cons (ProofBranch (Cons (Not (Def 1 Nil)) Nil) Nil)
;             (Cons (ProofBranch (Cons (Not (Def 2 Nil)) Nil) Nil) Nil))) Nil)))))
 ;Test 4:;; Pelletier Problem 3(¬(P → Q) → (Q → P))

; !(test
;   (collapse
;     (prove-matrix-core
;       (Impl
;         (Not (Impl (pos p) (pos q)))
;         (Impl (pos q) (pos p)))
;       5))
;   ((ProofSuccess 1
;     ((Cons (ProofBranch
;       (Cons # (Cons (pos p) Nil))
;       (Cons (ProofBranch (Cons (Not (pos p)) Nil) Nil) Nil)) Nil)
;      (Cons (ProofBranch
;       (Cons # (Cons (pos q) Nil))
;       (Cons (ProofBranch (Cons (Not (pos q)) Nil) Nil) Nil)) Nil)))))
;; Test 5:pelletier problem 4: ((¬p → q) ↔ (¬q → p))

   !(test (collapse 
   (prove-matrix-core
    (And
      (Impl
        (Impl (Not (pos p)) (pos q))
        (Impl (Not (pos q)) (pos p)))
      (Impl
        (Impl (Not (pos q)) (pos p))
        (Impl (Not (pos p)) (pos q))))
    5))
    ((ProofSuccess 1 ((Cons (ProofBranch (Cons # (Cons (pos q) Nil)) (Cons 
    (ProofBranch (Cons (Not (pos q)) (Cons (Not (pos p)) Nil)) (Cons 
    (ProofBranch (Cons (pos p) (Cons # Nil)) (Cons (ProofBranch 
    (Cons (Not #) Nil) Nil) Nil)) Nil)) Nil)) Nil) (Cons (ProofBranch
     (Cons # (Cons (pos p) Nil)) (Cons (ProofBranch (Cons (Not (pos p)) (Cons (Not (pos q)) Nil)) (Cons 
     (ProofBranch (Cons (pos q) (Cons # Nil)) (Cons (ProofBranch (Cons (Not #) Nil) Nil) Nil)) Nil)) Nil)) Nil) (Cons
      (ProofBranch (Cons # (Cons (Def 1 Nil) (Cons (Def 2 Nil) Nil))) (Cons 
    (ProofBranch (Cons (Not (Def 1 Nil)) Nil) Nil) (Cons 
    (ProofBranch (Cons (Not(Def 2 Nil)) Nil) Nil) Nil))) Nil)))))
      
  
  
  
      
   