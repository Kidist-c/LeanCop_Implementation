;; -- LIST UTILITIES --
;; Alias for member2 to maintain backward compatibility
(= (has-option $x Nil) False)
(= (has-option $x (Cons $h $t))
(if (== $x $h) True (has-option $x $t)))

    ;; Extract reo depth safely without non-deterministic
    ;;duplicate branch evaluation
(= (is-reo (reo $i)) True)
(= (is-reo $x)       False)
(= (get-reo-depth Nil) 0)
(= (get-reo-depth (Cons (reo $i) $t)) $i)
(= (get-reo-depth (Cons $h $t)) (get-reo-depth $t))

    ;; Compute total length of a Cons-list
(= (list-length Nil) 0)
(= (list-length (Cons $h $t)) (+ 1 (list-length $t)))

    ;; Take first $n elements from $list
    ;; list slicing
(= (take 0 $list) Nil)
(= (take $n Nil) Nil)
(= (take $n (Cons $h $t)) (Cons $h (take (- $n 1) $t)))

    ;; Drop first $n elements from $list
(= (drop 0 $list) $list)
(= (drop $n Nil) Nil)
(= (drop $n (Cons $h $t)) (drop (- $n 1) $t))

    ;; Remove all occurrences of $target from $list
(= (delete2 Nil $y) Nil)
(= (delete2 (Cons $x $t) $y)
(if (== $x $y) (delete2 $t $y) (Cons $x (delete2 $t $y))))


    ;; Member check: Returns True if $elem is in the Cons-list,
    ;; False otherwise
(= (member2 $x Nil) False)
(= (member2 $x (Cons $h $t))
(if (== $x $h) True (member2 $x $t)))

    ;; Append two Cons-lists
(= (append-list Nil $ys) $ys)
(= (append-list (Cons $x $xs) $ys)
(Cons $x (append-list $xs $ys)))

    ;; Boolean Logic Helpers
(= (bool-and $a $b)
(case (Pair $a $b)
(((Pair True True) True)
($_ False))))

