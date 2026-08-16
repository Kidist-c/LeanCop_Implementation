
!(import! &self main)

   ; Test 1:THEOREM: Socratic Syllogism:
;;( Human(socrates) ∧ ∀x (Human(x) → Mortal(x)) ) → Mortal(socrates)

   ; !(prove-matrix-core
   ;    (Impl
   ;    (And (pos (human socrates)) (All $x (Impl (pos (human $x)) (pos (mortal $x)))))
   ;    (pos (mortal socrates)))
   ;    5)

  
;       ;    ;Test 2:THEOREM: Transitivity of Implication
;    ; ; ;; ( (P → Q) ∧ (Q → R) ) → (P → R)
;    ;    !(prove-matrix-core
;          ; (Impl
;          ;    (And
;          ;    (Impl (pos p) (pos q))
;          ;    (Impl (pos q) (pos r)))
;          ;    (Impl (pos p) (pos r)))
;          ;    5)
;          ;    ;; Test 3:THEOREM: Universal Quantifier Distribution
;          ; ; ;; ∀x (P(x) ∧ Q(x)) → (∀x P(x) ∧ ∀x Q(x))
;          ;    !(prove-matrix-core
;          ;       (Impl
;          ;       (All $x (And (pos (p $x)) (pos (q $x))))
;          ;       (And (All $x (pos (p $x)))
;          ;       (All $x (pos (q $x)))))
;          ;       5)
            

;    ; Test 4:Modes ponens 
;    !(prove-matrix-core  
; (Impl
;   (And (pos p) (Impl (pos p) (pos q)))
;  (Not (pos q)) ) 2)
    