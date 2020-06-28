#lang racket
(require test-engine/racket-tests)

; data definitions
(define-struct mortgage
   [balance rate payment num-payments total-paid])

; data
(define daves-mortgage
  (make-mortgage 500000.00 0.05 2684.11 0.00 0.00))

; functions
(check-within (apply-interest 100 1.20) 110.0 1e-5)
(define (apply-interest balance rate)
  (* balance (add1 (/ rate 12))))

(check-within (pay daves-mortgage) 966279.6 1e-5)
(define (pay mortgage)
  (cond
    [(<= (mortgage-balance mortgage) 0)
     (mortgage-total-paid mortgage)]
    [else (pay (make-mortgage
                (- (apply-interest
                    (mortgage-balance mortgage)
                    (mortgage-rate mortgage))      
                (mortgage-payment mortgage))
                (mortgage-rate mortgage)
                (mortgage-payment mortgage)
                (add1
                 (mortgage-num-payments mortgage))
                (+ (mortgage-total-paid mortgage)
                (mortgage-payment mortgage))))]))

(test)

; The "program"
(display "Total paid ")
(displayln (pay daves-mortgage))

