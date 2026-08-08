
!(import! &self leancop21)

   ; Test 1:THEOREM: Socratic Syllogism:
;;( Human(socrates) ∧ ∀x (Human(x) → Mortal(x)) ) → Mortal(socrates)

   !(prove-matrix-core
      (Impl
      (And (pos (human socrates)) (All $x (Impl (pos (human $x)) (pos (mortal $x)))))
      (pos (mortal socrates)))
      5)

  
      ;    ;Test 2:THEOREM: Transitivity of Implication
   ; ;; ( (P → Q) ∧ (Q → R) ) → (P → R)
      !(prove-matrix-core
         (Impl
            (And
            (Impl (pos p) (pos q))
            (Impl (pos q) (pos r)))
            (Impl (pos p) (pos r)))
            5)
            ;; Test 3:THEOREM: Universal Quantifier Distribution
         ; ;; ∀x (P(x) ∧ Q(x)) → (∀x P(x) ∧ ∀x Q(x))
            !(prove-matrix-core
               (Impl
               (All $x (And (pos (p $x)) (pos (q $x))))
               (And (All $x (pos (p $x)))
               (All $x (pos (q $x)))))
               5)
            ;;Test 4: PELLETIER PROBLEM 17 (Propositional Equivalence Benchmark)
            ;;   ( (P ∧ (Q → R)) → S )  ↔  ( (¬P ∨ Q ∨ S) ∧ (¬P ∨ ¬R ∨ S) )
            (= (pelletier-17-lhs)
            (Impl (And (pos p) (Impl (pos q) (pos r)))
            (pos s)))

            (= (pelletier-17-rhs)
            (And (Or (Not (pos p)) (Or (pos q) (pos s)))
            (Or (Not (pos p)) (Or (Not (pos r)) (pos s)))))

               !(prove-matrix-core
               (And (Impl (pelletier-17-lhs) (pelletier-17-rhs))
               (Impl (pelletier-17-rhs) (pelletier-17-lhs)))
               5)