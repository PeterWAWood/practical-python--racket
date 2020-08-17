#lang racket

(require csv-reading)

; get the filename from the command line
(define filename (vector-ref (current-command-line-arguments) 0))

; define the function to calculate the cost of the portfolio
(define (portfolio-cost filename)
  ; pcost - an internal function to perform the "loop"
  (define (pcost rows)
    (cond
      [(empty? rows) 0]
      [else (+ (with-handlers ([exn:fail:contract?
                               (lambda (err)
                                 (display "Couldn't Parse ")
                                 (displayln (first rows))
                                 0)])
                 (* (string->number (second (first rows)))
                    (string->number (third (first rows)))))
               (pcost (rest rows)))]))
  (define csv-rows (call-with-input-file filename csv->list))
  (pcost (rest csv-rows)))

; calculate the cost of the portfolio in the file provided
(define total-cost (portfolio-cost filename))
(display "Total cost: ")
(displayln total-cost)



