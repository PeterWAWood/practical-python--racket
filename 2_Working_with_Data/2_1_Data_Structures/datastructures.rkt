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

; definitions to handle script being run from different directories
(define-runtime-path Data/portfolio.csv "../../Data/portfolio.csv")

(title "2.1 Datatypes and Data Structures")
(separator)

(title " None type")
(python "email_address = None")
(racket '(define email_address null))
(racket "Note: null is a constant defined as an empty list")
(racket '(displayln (equal? null '())))
(python "None evaluates to false when used in a conditional")
(racket "null evaluates to true when used in a conditional")

(separator)
(title "Data Structures")
(python "Python has many data structures, this section introduces two of them:")
(python "Tuples and Dictionaries")
(racket "Also has many data structures, some of which can be used to emulate tuples and dictionaries")


(separator)
(title "Tuples")
(python "Tuples are often used to represent simple records.")
(python "s = ('GOOG', 100, 490.1)")
(racket "Tuples are very similar to Racket lists.")
(racket '(define s '("GOOG" 100 490.1)))
(racket '(displayln s))
(separator)

(python "Tuple contents are ordered and accessed like Python lists")
(python "name = s[0]                 # 'GOOG'")
(python "shares = s[1]               # 100")
(python "price = s[2]                # 490.1")
(racket '(define name (list-ref s 0)))
(racket '(displayln name))
(racket '(define shares (list-ref s 1)))
(racket '(displayln shares))
(racket '(define price (list-ref s 2)))
(racket '(displayln price))

(separator)
(python "Tuples are immutable")
(racket "Lists are immutable")
(python "You can make a new tuple based on a current one")
(python "s = (s[0], 75, s[2])")
(racket "Makes this a little easier")
(racket '(set! s (list-set s 1 75)))
(racket '(displayln s))

(separator)
(title "Tuple Unpacking")
(python "You can \"unpack\" a tuple into multiple variables")
(python "name, shares, price = s")
(racket "There is no equivalent as far as I can tell")
(racket "Though I'm sure that this could be emulated by using macros")

(separator)
(title "Dictionaries")
(python "A dictionary is a hash table")
(python "s = {
    'name': 'GOOG',
    'shares': 100,
    'price': 490.1
}")
(racket "Does not have any similar literal form for hash tables")
(racket '(define s (make-hash)))
(racket '(hash-set! s "name" "GOOG"))
(racket '(hash-set! s "shares" 100))
(racket '(hash-set! s "price" 490.1))
(racket '(displayln s))

(separator)
(title "Common Operations")
(python "To get values from a dictionary use the key names")
(python ">>> print(s['name'], s['shares'])")
(python "GOOG 100")
(python ">>> s['price']")
(python "490.10")
(racket '(display (string-append (hash-ref s "name") " ")))
(racket '(displayln (hash-ref s "shares")))
(racket '(displayln (hash-ref s "price")))

(separator)
(python "To add or modify values assign the key names")
(python ">>> s['shares'] = 75")
(python ">>> s['date'] = '6/6/2007'")
(racket '(hash-set! s "shares" 75))
(racket '(hash-set! s "date" "6/6/2007"))
(racket '(displayln s))

(separator)
(python "To delete a value use the del statement")
(python ">>> del s['date']")
(racket '(hash-remove! s "date"))
(racket '(displayln s))

(separator)
(title "Exercises")
(separator)
(python "The exercise is centred around processing a csv file")
(python ">>> import csv")
(python ">>> f = open('Data/portfolio.csv')")
(python ">>> rows = csv.reader(f)")
(python ">>> next(rows)")
(python "['name', 'shares', 'price']")
(python ">>> row = next(rows)")
(python ">>> row")
(python "['AA', '100', '32.20']")
(racket '(require csv-reading))
(racket '(define rows (call-with-input-file Data/portfolio.csv csv->list)))
(racket '(displayln (first rows)))
(racket '(set! rows (rest rows)))
(racket '(displayln (first rows)))

(separator)
(title "Exercise 2.1:Tuples")
(python ">>> t = (row[0], int(row[1]), float(row[2]))")
(python ">>> t")
(python "('AA', 100, 32.2)")
(racket '(define row (first rows)))
(racket '(define t (cons (first row)
                         (cons (string->number (second row))
                               (cons (string->number (third row)) '())))))
(racket '(println t))
(separator)
(python ">>> cost = t[1] * t[2]")
(python ">>> cost")
(python "3220.0000000000005")
(racket '(define cost (* (second t) (third t))))
(racket '(println cost))

(separator)
(python ">>> print(f'{cost:0.2f}')")
(python "3220.00")
(racket '(displayln (~r cost
                        #:precision '(= 2))))

(separator)
(python ">>> t = (t[0], 75, t[2])")
(python ">>> t")
(python "('AA', 75, 32.2)")
(racket '(set! t (list-set t 1 75)))
(racket '(println t))

(separator)
(python ">>> name, shares, price = t")
(python ">>> name")
(python "'AA'")
(python ">>> shares")
(python "75")
(python ">>> price")
(python "32.2")
(racket "name, shares and price have been defined earlier")
(racket "so set! has to be used")
(racket '(set! name (first t)))
(racket '(set! shares (second t)))
(racket '(set! price (third t)))
(racket '(displayln name))
(racket '(displayln shares))
(racket '(displayln price))

(separator)
(python ">>> t = (name, 2*shares, price)")
(python ">>> t")
(python "('AA', 150, 32.2)")
(racket '(set! t '(name (* shares 2) price)))
(racket '(println t))

(separator)
(title "Exercise 2.2: Dictionaries as a data structure")
(python ">>> d = {")
(python "        'name' : row[0],")
(python "        'shares' : int(row[1]),")
(python "        'price'  : float(row[2])")
(python "    }")
(python ">>> d")
(python "{'name': 'AA', 'shares': 100, 'price': 32.2 }")
(racket '(define h (make-hash)))
(racket '(hash-set! h "name" "AA"))
(racket '(hash-set! h "shares" 100))
(racket '(hash-set! h "price" 32.2))
(racket '(displayln h))

(separator)
(python ">>> cost = d['shares'] * d['price']")
(python ">>> cost")
(python "3220.0000000000005")
(racket '(define cost (* (hash-ref h "shares") (hash-ref h "price"))))
(racket '(displayln cost))

(separator)
(python ">>> d['shares'] = 75")
(python ">>> d")
(python "{'name': 'AA', 'shares': 75, 'price': 32.2 }")
(racket '(hash-set! h "shares" 75))
(racket '(displayln h))

(separator)
(python ">>> d['date'] = (6, 11, 2007)")
(python ">>> d['account'] = 12345")
(python ">>> d")
(python "{'name': 'AA', 'shares': 75, 'price':32.2, 'date': (6, 11, 2007), 'account': 12345}")
(racket '(hash-set! h "date" '(6 11 2007)))
(racket '(hash-set! h "account" 12345))
(racket '(displayln h))


(separator)
(title "Exercise 2.3: Some additional dictionary operations")
(python ">>> list(d)")
(python "['name', 'shares', 'price', 'date', 'account']")
(racket '(displayln (hash-keys h)))

(separator)
(python ">>> for k in d:")
(python "        print('k =', k)")
(python "")
(python "k = name")
(python "k = shares")
(python "k = price")
(python "k = date")
(python "k = account")
(racket '(for-each (lambda (k) (printf "k = ~a\n" k)) (hash-keys h)))

(separator)
(python ">>> for k in d:")
(python "        print(k, '=', d[k])")
(python "")
(python "name = AA")
(python "shares = 75")
(python "price = 32.2")
(python "date = (6, 11, 2007)")
(python "account = 12345")
(racket '(hash-for-each h (lambda (k v) (printf "~a = ~a\n" k v))))

(separator)
(python ">>> keys = d.keys()")
(python ">>> keys")
(python "dict_keys(['name', 'shares', 'price', 'date', 'account'])")
(racket '(define keys (hash-keys h)))
(racket '(println keys))

(separator)
(python ">>> del d['account']")
(python ">>> keys")
(python "dict_keys(['name', 'shares', 'price', 'date'])")
(racket '(hash-remove! h "account"))
(racket '(println keys))

(separator)
(python ">>> items = d.items()")
(python ">>> items")
(python "dict_items([('name', 'AA'), ('shares', 75), ('price', 32.2), ('date', (6, 11, 2007))])")
(racket '(define items (hash->list h)))
(racket '(println items))

(separator)
(python ">>> for k, v in d.items():")
(python "        print(k, '=', v)")
(python "")
(python "name = AA")
(python "shares = 75")
(python "price = 32.2")
(python "date = (6, 11, 2007)")
(racket '(for-each (lambda (pair) (printf "~a = ~a\n" (car pair) (cdr pair))) items))

(separator)
(python ">>> items")
(python "dict_items([('name', 'AA'), ('shares', 75), ('price', 32.2), ('date', (6, 11, 2007))])")
(python ">>> d = dict(items)")
(python ">>> d")
(python "{'name': 'AA', 'shares': 75, 'price':32.2, 'date': (6, 11, 2007)}")
(racket '(displayln (make-hash items)))




