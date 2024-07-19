#lang racket
(require quickcheck)
(require algorithms)

; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort> l)
  (cond
    [(empty? l) '()]
    [(cons? l) (insert (first l) (sort> (rest l)))]))
 
; Number List-of-numbers -> List-of-numbers
; inserts n into the sorted list of numbers l 
(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (>= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))

(define sorted-list
  (property
   ([unsorted-list (choose-list (choose-integer -500 500) 100)])
   (define sorted-list (reverse (sort> unsorted-list)))
   (sorted? sorted-list)
   (= (length sorted-list) (length unsorted-list))))

; List-of-numbers -> List-of-numbers
; produces a sorted version of l
(define (sort>/bad l)
  (list 9 8 7 6 5 4 3 2 1 0))

(define failed-sorted-list
  (property
   ([unsorted-list (choose-list (choose-integer -500 500) 100)])
   (define sorted-list (reverse (sort>/bad unsorted-list)))
   (sorted? sorted-list)
   (= (length sorted-list) (length unsorted-list))))

(quickcheck sorted-list) ; OK, passed 100 tests.
(quickcheck failed-sorted-list) #|
Falsifiable, after 0 tests:
unsorted-list = (-284 202 -189 -140 -373 285 -483 264 -469 -271 -100 -180 -497 81 -398 177 -109 -96
182 377 68 -206 397 144 -342 477 -10 -332 36 -385 -303 -402 316 -186 36 -61 -6 423 -322 106 -375 0
192 -197 -444 238 12 104 -33 344 446 -184 218 492 -301 -426 411 428 -436 -229 -67 -264 8 -403 -310
301 -421 -387 282 -355 171 -73 -410 400 406 -249 -31 242 -48 -394 -23 421 -459 -200 -15 280 422 -296
-77 -275 383 167 -435 -160 -328 -371 241 -174 -236 -490)
|#
