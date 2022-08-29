#lang rosette/safe

(xor #t #t)

(define (bufferC a) (a))
(define (notC a) (not a))

(define (andC a b) (and a b))
(define (orC a b) (or a b))
(define (xorC a b) (xor a b))
(define (nandC a b) (nand a b))

(define prim_single_arity (list bufferC notC))
(define prim_dual_arity (list andC orC xorC nandC))

; the single arity gates are each gate over list 0 1 2 3 for the bit positions
; a gate is a pair (funC, list bitidxs)
(define (single_arity_gatefn gate)
  (foldl append (list) (map
                        (lambda inIdx (map (lambda outIdx (list gate outIdx (list inIdx))) (list 0 1 2 3)))
         (list 0 1 2 3)
         ))
  )

; all the dual input functions are symmetrical. Only allow indices in inc order to reduce the search space
(define possible_dual_indices
  (list
   (list 0 1) (list 0 2) (list 0 3)
   (list 1 2) (list 1 3)
   (list 2 3)
   )
  )


(define (dual_arity_gatefn gate)
  (foldl append (list) (map
                        (lambda inIdx (map (lambda outIdx (list gate outIdx inIdx)) (list 0 1 2 3)))
         possible_dual_indices
         ))
  )

;(define dual_arity
;    (foldl append (list)
;           (map
;            (lambda gate (map (lambda inpIdxs (list gate inpIdxs))
;                              possible_dual_indices))
;            prim_dual_arity))
;  )

(define single_arity (foldl append (list) (map single_arity_gatefn prim_single_arity)))
; single_arity

(define dual_arity (foldl append (list) (map dual_arity_gatefn prim_dual_arity)))
; dual_arity

(define gates (append single_arity dual_arity))

; gates

; given a gate and a state vector, returns the action of that gate on the vector.
; 
(define (apply gate invec)
  (map (lambda outIdx (if (eq? (first outIdx) (second gate))
                                   ((first gate) (map
                                                  (lambda inIdx (list-ref invec (first inIdx)))
                                                  (third gate)
                                                 ))
                                   (list-ref invec (first outIdx))
                                )
                  )
       (list 0 1 2 3)
  )
)

(define not_in1_out1 (list notC 1 (list 1)))

not_in1_out1

(second not_in1_out1)
; this should be (#f #t #f #f) but no
(apply not_in1_out1 (list #f #f #f #f))
