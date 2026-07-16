;Negation : nagates the literals
(= (negate $l) (case $l
(((Neg $inner) $inner)
($other (Neg $other)))))

    ; Complementary Literals : unifies two literals if they are complement
(= (complementary $l1 $l2 $then $else)
(let $n1 (negate $l1) (unify $n1 $l2 $then $else)))
    ; REduction Rule : closes a branch if the current goal literal is complemrntary to an ancestor already on the path
(= (reduction $l ()) False)
(= (reduction $l $path)
(let* (($anc (car-atom $path)) ($rest (cdr-atom $path)))
(case (complementary $l $anc matched nomatch)
( (matched True)
(nomatch (reduction $l $rest)) ))))
    ; Proving a list of open goals against ashared path : each literal of the start clause is its own branch
(= (prove-goals () $path $depth) True)
(= (prove-goals $goals $path $depth)
(let* (($g (car-atom $goals)) ($rest (cdr-atom $goals)))
(case (prove-lit $g $path $depth)
( (True (prove-goals $rest $path $depth))
(False False) ))))

    ; Extenstion Rule: Try the clauses in the matrix and stops when gets one that proofs
(= (try-extension $l $path 0) False)
(= (try-extension $l $path $depth)
(let $clauses (collapse (match &matrix (Clause $c) $c))
(try-clauses $l $clauses $path $depth)))

(= (try-clauses $l () $path $depth) False)
(= (try-clauses $l $clauses $path $depth)
(let* (($c (car-atom $clauses)) ($rest-c (cdr-atom $clauses)))
(case (try-one-clause $l $c $path $depth)
( (True True)
(False (try-clauses $l $rest-c $path $depth)) ))))
; Try Reduction first (cheap, no search), then fall back to Extension.
(= (prove-lit $l $path $depth)
(case (reduction $l $path) ( (True True) (False (try-extension $l $path $depth)) )))


