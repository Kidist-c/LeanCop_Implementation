; this works together with clausify

;;; Function to negate
(= (negate $f)
    (case $f (
    ((Neg $x) $x)
    ($x (Neg $x)))))
        ;;
    (= (member-tup $x $tup)
    (if (== $tup ())
        False
    (let ($h $t) (decons-atom $tup)
    (if (== $x $h) True (member-tup $x $t)))))
        ;;; Reduction Rule
        ; ; is there an ancestor on $path complementary to $lit? if there close the Branch
    (= (exists-complement $lit $path)
    (if (== $path ())
        False
    (let ($h $t) (decons-atom $path)
    (if (== $h (negate $lit)) True (exists-complement $lit $t)))))

        ;; Add matrix of clauses in to spaces
    (= (populate-clause-acc $space $clause $before)
    (if (== $clause ())
        noop
    (let ($l $after) (decons-atom $clause)
    (let $rest (append-tup $before $after)
    (let $ignore1 (add-atom $space (lit $l $rest))
    (populate-clause-acc $space $after (append-tup $before ($l))))))))

    (= (populate-clause $space $clause) (populate-clause-acc $space $clause ()))

    (= (populate-matrix $space $matrix)
    (if (== $matrix ())
        noop
    (let ($c $t) (decons-atom $matrix)
    (let $ignore1 (populate-clause $space $c)
    (populate-matrix $space $t)))))

        ;Try to close the literal otherwise proceeed with extenstion -rule
    (= (close-lit $space $lit $path $pathlim $lem)
    (if (member-tup $lit $lem)
        True
    (if (exists-complement $lit $path)
        True
    (extension-step $space $lit $path $pathlim $lem))))

        ; The extenstion rule :extend the current proof search by introducing
        ; anew goal from a caluse whose complementary literls matches the current goal
    (= (extension-step $space $lit $path $pathlim $lem)
    (if (<= $pathlim 0)
    (empty)
    (let $needed (negate $lit)
    (match $space (lit $needed $rest)
    (prove-clause $space $rest (cons-atom $lit $path) (- $pathlim 1) $lem)))))
        ; proving the clause
    (= (prove-clause $space $clause $path $pathlim $lem)
    (if (== $clause ())
        True
    (let ($l $rest) (decons-atom $clause)
    (if (== (close-lit $space $l $path $pathlim $lem) True)
    (prove-clause $space $rest $path $pathlim (cons-atom $l $lem))
    (empty)))) ; This branch fails
        ; ---- Start rule: try every clause in the matrix as the start clause ------
    (= (find-proof $space $matrix $pathlim)
    (let $c (superpose $matrix)
    (prove-clause $space $c () $pathlim ()))) ; intially the path is empty
    ;Iterative Deepening Depth-First Search (IDDFS).
        ;Instead of searching with one fixed depth limit, it repeatedly tries larger depth limits
        ; until it either finds a proof or reaches a maximum allowed depth.

    (= (prove-iddfs $space $matrix $pathlim $maxpathlim)
    (if (> $pathlim $maxpathlim)
    (NoProofFound)
    (let $r (collapse (find-proof $space $matrix $pathlim))
    (if (== $r ())
    (prove-iddfs $space $matrix (+ $pathlim 1) $maxpathlim)
    (ProofFound $pathlim)))))

        ; Entry point one call for all
    (= (refute $space $f $maxpathlim)
    (let $m (clausify $f)
    (let $ignore2 (populate-matrix $space $m)
    (prove-iddfs $space $m 1 $maxpathlim))))