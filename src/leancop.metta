;Negation : nagates the literals
(= (negate $l) (case $l
(((Neg $inner) $inner)
($other (Neg $other)))))

    ; Complementary Literals : unifies two literals if they are complement
(= (complementary $l1 $l2 $then $else)
(let $n1 (negate $l1) (unify $n1 $l2 $then $else)))


