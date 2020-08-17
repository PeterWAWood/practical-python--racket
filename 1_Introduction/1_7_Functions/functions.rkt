#lang racket
(require racket/runtime-path)

(define-namespace-anchor anchor)
(define ns (namespace-anchor->namespace anchor))

(define (expect txt)
  (displayln (string-append "Expect: " txt)))
(define (python py)
  (displayln (string-append "Python: "  py)))
(define (racket rkt)
  (cond
    [(list? rkt) (display "Racket: ")
                 (writeln rkt)
                 (eval rkt ns)]
    [(string? rkt) (displayln (string-append "Racket: " rkt))]
    [else          (displayln "Racket: Oops")]))
(define (separator) (displayln ""))
(define (title ttl) (displayln (string-upcase ttl)))

; definition to handle script being run from different directories
(define-runtime-path Data/portfolio.csv "../../Data/portfolio.csv")


(title "1.7 Functions")
(separator)

(title "Custom Functions")
(separator)

(python "def sumcount(n):")
(python "    '''")
(python "    Returns the sum of the first n integers")
(python "    '''")
(python "    total = 0")
(python "    while n > 0:")
(python "        total += n")
(python "        n -= 1")
(python "    return total")
(racket '(define (sumcount n)
  (define (sc n total)
    (cond
      [(= n 0) total]
      [else (sc (- n 1) (+ total n))]))
  (sc n 0)))
(expect "10")
(racket '(displayln (sumcount 4)))

(separator)
(title "Library Functions")
(separator)

(python "import math")
(python "x = math.sqrt")
(racket '(sqrt 9))

(separator)
(python "import urllib.request")
(python "u = urllib.request.urlopen('http://www.python.org/')")
(python "data = u.read()")
(racket "require net/url")
(racket "(call/input-url (string->url \"https://racket-lang.org\")
                         get-pure-port
                         port->string)")
(separator)
(title "Catching and Handling Exceptions")
(separator)

(python "    try:")
(python "        shares = int(fields[1])")
(python "    except ValueError:")
(python "        print(\"Couldn't parse\", line)")

(separator)
(racket "(with-handlers ([exn:fail:contract?")
(racket "                 (lambda (err)")
(racket "                   (display \"Couldn't Parse \")")
(racket "                   (displayln field))])")
(racket "  (string->number field))")

(separator)
(title "Raising Exceptions")
(separator)

(python "raise RuntimeError('What a kerfuffle')")
(racket "(raise \"What a kerfuffle\")")

(separator)
(title "Exercises")
(separator)
(title "Exercise 1.29: Defining a function")
(separator)

(python ">>> def greeting(name):")
(python "        'Issues a greeting'")
(python "        print('Hello', name)")
(separator)
(python ">>> greeting('Guido')")
(python "Hello Guido")
(python ">>> greeting('Paula')")
(python "Hello Paula")
(separator)
(racket '(define (greeting name)
           (displayln (string-append "Hello " name))))
(racket '(greeting "Guido"))
(racket '(greeting "Paula"))


