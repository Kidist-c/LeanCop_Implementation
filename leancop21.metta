
!(import! &self def_matrix)


;;Connection Rules (`extend-rule`):
    ;;      Applies connection calculus rules non-deterministically:
    ;;        - Lemma Reuse   : Subgoal solved if present in proven $lem list.
    ;;        - Path Reduction: Subgoal closed if $negLit exists on active $path.
    ;;        - Extension Step: Connects $negLit to indexed clause in &self space.
    ;;
;;   4. Proof Engine (`prove` & `prove-loop`):
    ;;      Recursively solves subgoals while maintaining active $path and $lem,
    ;;      wrapping search inside `prove-loop` for complete iterative deepening.
    ;;--- PROVER UTILITY FUNCTIONS ---
    ;; Clear all indexed leteral from the from MeTTa space
    
(= (clear-db) (collapse (match &self (lit $l $c $g) (remove-atom &self (lit $l $c $g)))))

   
    ;; Nagate literal
(= (lit-neg $p)
    (case $p
    (((Not $q) $q)
    ($_        (Not $p)))))

        ;; check if Calause has any negative literal
    (= (has-neg $lst)
        (case $lst
        ((Nil False)
        ((Cons (Not $x) $t) True)
        ((Cons (Neg $x) $t) True)
        ((Cons $h $t) (has-neg $t)))))

    
        (= (check-ground $term)
        (if (== (get-metatype $term) Variable)
            False
        (if (== (get-metatype $term) Expression)
        (check-ground-expr $term)
        True)))

    (= (check-ground-expr $expr)
    (if (== $expr ())
        True
    (let ($h $t) (decons-atom $expr)
    (bool-and (check-ground $h) (check-ground-expr $t)))))


        ;; Assert  a matrix of clause into $self with indexed head
    (= (assert-clauses Nil $set) True)
    (= (assert-clauses (Cons $c $m) $set)
    (let $c1 (if (bool-and (bool-not (== $set conj)) (bool-not (has-neg $c)))
    (Cons # $c)
    $c)
(let $g (if (check-ground $c1) g n)
(let $_ (assert-clauses2 $c1 Nil $g)
(assert-clauses $m $set)))))

(= (assert-clauses2 Nil $c1 $g) True)
(= (assert-clauses2 (Cons $l $c) $c1 $g)
(let $c2 (append-list $c1 $c)
(let $_ (add-atom &self (lit $l $c2 $g))
(let $c3 (append-list $c1 (Cons $l Nil))
(assert-clauses2 $c $c3 $g)))))

(= (check-loop Nil $path) False)
(= (check-loop (Cons $litC $cla) $path)
(if (member2 $litC $path)
    True
(check-loop $cla $path)))

    ;; --- . CONNECTION CALCULUS RULES ---

    ;; Lemma Rule: Literal is in Lem
(= (extend-rule $lit $negLit $path $pathLim $lem $set)
(if (member2 $lit $lem)
(BranchResult Nil Nil)
(empty)))

    ;; Reduction Rule: Negated literal is on current Path
(= (extend-rule $lit $negLit $path $pathLim $lem $set)
(if (member2 $negLit $path)
(BranchResult Nil Nil)
(empty)))

    ;; Extension Rule: Connect with a clause in the database
(= (extend-rule $lit $negLit $path $pathLim $lem $set)
(match &self (lit $negLit $cla1 $grnd)
(if (or (== $grnd g) (< (list-length $path) $pathLim))
(let $subProof (prove $cla1 (Cons $lit $path) $pathLim $lem $set)
(BranchResult $cla1 $subProof))
(empty))))


    ;; --- . CORE PROVER ENGINE ---
(= (prove Nil $path $pathLim $lem $set) Nil)
(= (prove (Cons $lit $cla) $path $pathLim $lem $set)
(if (check-loop (Cons $lit $cla) $path)
(empty)
(let $negLit (lit-neg $lit)
(let (BranchResult $cla1 $proof1) (extend-rule $lit $negLit $path $pathLim $lem $set)
(let $proof2 (prove $cla $path $pathLim (Cons $lit $lem) $set)
(Cons (ProofBranch (Cons $negLit $cla1) $proof1) $proof2))))))


(= (prove-loop $currentLim $maxLimit)
(if (> $currentLim $maxLimit)
(ProofFailed $maxLimit)
(let $startLit (Cons (Not #) Nil)
(let $result (collapse (prove $startLit Nil $currentLim Nil Nil))
(if (== $result ())
(prove-loop (+ $currentLim 1) $maxLimit)
(ProofSuccess $currentLim $result))))))


   