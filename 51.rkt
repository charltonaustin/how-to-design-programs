#lang htdp/bsl

(require 2htdp/universe)
(require 2htdp/image)

(define WIDTH-OF-WORLD 100)
(define HEIGHT-OF-WORLD (* 3 WIDTH-OF-WORLD))
(define WIDTH-OF-TRAFFIC-SIGN (/ WIDTH-OF-WORLD 2))
(define BACKGROUND (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD))
(define WAIT-TIME 36)

(define (filled-light color)
  (overlay (circle (- WIDTH-OF-TRAFFIC-SIGN 10) "solid" color) (square WIDTH-OF-WORLD "solid" "black")))

(define (outlined-light color)
  (overlay (circle (- WIDTH-OF-TRAFFIC-SIGN 15) "solid" (string-append "light" color)) (circle (- WIDTH-OF-TRAFFIC-SIGN 10) "solid" color) (square WIDTH-OF-WORLD "solid" "black")))

(define (light color)
  (cond [(string=? color "red") (above (filled-light "red") (outlined-light "yellow") (outlined-light "green"))]
        [(string=? color "yellow") (above (outlined-light "red") (filled-light "yellow") (outlined-light "green"))]
        [else (above (outlined-light "red") (outlined-light "yellow") (filled-light "green"))]))

(define (current-color time)
  (cond [(< (modulo time (* WAIT-TIME 3)) WAIT-TIME) "red"]
        [(< (modulo time (* WAIT-TIME 3)) (* WAIT-TIME 2)) "green"]
        [else "yellow"]))

(define (render time)
  (place-image (light (current-color time)) WIDTH-OF-TRAFFIC-SIGN (/ HEIGHT-OF-WORLD 2)  BACKGROUND))

(define (tock time)
  (+ 1 time))

; Number -> Number
; time represents the starting time
; launches the program from some initial state 
(define (traffic-light time)
   (big-bang time
     [on-tick tock]
     [to-draw render]))