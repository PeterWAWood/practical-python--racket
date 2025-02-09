#lang racket
(require test-engine/racket-tests)

; constants
(define LOAN 500000.00)
(define INT_RATE 0.05)
(define MTHLY_PAYMENT 2684.11)
(define E_P_START 61)
(define E_P_END 108)
(define E_P_PAYMENT 1000)

; data definitions
(define-struct mortgage
   [balance rate payment
    e-p-start e-p-end e-p-payment
    num-payments total-paid])

; data
(define daves-mortgage
  (make-mortgage LOAN INT_RATE MTHLY_PAYMENT
                 E_P_START E_P_END E_P_PAYMENT
                 0 0.00))

; functions
(check-within (apply-interest 100 1.20) 110.0 1e-5)
(define (apply-interest balance rate)
  (* balance (add1 (/ rate 12))))

(check-within (payment (make-mortgage 1000 .10 100 2 4 0 0 0.00))
                       100
                       1e-5)
(check-within (payment (make-mortgage 1000 .10 100 2 4 200 1 0.00))
                       300
                       1e-5)
(check-within (payment (make-mortgage 1000 .10 100 2 4 200 3 0.00))
                       300
                       1e-5)
(check-within (payment (make-mortgage 1000 .10 300 2 4 200 4 0.00))
                       300
                       1e-5)
(define (payment mortgage)
  (cond
    [(and (>= (add1 (mortgage-num-payments mortgage))
              (mortgage-e-p-start mortgage))
          (<= (add1 (mortgage-num-payments mortgage))
              (mortgage-e-p-end mortgage)))
     (+ (mortgage-payment mortgage)
        (mortgage-e-p-payment mortgage))]
    [else (mortgage-payment mortgage)]))

(define (pay mortgage)
  (cond
    [(<= (mortgage-balance mortgage) 0)
     (cons (mortgage-total-paid mortgage)
           (mortgage-num-payments mortgage))]
    [else
     (display (add1 (mortgage-num-payments mortgage)))
     (display " ")
     (display (+ (mortgage-total-paid mortgage)
                   (payment mortgage)))
     (display " ")
     (displayln (- (apply-interest
                    (mortgage-balance mortgage)
                    (mortgage-rate mortgage))
                    (payment mortgage)))
     (pay (make-mortgage
                (- (apply-interest
                    (mortgage-balance mortgage)
                    (mortgage-rate mortgage))
                    (payment mortgage))
                (mortgage-rate mortgage)
                (mortgage-payment mortgage)
                (mortgage-e-p-start mortgage)
                (mortgage-e-p-end mortgage)
                (mortgage-e-p-payment mortgage)
                (add1
                 (mortgage-num-payments mortgage))
                (+ (mortgage-total-paid mortgage)
                   (payment mortgage))))]))

(test)

; The "program"
(define result (pay daves-mortgage))
(display "Total paid ")
(display (car result))
(display " in ")
(display (cdr result))
(displayln " months.")

