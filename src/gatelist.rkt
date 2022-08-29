#lang racket

(define (bufferC a) a)
(define (notC a) (not a))

(define (andC a b) (and a b))
(define (orC a b) (or a b))
(define (xorC a b) (xor a b))
(define (nandC a b) (nand a b))

(define prim-single-arity '(bufferC notC))
(define prim-dual-arity '(andC orC xorC nandC))

; (struct gate (fn argindices destidx))
(define (gate fn argindices destidx) (list fn argindices destidx))
(define (gate-fn gate) (first gate))
(define (gate-argindices gate) (second gate))
(define (gate-destidx gate) (third gate))

(define indices '(0 1 2 3 4))
 
(define single-arity
  (for*/list ([outidx indices] [inidx indices] [gatefn prim-single-arity])
      (gate gatefn `(,inidx) outidx)))

(define possible-dual-indices
  (list
   (list 0 1) (list 0 2) (list 0 3)
   (list 1 2) (list 1 3)
   (list 2 3)
   )
  )

(define dual-arity
  (for*/list ([outidx indices] [inindices possible-dual-indices] [gatefn prim-dual-arity])
    (gate gatefn inindices outidx)))

(define gates (append single-arity dual-arity))

(define my-first-circ (list (first gates) (third gates)))

;(define (eval-gate gate state)
;  (map (lambda (outIdx) (if (eq? (gate-destidx gate) outIdx)
;                          (eval `(,(gate-fn gate) ,@(map (curry list-ref state)
;                                               (gate-argindices gate))))
;                          (list-ref state outIdx)))
;       indices))


;(eval-gate (gate andC '(0 1) 2) '(#t #t #f #f))

;(define (eval-circ circ state) (foldl eval-gate state circ))
;(eval-circ gates '(#f #f #f #f))

(define no-corrections
  (map (lambda (input) `(,input, '(#f #f #f #f #f)))
         (cartesian-product '(#t #f) '(#t #f) '(#t #f) '(#t #f) '(#f))))


(define x-corrections '(
                     ((#f #f #f #t #f) (#t #f #f #f #f))
                     ((#t #f #f #f #f) (#f #t #f #f #f))
                     ((#t #t #f #f #f) (#f #f #t #f #f))
                     ((#f #t #t #f #f) (#f #f #f #t #f))
                     ((#f #f #t #t #f) (#f #f #f #f #t))
                     ))

(define result-map-xs '(
                     ((#f #f #f #t #f) (#t #f #f #f #f))
                     ((#t #f #f #f #f) (#f #t #f #f #f))
                     ((#t #t #f #f #f) (#f #f #t #f #f))
                     ((#f #t #t #f #f) (#f #f #f #t #f))
                     ((#f #f #t #t #f) (#f #f #f #f #t))
                     ))

(define result-map-ys '(
                     ((#t #f #t #t #f) (#t #f #f #f #f))
                     ((#t #t #f #t #f) (#f #t #f #f #f))
                     ((#t #t #t #f #f) (#f #f #t #f #f))
                     ((#t #t #t #t #f) (#f #f #f #t #f))
                     ((#f #t #t #t #f) (#f #f #f #f #t))
                     ))

(define result-map-zs '(
                     ((#t #f #t #f #f) (#t #f #f #f #f))
                     ((#f #t #f #t #f) (#f #t #f #f #f))
                     ((#f #f #t #f #f) (#f #f #t #f #f))
                     ((#t #f #f #t #f) (#f #f #f #t #f))
                     ((#f #t #f #f #f) (#f #f #f #f #t))
                     ))

(define result-map-x (make-hash (append no-corrections x-corrections)))
(hash->list result-map-x)