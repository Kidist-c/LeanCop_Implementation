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
    ;
(= (try-one-clause $l $c $path $depth)
(try-lits $l $c $c $path $depth))
    ;;;
(= (try-lits $l () $full $path $depth) False)
(= (try-lits $l $remaining $full $path $depth)
(let* (($lp (car-atom $remaining)) ($rest (cdr-atom $remaining)))
(let $nl (negate $l)
(let $unif-result (unify $nl $lp (Pair $lp $full) FAIL)
    (case $unif-result
    ( (FAIL (try-lits $l $rest $full $path $depth))
    ((Pair $slp $sfull)
    (prove-goals (remove-one $slp $sfull) (cons-atom $l $path) (- $depth 1))) ))))))
    ; Remove exactly one occurrence (the literal used for the connection)
        ; from a clause tuple, preserving the rest.
    (= (remove-one $x $tuple) (remove-one-h $x () $tuple))
    (= (remove-one-h $x $acc ()) $acc)
    (= (remove-one-h $x $acc $tuple)
    (let* (($h (car-atom $tuple)) ($t (cdr-atom $tuple)))
    (if (== $h $x)
    (concat-tuple $acc $t)
    (remove-one-h $x (concat-tuple $acc ($h)) $t))))
    (= (concat-tuple () $b) $b)
    (= (concat-tuple $a $b)
    (let* (($h (car-atom $a)) ($t (cdr-atom $a)) ($rec (concat-tuple $t $b)))
    (cons-atom $h $rec)))

    
    ; Attempt to close a start clause (a tuple of literals) at exactly one
        ; depth bound.
    (= (prove-start $c $depth) (prove-goals $c () $depth))

        ; Use Non determnistic
    (= (any-true ()) False)
    (= (any-true $tuple)
    (let* (($h (car-atom $tuple)) ($t (cdr-atom $tuple)))
    (if (== $h True) True (any-true $t))))

    (= (proved? $start-clause $max-depth)
    (any-true (collapse (prove-iter $start-clause $max-depth))))
        ; ; Iterative deepening: try depth 1, 2, 3, ... up to $max
    (= (prove-start-clean $c $d) (any-true (collapse (prove-start $c $d))))
    (= (prove-iter $c $max) (prove-iter-h $c 1 $max))
    (= (prove-iter-h $c $d $max)
    (if (> $d $max) False
    (case (prove-start-clean $c $d)
    ( (True True)
    (False (prove-iter-h $c (+ $d 1) $max)) ))))



