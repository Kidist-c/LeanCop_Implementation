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


    