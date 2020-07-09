#lang racket

(define principal 500000.0)
(define rate 0.05)
(define payment 2684.11)
(define total-paid 0.0)
(define number-months 0)

(define (pay)
  (cond
    [(<= principal 0) total-paid]
    [else (set! principal
                (- (* principal (+ 1 (/ rate 12)))
                   payment))
          (set! total-paid (+ total-paid payment))
          (set! number-months (add1 number-months))
          (when (< number-months 13)
            (set! total-paid (+ total-paid 1000))
            (set! principal (- principal 1000)))
          (pay)]))

(display "Total paid ")
(display (pay))
(display " in ")
(display number-months)
(displayln " months.")