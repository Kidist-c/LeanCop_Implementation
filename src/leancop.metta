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


