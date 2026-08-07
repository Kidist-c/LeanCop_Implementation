;; =============================================================================
;; LEANCOP21.METTA - CONNECTION TABLEAU PROVER ENGINE
;; =============================================================================

;; 1. IMPORT CLAUSAL FORM PREPROCESSOR & UTILITIES
!(import! &self def_matrix)

    ;; --- 2. PROVER UTILITIES ---
    ;; clear-db was previously called but never defined, so MeTTa silently
;; treated `(clear-db)` as an inert unevaluated atom and the `lit` facts
    ;; from a prior run were never actually removed from &self.
(= (clear-db) (collapse (match &self (lit $l $c $g) (remove-atom &self (lit $l $c $g)))))

    ;; Standardized negation to '-' matching def_matrix
    ;; lit-neg: matches def_matrix.metta's convention where negative literals are
;; tagged (Not $p) and positive literals are bare. A bare '-' isn't usable since
    ;; it's grounded arithmetic subtraction in MeTTa, so we wrap with Not both ways.
;; Uses `case` (not overlapping `=` rules) so only one branch fires per input.
(= (lit-neg $p)
    (case $p
    (((Not $q) $q)
    ($_        (Not $p)))))

    (= (has-neg $lst)
        (case $lst
        ((Nil False)
        ((Cons (Not $x) $t) True)
        ((Cons (Neg $x) $t) True)
        ((Cons $h $t) (has-neg $t)))))

        ;; check-ground: previously had a `((v $x) False)` branch left over from the
        ;; old (v $x) variable-wrapping scheme. That branch was not just dead code --
            ;; MeTTa's `case` pattern-matching unifies bidirectionally, so matching a truly
        ;; free/unbound variable scrutinee against the pattern (v $x) silently BOUND
        ;; that variable to (v $x), corrupting the shared variable everywhere else it
        ;; was used in the clause (e.g. right before it gets stored via add-atom).
            ;; A bare unbound variable must instead be detected directly via get-metatype.
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

    ;; --- 3. CONNECTION CALCULUS RULES ---

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

    ;; --- 4. CORE PROVER ENGINE ---
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

    ;; --- 5. TOP-LEVEL ENTRY POINT ---
;; NOTE: each throwaway binding below uses a DISTINCT name ($_clear, $_assert).
;; Reusing the same name ($_) for both, as originally written, made MeTTa treat
    ;; them as the SAME variable within this one function body -- since
;; (collapse (clear-db)) and (collapse (assert-clauses ...)) return different
    ;; values, the second `let` would then silently fail to unify against the
    ;; first binding, making the whole function produce zero results instead of a
    ;; real ProofSuccess/ProofFailed.
(= (prove-matrix-core $fml $maxLimit)
(let $matrix (make-matrix $fml Nil)
(let $_clear (collapse (clear-db))
(let $startMode (if (member2 (Cons (Not #) Nil) $matrix) conj pos)
(let $_assert (collapse (assert-clauses $matrix $startMode))
(prove-loop 1 $maxLimit))))))