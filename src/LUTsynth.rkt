#lang rosette

;(require rosette/solver/smt/z3)
; hash is not part of the safe subset of rosette
;(current-solver (z3 #:options (hash ':parallel.enable 'true)))
;(solver-options (current-solver))

;(require rosette/solver/smt/z3)
;(current-solver (z3 #:path "/path/to/z3"))

(current-bitwidth 10) ; 170 gates, need 8 bits

(define (bufferC a) a)
(define (notC a) (not a))

(define (andC a b) (and a b))
(define (orC a b) (or a b))
(define (xorC a b) (xor a b))
(define (nandC a b) (nand a b))

(define prim-single-arity '(bufferC notC))
(define prim-dual-arity '(andC orC xorC nandC))

(define indices '(0 1 2 3 4))

(define (lookup name) (let ([table `((bufferC ,bufferC)
                                     (notC ,notC)
                                     (andC ,andC)
                                     (orC ,orC)
                                     (xorC ,xorC)
                                     (nandC ,nandC))])
                        (second (assoc name table))))

(define (gate fn argindices destidx) (list fn argindices destidx))
(define (gate-fn gate) (first gate))
(define (gate-argindices gate) (second gate))
(define (gate-destidx gate) (third gate))

(define (realise-gate gate) (list (lookup (gate-fn gate)) (gate-argindices gate) (gate-destidx gate)))


(define single-arity
  (for*/list ([outidx indices] [inidx indices] [gatefn prim-single-arity])
      (gate gatefn `(,inidx) outidx)))

(define possible-dual-indices
  (list
   '(0 1) '(0 2) '(0 3) '(0 4)
   '(1 2) '(1 3) '(1 4)
   '(2 3) '(2 4)
   '(3 4)
   )
  )

(define dual-arity
  (for*/list ([outidx indices] [inindices possible-dual-indices] [gatefn prim-dual-arity])
    (gate gatefn inindices outidx)))

(define gates (append single-arity dual-arity))

(define (eval-gate gate state)
  (map (lambda (outIdx) (if (eq? (gate-destidx gate) outIdx)
                            (apply (gate-fn gate) (map (curry list-ref state)
                                                       (gate-argindices gate)))
                            (list-ref state outIdx)))
       indices))

(define (eval-circ circ state) (foldl eval-gate state circ))

(define (gate-idx-list-to-circ gateidxs)
  (map (curry list-ref gates) gateidxs))

(define maxGateIdx (length gates))

(define-symbolic* gateindices integer? #:length 20)

(define x-corrections '(
                        ((#f #f #t #t #f) (#f #f #f #f #t))
                        ;((#t #t #t #t #f) (#f #f #f #f #f))
                        ;((#t #t #f #t #f) (#f #f #f #f #f))
                        ;((#f #t #t #t #f) (#f #f #f #f #f))
                        ;((#f #f #f #t #f) (#t #f #f #f #f))
                        ;((#t #t #f #f #f) (#f #f #t #f #f))
                        ;((#t #f #t #f #f) (#f #f #f #f #f))
                        ;((#f #f #t #f #f) (#f #f #f #f #f))
                        ;((#f #t #f #t #f) (#f #f #f #f #f))
                        ;((#t #f #t #t #f) (#f #f #f #f #f))
                        ;((#t #f #f #t #f) (#f #f #f #f #f))
                        ;((#f #f #f #f #f) (#f #f #f #f #f))
                        ;((#f #t #t #f #f) (#f #f #f #t #f))
                        ;((#f #t #f #f #f) (#f #f #f #f #f))
                        ;((#t #t #t #f #f) (#f #f #f #f #f))
                        ((#t #f #f #f #f) (#f #t #f #f #f))))

(define y-corrections '(((#f #f #t #t #f) (#f #f #f #f #f))
                        ((#t #t #t #t #f) (#f #f #f #t #f))
                        ((#t #t #f #t #f) (#f #t #f #f #f))
                        ((#f #t #t #t #f) (#f #f #f #f #t))
                        ((#f #f #f #t #f) (#f #f #f #f #f))
                        ((#t #t #f #f #f) (#f #f #f #f #f))
                        ((#t #f #t #f #f) (#f #f #f #f #f))
                        ((#f #f #t #f #f) (#f #f #f #f #f))
                        ((#f #t #f #t #f) (#f #f #f #f #f))
                        ((#t #f #t #t #f) (#t #f #f #f #f))
                        ((#t #f #f #t #f) (#f #f #f #f #f))
                        ((#f #f #f #f #f) (#f #f #f #f #f))
                        ((#f #t #t #f #f) (#f #f #f #f #f))
                        ((#f #t #f #f #f) (#f #f #f #f #f))
                        ((#t #t #t #f #f) (#f #f #t #f #f))
                        ((#t #f #f #f #f) (#f #f #f #f #f))))

(define z-corrections '(((#f #f #t #t #f) (#f #f #f #f #f))
                        ((#t #t #t #t #f) (#f #f #f #t #f))
                        ((#t #t #f #t #f) (#f #t #f #f #f))
                        ((#f #t #t #t #f) (#f #f #f #f #t))
                        ((#f #f #f #t #f) (#f #f #f #f #f))
                        ((#t #t #f #f #f) (#f #f #f #f #f))
                        ((#t #f #t #f #f) (#f #f #f #f #f))
                        ((#f #f #t #f #f) (#f #f #f #f #f))
                        ((#f #t #f #t #f) (#f #f #f #f #f))
                        ((#t #f #t #t #f) (#t #f #f #f #f))
                        ((#t #f #f #t #f) (#f #f #f #f #f))
                        ((#f #f #f #f #f) (#f #f #f #f #f))
                        ((#f #t #t #f #f) (#f #f #f #f #f))
                        ((#f #t #f #f #f) (#f #f #f #f #f))
                        ((#t #t #t #f #f) (#f #f #t #f #f))
                        ((#t #f #f #f #f) (#f #f #f #f #f))))

(define result
  (solve (assert
        (andmap (lambda (inp-outp-pair)
                  (eq?
                   (eval-circ
                    (gate-idx-list-to-circ gateindices)
                    (first inp-outp-pair))
                   (second inp-outp-pair)))
                x-corrections))))

(define (symbolic-position sym)
  (string->number (second (string-split (~s (car sym)) "$"))))

(define result-list (sort (hash->list (model result))
                          <
                          #:key symbolic-position))

(for-each (lambda (c-g-idx)
            (writeln (list (car c-g-idx)
                           (list-ref gates (cdr c-g-idx))
                           )))
          result-list)


;
;(eval-circ gates '(#f #f #f #f))