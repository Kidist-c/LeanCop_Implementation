; ;; test.metta
!(import! &self leancop21)

   ;    !(prove-matrix-core
      ;       (Impl
      ;       (And (pos (human socrates)) (All $x (Impl (pos (human $x)) (pos (mortal $x)))))
      ;       (pos (mortal socrates)))
      ;       5)
      ; !(prove-matrix-core
         ;    (Impl
            ;       (And
            ;       (Impl (pos p) (pos q))
            ;       (Impl (pos q) (pos r)))
            ;       (Impl (pos p) (pos r)))
            ;       5)
            ; !(prove-matrix-core
               ;    (Impl
               ;    (And (Impl (pos p) (pos q)) (pos q))
               ;    (pos p))
               ;    3)
               ; !(prove-matrix-core
                  ;    (Impl
                     ;       (And
                     ;       (pos p)
                     ;       (Impl (pos p) (pos q)))
                     ;       (pos q))
                     ;       5)
                     ; !(prove-matrix-core
                        ;    (Impl
                        ;    (pos (human socrates))
                        ;    (pos (mortal socrates)))
                        ;    3)
                     
                     !(println! "==================================================")
                     !(println! "   END-TO-END PREPROCESSOR TO MATRIX TEST         ")
                     ; !(println! "==================================================")

                        ;; -----------------------------------------------------------------------------
                        ;; Target Formula: Classical Syllogism
                     ;; (ALL x (human(x) => mortal(x))) AND human(socrates) => mortal(socrates)
                        ;; -----------------------------------------------------------------------------

                        ;    ;; Step 1: Raw First-Order Logic Input Formula
                     ; (= (syllogism-fml)
                        ;    (Impl
                           ;       (And
                           ;       (All $x (Impl (pos (human $x)) (pos (mortal $x))))
                           ;       (pos (human socrates)))
                           ;       (pos (mortal socrates))))


                           ;       !(println! "\n--- 1. Raw Input Formula ---")
                           ;       !(syllogism-fml)


                           ;       !(println! "\n--- 2. Definitional NNF & Tseitin Transformation (def-nnf) ---")
                              ;          ;; Convert to Definitional NNF starting with index 1 and mode 'def'
                           ;       !(def-nnf (syllogism-fml) 1 def)


                           ;       !(println! "\n--- 3. Prove Directly from Matrix ---")
                              ;          ;; prove-matrix-core runs preprocessing automatically and executes the search
                           ;       !(prove-matrix-core (syllogism-fml) 5)
                              ;; =============================================================================
                           ;; DNF (DISJUNCTIVE NORMAL FORM) PREPROCESSOR TEST SUITE
                              ;; =============================================================================

                              ;; --- Helper Predicates ---

                              ;; Check if an expression is an Or term
                           
                              ;; =============================================================================
                              ;; TEST CASES
                              ;; =============================================================================

                           !(println! "==================================================")
                           !(println! "        TESTING DNF ON NESTED FOL FORMULAS        ")
                           !(println! "==================================================")

                              ;; -----------------------------------------------------------------------------
                           ;; Test 1: Two Nested Disjunctions: (P v Q) ^ (R v S)
                           ;; Expected DNF: (P ^ R) v (P ^ S) v (Q ^ R) v (Q ^ S)
                              ;; -----------------------------------------------------------------------------
                           (= (nested-test-1)
                           (And (Or (pos (p $x)) (pos (q $x)))
                           (Or (pos (r $y)) (pos (s $y)))))

                           !(println! "\n--- Test 1: (P(x) v Q(x)) ^ (R(y) v S(y)) ---")
                           !(println! "Input: ")
                           !(nested-test-1)
                           !(println! "DNF Result: ")
                           !(dnf (nested-test-1))


                              ;; -----------------------------------------------------------------------------
                           ;; Test 2: Deeply Nested 3-Way Product: ((A v B) ^ (C v D)) ^ E
                              ;; Tests deep recursion through And nodes
                              ;; -----------------------------------------------------------------------------
                           (= (nested-test-2)
                           (And (And (Or (pos (human $x)) (pos (robot $x)))
                           (Or (pos (mortal $x)) (pos (chargeable $x))))
                           (pos (active $x))))

                           !(println! "\n--- Test 2: ((Human v Robot) ^ (Mortal v Chargeable)) ^ Active ---")
                           !(println! "Input: ")
                           !(nested-test-2)
                           !(println! "DNF Result: ")
                           !(dnf (nested-test-2))


                              ;; -----------------------------------------------------------------------------
                           ;; Test 3: Deeply Nested Right-Hand Expansion: A ^ (B ^ (C v D))
                              ;; -----------------------------------------------------------------------------
                           (= (nested-test-3)
                           (And (pos (a))
                           (And (pos (b))
                           (Or (pos (c)) (pos (d))))))

                           !(println! "\n--- Test 3: A ^ (B ^ (C v D)) ---")
                           !(println! "Input: ")
                           !(nested-test-3)
                           !(println! "DNF Result: ")
                           !(dnf (nested-test-3))