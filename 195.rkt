#lang racket


(define LOCATION "/usr/share/dict/words")
; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (string->list "abcdefghijklmnopqrstuvwxyz"))

(define LETTER-COUNT (make-hash))
#|
Exercise 195. Design the function starts-with#, which consumes a Letter and Dictionary and then
counts how many words in the given Dictionary start with the given Letter. Once you know that your
function works, determine how many words start with "e" in your computer’s dictionary and how many
with "z". 
|#

(define (initialize hash)
  (for-each (lambda (value)
              (hash-set! hash value 0))
              LETTERS))

(initialize LETTER-COUNT)

(define (add-to-letter-count hash letter)
  (hash-set! hash letter (+ (hash-ref hash letter) 1)))

(define (process line)
  (add-to-letter-count LETTER-COUNT (string-ref (string-downcase line) 0)))

(define (next-line-it file)
  (let ((line (read-line file 'any)))
    (unless (eof-object? line)
      (process line)
      (next-line-it file))))

(call-with-input-file LOCATION next-line-it)

(define (starts-with# letter)
  (hash-ref LETTER-COUNT letter))

(define (compare-pairs p1 p2)
  (> (cdr p1) (cdr p2)))

(define (most-frequent)
  (sort (map (lambda (value)
         (cons value (starts-with# value)))
       LETTERS)
        compare-pairs))
#|
> (starts-with# #\e)
8739
> (starts-with# #\z)
949
> 
|#