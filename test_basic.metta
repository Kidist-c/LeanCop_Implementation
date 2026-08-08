
!(import! &self leancop21)

   ; Test 1:THEOREM: Socratic Syllogism:
;;( Human(socrates) ∧ ∀x (Human(x) → Mortal(x)) ) → Mortal(socrates)

   !(prove-matrix-core
      (Impl
      (And (pos (human socrates)) (All $x (Impl (pos (human $x)) (pos (mortal $x)))))
      (pos (mortal socrates)))
      5)

  
      ;Test 2:THEOREM: Transitivity of Implication
   ;; ( (P → Q) ∧ (Q → R) ) → (P → R)
      !(prove-matrix-core
         (Impl
            (And
            (Impl (pos p) (pos q))
            (Impl (pos q) (pos r)))
            (Impl (pos p) (pos r)))
            5)