(= (bool-not $a)
    (case $a
    ((True False)
    (False True))))


        ;; check if a term is an implication
    (= (is-impl $expr)
        (case $expr
        (((Impl $a $b) True)
        ($_ False))))
            ;; Checks if an expression is a Disjunction
        (= (is-or $expr)
            (case $expr
            (((Or $a $b) True)
            ($_ False))))

                ;; -----------------------------------------------------------------------------
                ;; 2. SUBSTITUTION ENGINE
                ;; -----------------------------------------------------------------------------

            (= (subst $x $y $term)
            (if (== $term $x)
                $y
                (case $term
                (((All $v $b)  (if (== $v $x) (All $v $b) (All $v (subst $x $y $b))))
                ((Ex $v $b)   (if (== $v $x) (Ex $v $b) (Ex $v (subst $x $y $b))))
                ((And $a $b)  (And (subst $x $y $a) (subst $x $y $b)))
                ((Or $a $b)   (Or (subst $x $y $a) (subst $x $y $b)))
                ((Impl $a $b) (Impl (subst $x $y $a) (subst $x $y $b)))
                ((Not $a)     (Not (subst $x $y $a)))
                ((pos $a)     (pos (subst $x $y $a)))
                ($_           (if (== (get-metatype $term) Expression)
                (subst-expr $x $y $term)
                $term))))))

            (= (subst-expr $x $y $expr)
            (if (== $expr ())
            ()
            (let ($h $t) (decons-atom $expr)
            (let $newH (subst $x $y $h)
            (let $newT (subst-expr $x $y $t)
            (cons-atom $newH $newT))))))

                ;; -----------------------------------------------------------------------------
                ;; 3. UNIVAR: VARIABLE RENAMING
                ;; -----------------------------------------------------------------------------

                ;; fresh-var: generates a genuinely fresh, bare MeTTa variable on each call.
                ;; This relies on MeTTa's standard hygiene: a pattern variable that appears
            ;; only on the right-hand side of an equation (not the left) gets a fresh
                ;; identity on every application. Previously univar wrapped renamed variables
            ;; as (v $x) -- a compound term, NOT a bare variable -- which meant later
            ;; unification (e.g. matching (human (v $x)) against a ground fact like
            ;; (human socrates)) could never succeed, since a bare symbol like `socrates`
            ;; cannot structurally unify with the compound (v $x). Using a genuine bare
                ;; fresh variable here restores real first-order unification during proof search.
            (= (fresh-var) $newvar)

            (= (univar $expr $q)
                (case $expr
                (((All $x $body)
                (let $q1 (delete2 $q $x)
                (let $y (fresh-var)
                (let $new-body (subst $x $y $body)
                (All $y (univar $new-body (Cons $y $q1)))))))
                ((Ex $x $body)
                (let $q1 (delete2 $q $x)
                (let $y (fresh-var)
                (let $new-body (subst $x $y $body)
                (Ex $y (univar $new-body (Cons $y $q1)))))))
                ((And $a $b)  (And (univar $a $q) (univar $b $q)))
                ((Or $a $b)   (Or (univar $a $q) (univar $b $q)))
                ((Impl $a $b) (Impl (univar $a $q) (univar $b $q)))
                ((Not $a)     (Not (univar $a $q)))
                ($_           $expr))))

                    ;; -----------------------------------------------------------------------------
                ;; 4. DEFINITIONAL NNF & SKOLEMIZATION ENGINE (def-8)
                    ;; -----------------------------------------------------------------------------

                (= (def-nnf $fml $i $set)
                (let (DefResult $nnf $defL $nextI) (def-8 $fml Nil $i $set)
                (def-3 $defL $nnf)))

                (= (def-3 Nil $fml) $fml)
                (= (def-3 (Cons (Pair $a (Or $b $c)) $defL) $fml)
                (def-3 (Cons (Pair $a $b) (Cons (Pair $a $c) $defL)) $fml))
                (= (def-3 (Cons (Pair $a $b) $defL) $fml)
                (def-3 $defL (Or $a $fml)))

                (= (def-8 $expr $freeV $i $set)
                    (case $expr
                    (((Not (Not $a)) (def-8 $a $freeV $i $set))
                    ((Not (All $x $f)) (def-8 (Ex $x (Not $f)) $freeV $i $set))
                    ((Not (Ex $x $f)) (def-8 (All $x (Not $f)) $freeV $i $set))
                    ((Not (Or $a $b)) (def-8 (And (Not $a) (Not $b)) $freeV $i $set))
                    ((Not (And $a $b)) (def-8 (Or (Not $a) (Not $b)) $freeV $i $set))
                    ((Not (Impl $a $b)) (def-8 (And $a (Not $b)) $freeV $i $set))
                    ((Impl $a $b) (def-8 (Or (Not $a) $b) $freeV $i $set))
                    ((Equiv $a $b)
                    (if (== $set def)
                    (def-8 (And (Impl $a $b) (Impl $b $a)) $freeV $i $set)
                    (def-8 (Or (And $a $b) (And (Not $a) (Not $b))) $freeV $i $set)))
                    ((Ex $x $f) (def-8 $f (Cons $x $freeV) $i $set))
                    ((All $x $fml)
                    (let $skolemTerm (Skolem $i $freeV)
                    (let $fml1 (subst $x $skolemTerm $fml)
                    (def-8 $fml1 $freeV (+ $i 1) $set))))
                    ((Or $a $b)
                    (let (DefResult $nnf1 $def1 $i2 $paths1) (def-8-path $a $freeV $i $set)
                    (let (DefResult $nnf2 $def2 $i1 $paths2) (def-8-path $b $freeV $i2 $set)
                    (let $defs (append-list $def1 $def2)
                    (let $nnf (if (> $paths1 $paths2) (Or $nnf2 $nnf1) (Or $nnf1 $nnf2))
                    (DefResult $nnf $defs $i1))))))
                    ((And $a $b)
                    (let (DefResult $nnfA $defA $i2 $p1) (def-8-path $a $freeV $i $set)
                    (let (TseitinResult $nnf1 $def1 $i3)
                    (if (bool-and (is-or $nnfA) (== $set def))
                    (TseitinResult (Def $i2 $freeV) (Cons (Pair (Not (Def $i2 $freeV)) $nnfA) $defA) (+ $i2 1))
                    (TseitinResult $nnfA $defA $i2))
                    (let (DefResult $nnfB $defB $i4 $p2) (def-8-path $b $freeV $i3 $set)
                    (let (TseitinResult $nnf2 $def2 $i1)
                    (if (bool-and (is-or $nnfB) (== $set def))
                    (TseitinResult (Def $i4 $freeV) (Cons (Pair (Not (Def $i4 $freeV)) $nnfB) $defB) (+ $i4 1))
                    (TseitinResult $nnfB $defB $i4))
                    (let $defs (append-list $def1 $def2)
                    (let $nnf (if (> $p1 $p2) (And $nnf2 $nnf1) (And $nnf1 $nnf2))
                    (DefResult $nnf $defs $i1))))))))
                    ($_ (DefResult $expr Nil $i)))))

                    (= (def-8-path $fml $freeV $i $set)
                    (let (DefResult $nnf $defs $nextI) (def-8 $fml $freeV $i $set)
                    (DefResult $nnf $defs $nextI (count-paths $nnf))))

                    (= (count-paths $expr)
                        (case $expr
                        (((Or $a $b)  (* (count-paths $a) (count-paths $b)))
                        ((And $a $b) (+ (count-paths $a) (count-paths $b)))
                        ($_ 1))))

                            ;; -----------------------------------------------------------------------------
                            ;; 5. DNF TRANSFORMER
                            ;; -----------------------------------------------------------------------------

                        (= (dnf $expr)
                            (case $expr
                            (((And (Or $a $b) $c) (Or (dnf (And $a $c)) (dnf (And $b $c))))
                            ((And $a (Or $b $c)) (Or (dnf (And $a $b)) (dnf (And $a $c))))
                            ((And $a $b)
                            (let $a1 (dnf $a)
                            (let $b1 (dnf $b)
                            (if (or (is-or $a1) (is-or $b1))
                            (dnf (And $a1 $b1))
                            (And $a1 $b1)))))
                            ((Or $a $b) (Or (dnf $a) (dnf $b)))
                            ($_         $expr))))

                                ;; -----------------------------------------------------------------------------
                            ;; 6. MATRIX BUILDER & TAUTOLOGY DELETER (FIXED union2)
                                ;; -----------------------------------------------------------------------------

                            (= (mat $expr)
                                (case $expr
                                (((Or $a $b) (append-list (mat $a) (mat $b)))
                                ((And $a $b)
                                (let (Cons $ca Nil) (mat $a)
                                (let (Cons $cb Nil) (mat $b)
                                (union2 $ca $cb))))
                                ((Not $lit) (Cons (Cons (Not $lit) Nil) Nil))
                                ($_         (Cons (Cons $expr Nil) Nil)))))

                                (= (union2 Nil $acc) (Cons $acc Nil))
                                (= (union2 (Cons $x $t) $acc)
                                (if (member2 $x $acc)
                                (union2 $t $acc)
                                (if (has-complement $x $acc)
                                    Nil
                                (union2 $t (Cons $x $acc)))))

                                (= (has-complement $expr $list)
                                    (case $expr
                                    (((Not $p) (member2 $p $list))
                                    ($_       (member2 (Not $expr) $list)))))

                                        ;; -----------------------------------------------------------------------------
                                        ;; 7. REORDERING & MASTER COORDINATOR
                                        ;; -----------------------------------------------------------------------------

                                    (= (mreorder $m $i)
                                    (if (<= $i 0)
                                        $m
                                    (let $l (list-length $m)
                                    (let $k (floor-div $l 3)
                                    (let $a (take $k $m)
                                    (let $d (drop $k $m)
                                    (let $c (drop (- (list-length $d) $k) $d)
                                    (let $b (take (- (list-length $d) $k) $d)
                                    (let $m2 (mreorder2 $c $a $b)
                                    (mreorder $m2 (- $i 1)))))))))))

                                    (= (mreorder2 Nil Nil $rest) $rest)
                                    (= (mreorder2 (Cons $a $a1) (Cons $b $b1) (Cons $c $c1))
                                    (Cons $a (Cons $b (Cons $c (mreorder2 $a1 $b1 $c1)))))

                                    (= (mark-conj (Impl $a $c))
                                    (Impl (And $a #) (And # $c)))

                                    (= (build-dnf $f2 $set)
                                    (if (has-option nodef $set)
                                    (dnf (def-nnf $f2 1 nnf))
                                    (if (bool-and (bool-not (has-option def $set)) (is-impl $f2))
                                    (let (Impl $b $d) $f2
                                    (let $dnf1 (dnf (def-nnf (Not $b) 1 nnf))
                                    (let $dnf2 (def-nnf $d 1 def)
                                    (Or $dnf2 $dnf1))))
                                    (def-nnf $f2 1 def))))

                                    (= (make-matrix $fml $set)
                                    (let $f1 (univar $fml Nil)
                                    (let $f2 (if (bool-and (has-option conj $set) (is-impl $f1))
                                    (mark-conj $f1)
                                    $f1)
                                (let $dnf-fml (build-dnf $f2 $set)
                                (let $m (mat $dnf-fml)
                                (let $reoDepth (get-reo-depth $set)
                                (if (> $reoDepth 0)
                                (mreorder $m $reoDepth)
                                $m)))))))

                                ;; -----------------------------------------------------------------------------
                                ;; 8. TEST RUNNER
                                ;; -----------------------------------------------------------------------------

                            !(println! "=== SOCRATES SYLLOGISM TEST ===")
                                !(make-matrix
                                    (Impl
                                        (And
                                        (All $x (Impl (pos (human $x)) (pos (mortal $x))))
                                        (pos (human socrates)))
                                        (pos (mortal socrates)))
                                        Nil)(= (marker-test) 12345)
