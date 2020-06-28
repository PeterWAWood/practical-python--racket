#lang racket

(define principal 500000.0)
(define rate 0.05)
(define payment 2684.11)
(define total_paid 0.0)

(define (pay)
  (cond
    [(<= principal 0) total_paid]
    [else (set! principal
                (- (* principal (+ 1 (/ rate 12)))
                   payment))
          (set! total_paid (+ total_paid payment))
          (pay)]))

(display "Total paid ")
(displayln (pay))
