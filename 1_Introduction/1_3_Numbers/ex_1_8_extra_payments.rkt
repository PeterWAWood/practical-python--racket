#lang racket
(require test-engine/racket-tests)

; constants
(define LOAN 500000.00)
(define INT_RATE 0.05)
(define MTHLY_PAYMENT 2684.11)

; data definitions
(define-struct mortgage
   [balance rate payment num-payments total-paid])

; data
(define daves-mortgage
  (make-mortgage LOAN INT_RATE MTHLY_PAYMENT 0 0.00))

; functions
(check-within (apply-interest 100 1.20) 110.0 1e-5)
(define (apply-interest balance rate)
  (* balance (add1 (/ rate 12))))

(check-within (payment (make-mortgage 1000 .10 100 0 0.00))
                       1100
                       1e-5)
(check-within (payment (make-mortgage 1000 .10 1110 1 0.00))
                       1110
                       1e-5)
(check-within (payment (make-mortgage 1000 .10 1120 11 0.00))
                       1120
                       1e-5)
(check-within (payment (make-mortgage 1000 .10 1300 12 0.00))
                       300
                       1e-5)
(define (payment mortgage)
  (cond
    [(= (mortgage-num-payments mortgage) 0)
     (+ (mortgage-payment mortgage) 1000)]
    [(= (mortgage-num-payments mortgage) 12)
     (- (mortgage-payment mortgage) 1000)]
    [else (mortgage-payment mortgage)]))

(check-within (car (pay daves-mortgage)) 929965.62 1e-5)
(check-expect (cdr (pay daves-mortgage)) 342)
(define (pay mortgage)
  (cond
    [(<= (mortgage-balance mortgage) 0)
     (cons (mortgage-total-paid mortgage)
           (mortgage-num-payments mortgage))]
    [else (pay (make-mortgage
                (- (apply-interest
                    (mortgage-balance mortgage)
                    (mortgage-rate mortgage))
                    (payment mortgage))
                (mortgage-rate mortgage)
                (payment mortgage)
                (add1
                 (mortgage-num-payments mortgage))
                (+ (mortgage-total-paid mortgage)
                (mortgage-payment mortgage))))]))

(test)

; The "program"
(display "Total paid ")
(display (car (pay daves-mortgage)))
(display " in ")
(display (cdr (pay daves-mortgage)))
(displayln " months.")

