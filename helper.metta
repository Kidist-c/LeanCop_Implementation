

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

                ;;  SUBSTITUTION ENGINE
          
                ;;;; Substitutes $x with $y inside $term, respecting quantifier scoping
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
                ;; Traverses and substitutes inside arbitrary expression tuples
            (= (subst-expr $x $y $expr)
            (if (== $expr ())
            ()
            (let ($h $t) (decons-atom $expr)
            (let $newH (subst $x $y $h)
            (let $newT (subst-expr $x $y $t)
            (cons-atom $newH $newT))))))

                
                ;; . UNIVAR: VARIABLE RENAMING:-
                ;; To avoid  variables clashing
          
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