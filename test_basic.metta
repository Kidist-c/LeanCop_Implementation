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
                     !(prove-matrix-core
                        (Impl
                        (pos (human socrates))
                        (pos (mortal socrates)))
                        3)