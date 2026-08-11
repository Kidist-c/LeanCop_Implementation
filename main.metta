  !(import! &self leancop21)
  
  ;; ---. TOP-LEVEL ENTRY POINT ---

(= (prove-matrix-core $fml $maxLimit)
(let $matrix (make-matrix $fml Nil)
(let $_clear (collapse (clear-db))
(let $startMode (if (member2 (Cons (Not #) Nil) $matrix) conj pos)
(let $_assert (collapse (assert-clauses $matrix $startMode))
(prove-loop 1 $maxLimit))))))