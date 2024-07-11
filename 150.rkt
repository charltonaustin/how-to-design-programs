;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise-150) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|
Exercise 150. Design the function add-to-pi. It consumes a natural number n and adds it to pi without using the primitive + operation. Here is a start:
Once you have a complete definition, generalize the function to add, which adds a natural number n to some arbitrary number x without using +. Why does the skeleton use check-within? 
|#

; N -> Number
; computes (+ n pi) without using +
 
(check-within (add-to-pi 3) (+ 3 pi) 0.001)
(define (add-to-pi n)
  (add-internal pi n))
  
(define (add-internal value n)
  (cond
    [(zero? n) value]
    [else (add-internal (add1 value) (sub1 n))]))