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
(define-runtime-path foo.txt "foo.txt")
(define-runtime-path bar.txt "bar.txt")
(define-runtime-path outfile.txt "outfile.txt")
(define-runtime-path Data/portfolio.csv "../../Data/portfolio.csv")
(define-runtime-path Data/portfolio.csv.gz "../../Data/portfolio.csv.gz")

(title "1.6 File Management")
(separator)

(title "File Input and Output")

(python "f = open('foo.txt', 'rt')     # Open for reading (text)")
(racket '(define f (open-input-file foo.txt #:mode 'text)))
(racket '(displayln f))

(separator)

(python "g = open('bar.txt', 'wt')     # Open for writing (text)")
(racket '(define g
  (open-output-file bar.txt
                    #:mode 'text
                    #:exists 'replace)))
(racket '(displayln g))

(separator)

(python "data = f.read()")
(expect "start12345678901234567890end\nline 2\nline 3\n")
; read in racket is line oriented, so use port->string function
(racket '(displayln (port->string f)))
(racket "There is an easier way to read a file into a string in Racket")
(racket '(file->string foo.txt)) 
(separator)

(python "# Read only up to 'maxbytes' bytes")
(python "data = f.read([maxbytes])")
; need to reset foo.txt
(racket '(close-input-port f))
(racket '(set! f (open-input-file foo.txt #:mode 'text)))
(expect "start")
(racket '(displayln (read-string 5 f)))

(separator)

(python "g.write('some text')")
(racket '(write "some text" g))

(separator)

(python "f.close()")
(python "g.close()")
(racket '(close-input-port f))
(racket '(close-output-port g))

(separator)
(title "Common Idioms for Reading File Data")
(separator)

(python "with open('foo.txt', 'rt') as file:")
(python "    data = file.read()")
(expect "start12345678901234567890end\nline 2\nline 3\n")
(racket '(displayln (file->string foo.txt #:mode 'text)))

(separator)

(python "with open(filename, 'rt') as file:")
(python "    for line in file:")
(expect "start12345678901234567890end")
(expect "line 2")
(expect "line 3")
(racket '(define lines (file->lines foo.txt)))
(racket '(for-each (lambda (l) (displayln l)) lines))

(separator)
(title "Common Idioms for Writing to a File")
(separator)

(python "with open('outfile', 'wt') as out:")
(python "    out.write('Hello World')")
(expect "Hello World\\n")
(racket '(write-to-file "Hello World\n"
                        outfile.txt
                        #:mode 'text
                        #:exists 'replace))
(racket '(displayln (file->lines outfile.txt #:mode 'text)))

(separator)


(python "with open('outfile', 'wt') as out:")
(python "    print('Hello World', file=out)")
; racket print will enclose string in quotes
(expect "\"Hello World\"")
(racket '(with-output-to-file "outfile.txt" 
                     (lambda () (print "Hello World"))
                     #:mode 'text
                     #:exists 'replace))
(racket '(with-input-from-file outfile.txt
                      (lambda () (displayln (read-string 13)))
                      #:mode 'text))

(separator)
(title "Exercises")
(separator)

(title "Exercises: pre-amble")
(python ">>> import os")
(python ">>> os.getcwd()")
(racket '(displayln (current-directory)))

(separator)
(title "Exercise 1.26: File Preliminaries")
(separator)

(python ">>> with open('../../Data/portfolio.csv', 'rt') as f:")
(python "        data = f.read()")
(expect "name,shares,price")
(expect "\"AA\",100,32.20")
(expect "\"IBM\",50,91.10")
(expect "\"CAT\",150,83.44")
(expect "\"MSFT\",200,51.23")
(expect "\"GE\",95,40.37")
(expect "\"MSFT\",50,65.10")
(expect "\"IBM\",100,70.44")
(racket '(displayln (file->string Data/portfolio.csv #:mode 'text)))

(separator)

(python ">>> with open('../../Data/portfolio.csv', 'rt') as f:")
(python "        for line in f:")
(python "            print(line, end='')")
(expect "name,shares,price")
(expect "\"AA\",100,32.20")
(expect "\"IBM\",50,91.10")
(expect "\"CAT\",150,83.44")
(expect "\"MSFT\",200,51.23")
(expect "\"GE\",95,40.37")
(expect "\"MSFT\",50,65.10")
(expect "\"IBM\",100,70.44")
(racket '(for-each (lambda (l) (displayln l))
          (file->lines Data/portfolio.csv #:mode 'text)))

(separator)
(python ">>> f = open('Data/portfolio.csv', 'rt')")
(python ">>> headers = next(f)")
(python ">>> headers")
(python ">>> for line in f:")`
(python "        print(line, end='')")
(expect "\"AA\",100,32.20")
(expect "\"IBM\",50,91.10")
(expect "\"CAT\",150,83.44")
(expect "\"MSFT\",200,51.23")
(expect "\"GE\",95,40.37")
(expect "\"MSFT\",50,65.10")
(expect "\"IBM\",100,70.44")
(racket '(define csv-lines (file->lines Data/portfolio.csv #:mode 'text)))
(racket '(for-each (lambda (l) (displayln l)) (rest csv-lines)))

(separator)

; a method closer to the python example
(racket '(displayln "Now, in a way more like the python example"))
(racket '(define f (open-input-file Data/portfolio.csv #:mode 'text)))
(racket '(define headers (read-line f)))
; this uses the fact that the headers have been "removed" from the port
; so then reads the whole file into memory. Just liek the Python example
(racket '(define rows (port->lines f)))
(racket '(close-input-port f))
(racket '(displayln headers))
(racket '(for-each (lambda (r) (displayln r)) rows ))

(separator)
(title "Exercise 1.27: Reading a data file")
(separator)
(expect "Total cost 44671.15")
(racket '(define csv-rows (file->lines Data/portfolio.csv #:mode 'text)))
(racket '(define (pcost rows)
 (cond
   [(empty? rows) 0]
   [else (define row (string-split (first rows) ","))
         (+ (* (string->number (second row))
               (string->number (third row)))
            (pcost (rest rows)))])))
(racket '(display "Total cost "))
(racket '(displayln (pcost (rest csv-rows))))

(separator)
(title "Exercise 1.28: Other kinds of 'files'")
(separator)

(python ">>> import gzip")
(python ">>> with gzip.open('../../Data/portfolio.csv.gz', 'rt') as f:")
(python "    for line in f:")
(python "        print(line, end='')")
(expect "name,shares,price")
(expect "\"AA\",100,32.20")
(expect "\"IBM\",50,91.10")
(expect "\"CAT\",150,83.44")
(expect "\"MSFT\",200,51.23")
(expect "\"GE\",95,40.37")
(expect "\"MSFT\",50,65.10")
(expect "\"IBM\",100,70.44")
(racket '(require file/gunzip))
(racket '(define gzip (open-input-file Data/portfolio.csv.gz)))
(racket '(define csv (open-output-string)))
(racket '(gunzip-through-ports gzip csv))
(racket '(displayln (get-output-string csv)))

; tidy up
(when (file-exists? outfile.txt) (delete-file outfile.txt))
