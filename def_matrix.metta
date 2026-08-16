!(import! &self helper)
;; MAKE-MATRIX PREPROCESSOR

;; Usage:   (make-matrix $fml $settings)
    ;;
    ;;   $fml      : A First-Order Logic formula in MeTTa AST representation
;;               e.g., (Ex $y (All $x (Impl (pos (p $y)) (pos (p $x)))))
;;   $settings : Configuration flags (e.g., 'def' for Tseitin, 'nodef' for pure NNF)
;;   Returns   : A matrix (list of disjunctive clauses) in definitional clausal form
    ;;
    ;; Example:
;;   !(make-matrix (Ex $y (All $x (Impl (pos (p $y)) (pos (p $x))))) def)
    ;;
    ;; Output Matrix:
;;   (Cons (Cons (Not (pos (p $x1))) Nil)
;;         (Cons (Cons (pos (p (Skolem 1 (Cons $x1 Nil)))) Nil) Nil))
    ;;
    ;;   Equivalent Clause Set:
;;     Clause 1: [ ~(p(X1)) ]
;;     Clause 2: [  p(Skolem(1, [X1])) ]             
                ;;  DEFINITIONAL NNF & SKOLEMIZATION ENGINE (def-8)
                    
                (= (def-nnf $fml $i $set)
                (let (DefResult $nnf $defL $nextI) (def-8 $fml Nil $i $set)
                (def-3 $defL $nnf)))

                ;; def-3's base case previously only folded $a (the Not-Def
                ;; marker) into the formula via (Or $a $fml), silently dropping
                ;; $b -- the definition's actual content. For a Tseitin
                ;; definition Def_i -> content_i (i.e. Not(Def_i) OR content_i),
                ;; BOTH disjuncts must survive into the final formula so mat()
                ;; can turn each into its own clause; otherwise [Not(Def_i)]
                ;; becomes an unconditional unit clause while content_i --
                ;; what Def_i was supposed to stand for -- never gets asserted
                ;; anywhere, which is unsound.
                (= (def-3 $defL $fml)
                (case $defL
                ((Nil $fml)
                ((Cons (Pair $a (Or $b $c)) $rest)
                (def-3 (Cons (Pair $a $b) (Cons (Pair $a $c) $rest)) $fml))
                ((Cons (Pair $a $b) $rest)
                (def-3 $rest (Or $a (Or $b $fml)))))))

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

                            
                            ;;  DNF TRANSFORMER
                            
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

                                
                            ;;  MATRIX BUILDER & TAUTOLOGY DELETER (FIXED union2)
                              

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

                                        
                                        ;; REORDERING & MASTER COORDINATOR
                                        
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
                                    ;; dedup-clauses removes exact-duplicate clauses from the
                                    ;; final matrix. Tseitin/definitional clausification (def-3)
                                    ;; can legitimately produce the same Not(Def_i) marker clause
                                    ;; once per disjunct of a multi-way-split definition body --
                                    ;; each copy is logically redundant (an identical clause can
                                    ;; never offer a connection the first copy didn't already
                                    ;; offer), so removing exact duplicates is always sound and
                                    ;; never reduces what's provable; it only prunes redundant
                                    ;; search branches.
                                    (let $f1 (univar $fml Nil)
                                    (let $f2 (if (bool-and (has-option conj $set) (is-impl $f1))
                                    (mark-conj $f1)
                                    $f1)

                                (let $dnf-fml (build-dnf $f2 $set)
                                (let $m0 (mat $dnf-fml)
                                (let $m (dedup-clauses $m0 Nil)
                                (let $reoDepth (get-reo-depth $set)
                                (if (> $reoDepth 0)
                                (mreorder $m $reoDepth)
                                $m))))))))

                                (= (dedup-clauses Nil $seen) Nil)
                                (= (dedup-clauses (Cons $c $rest) $seen)
                                (if (any-clause-eq $c $seen)
                                (dedup-clauses $rest $seen)
                                (Cons $c (dedup-clauses $rest (Cons $c $seen)))))

                                ;; Two clauses are treated as duplicates if they contain the
                                ;; same literals regardless of order -- Tseitin/DNF-splitting
                                ;; from different parts of a formula (e.g. two structurally
                                ;; mirrored implications) can produce the same logical clause
                                ;; with its literals in a different order, which plain list
                                ;; equality would miss.
                                (= (any-clause-eq $c Nil) False)
                                (= (any-clause-eq $c (Cons $h $t))
                                (if (clause-set-eq $c $h) True (any-clause-eq $c $t)))

                                (= (clause-set-eq $a $b)
                                (bool-and (subset2 $a $b) (subset2 $b $a)))

                                (= (subset2 Nil $b) True)
                                (= (subset2 (Cons $h $t) $b)
                                (if (member2 $h $b) (subset2 $t $b) False))

                                