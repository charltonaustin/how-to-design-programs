#lang htdp/bsl

(require 2htdp/image)
(require 2htdp/universe)

(define WIDTH-OF-WORLD 200)
 
(define WHEEL-RADIUS 5)

(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))

(define WHEEL
  (circle WHEEL-RADIUS "solid" "black"))

(define SPACE
  (rectangle 10 WHEEL-RADIUS "solid" "white"))

(define BOTH-WHEELS
  (beside WHEEL SPACE WHEEL))

(define TOP
  (rectangle (* 4 WHEEL-RADIUS) WHEEL-RADIUS "solid" "red"))

(define BODY
   (rectangle (* 8 WHEEL-RADIUS) (* 3 WHEEL-RADIUS) "solid" "red"))

(define NO-WHEELS
  (above TOP BODY))

(define Y-CAR
  (* 3.4 WHEEL-RADIUS))

(define CAR
  (overlay/offset BOTH-WHEELS 0 -10 NO-WHEELS))

(define VELOCITY
  3)

(define BACKGROUND (empty-scene WIDTH-OF-WORLD 30))

(define (calculate-current-position as)
  (* as VELOCITY))

; WorldState -> Image
; places the image of the car x pixels from 
; the left margin of the BACKGROUND image 
(define (render as)
   (place-image CAR (- (calculate-current-position as) (/ (image-width CAR) 2)) Y-CAR BACKGROUND))
 
; An AnimationState is a Number.
; interpretation the number of clock ticks 
; since the animation started
(check-expect (tock 20) 21)
(check-expect (tock 78) 79)
(define (tock as)
  (+ as 1))

; WorldState Number Number String -> WorldState
; places the car at x-mouse
; if the given me is "button-down"
(check-expect (hyper 21 10 20 "enter") 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)
(define (hyper x-position-of-car x-mouse y-mouse me)
    (cond
    [(string=? "button-down" me) x-mouse]
    [else x-position-of-car]))

; WorldState -> WorldState
; launches the program from some initial state 
(define (main ws)
   (big-bang ws
     [on-tick tock]
     [to-draw render]))