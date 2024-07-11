#lang htdp/bsl

(require 2htdp/image)
(require 2htdp/universe)

(define circle-image (circle 5 "solid" "red"))

(define (por height)
  (place-image circle-image 50 height (empty-scene 100 60)))

(define (sign x)
  (cond
    [(> x 0) 1]
    [(= x 0) 0]
    [(< x 0) -1]))

(define (por.v2 height)
  (cond [(<= height 60)
         (place-image circle-image 50 height
                      (empty-scene 100 60))]
        [(> height 60)
         (place-image circle-image 50 60
                      (empty-scene 100 60))]))

(define (por.v3 height)
  (cond
    [(<= height (- 64 (image-height circle-image)))
     (place-image circle-image 50 height
                  (empty-scene 100 60))]
    [(> height (- 64 (image-height circle-image)))
     (place-image circle-image 50 (- 64 (image-height circle-image))
                  (empty-scene 100 60))]))
       