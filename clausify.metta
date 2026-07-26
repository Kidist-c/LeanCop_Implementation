; define nnf function : that conversts first order logic in to Negation Normal form :
; neg only appears infront of atomic predicate
; Connection calculi work on formulas
; where negations occur only on literals elimenate
;iff , implication


(= (nnf $f)
    (case $f (
    ((Neg (Neg $a))     (nnf $a))
    ((Neg (All $x $g))  (nnf (Ex $x (Neg $g))))
    ((Neg (Ex $x $g))   (nnf (All $x (Neg $g))))
    ((Neg (Or $a $b))   (nnf (And (Neg $a) (Neg $b))))
    ((Neg (And $a $b))  (nnf (Or (Neg $a) (Neg $b))))
    ((Neg (Imp $a $b))  (nnf (And $a (Neg $b))))
    ((Neg (Iff $a $b))  (nnf (Or (And $a (Neg $b)) (And (Neg $a) $b))))
    ((Imp $a $b)        (nnf (Or (Neg $a) $b)))
    ((Iff $a $b)        (nnf (And (Imp $a $b) (Imp $b $a))))
    ((All $x $g)        (All $x (nnf $g)))
    ((Ex $x $g)         (Ex $x (nnf $g)))
    ((And $a $b)        (And (nnf $a) (nnf $b)))
    ((Or $a $b)         (Or (nnf $a) (nnf $b)))
    ($lit               $lit))))


        ; Skolemization ----
    ; Replaces Universals ($\forall$): Strips (All $x ...) and replaces the variable $x with a fresh Skolem symbol (Skolem $ctr $freev).
    ; Keeps Existentials ($\exists$): Strips (Ex $x ...) but
        ; keeps $x as a free variable for unification, adding it to $freev so future inner Skolem symbols depend on it.
        ;Threads a Counter: Passes an integer $ctr through And/Or branches to ensure every generated Skolem symbol gets a unique ID.

    (= (pfst (Pair $a $b)) $a)
    (= (psnd (Pair $a $b)) $b)

    (= (skolemize $f $freev $ctr)
        (case $f (
        ((All $x $g)
        (let $sk (Skolem $ctr $freev)
        (skolemize (let $x $sk $g) $freev (+ $ctr 1))))
        ((Ex $x $g)
        (skolemize $g (cons-atom $x $freev) $ctr))
        ((And $a $b)
        (let* (($ra (skolemize $a $freev $ctr))
        ($a1 (pfst $ra)) ($ctr1 (psnd $ra))
        ($rb (skolemize $b $freev $ctr1))
        ($b1 (pfst $rb)) ($ctr2 (psnd $rb)))
        (Pair (And $a1 $b1) $ctr2)))
        ((Or $a $b)
        (let* (($ra (skolemize $a $freev $ctr))
        ($a1 (pfst $ra)) ($ctr1 (psnd $ra))
        ($rb (skolemize $b $freev $ctr1))
        ($b1 (pfst $rb)) ($ctr2 (psnd $rb)))
        (Pair (Or $a1 $b1) $ctr2)))
        ($lit (Pair $lit $ctr)))))
            : test
        ;!(skolemize (All $x (Ex $y (P $x $y))) () 0)