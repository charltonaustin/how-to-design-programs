#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)


#|
Happiness is defined by a Number 0 to 100
Happiness gauge is an Image
ex (rectangle 0 (* 1/3 HEIGHT-OF-WORLD) "solid" "red")
   (rectangle 50 (* 1/3 HEIGHT-OF-WORLD) "solid" "red")
   (rectangle 100 (* 1/3 HEIGHT-OF-WORLD) "solid" "red")
|#

(define WIDTH-OF-WORLD 400)
(define HEIGHT-OF-WORLD 50)
(define BACKGROUND (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD))
(define HEIGHT-OF-GAUGE (* 1/3 HEIGHT-OF-WORLD))

; Number -> Number
; Takes in the current happiness and returns happiness for the next state.
(check-expect (tock 0) 0)
(check-expect (tock -1) 0)
(check-expect (tock 50) 49.9)
(define (tock happiness)
  (if (<= (- happiness .1) 0) 0 (- happiness .1)))

; Number -> Image
; Takes in the current happiness level and returns an image normalizing the happiness level to the length of the scene.
(check-expect (make-happiness-gauge 0) (rectangle 0 HEIGHT-OF-GAUGE "solid" "red"))
(check-expect (make-happiness-gauge 100) (rectangle WIDTH-OF-WORLD HEIGHT-OF-GAUGE "solid" "red"))
(define (make-happiness-gauge happiness)
  (rectangle (* WIDTH-OF-WORLD (/ happiness 100)) HEIGHT-OF-GAUGE "solid" "red"))

; Number -> Image
; Takes in a time and renders an image representing that time
(define (render happiness)
  (place-image (make-happiness-gauge happiness) (+ 0 (* 1/2 (image-width (make-happiness-gauge happiness)))) (* 1/2 HEIGHT-OF-WORLD) BACKGROUND))

; Number, KeyEvent -> Number
; Takes in the current happiness and a key event and applies a transformation to the happiness for the key event.
(check-expect (key-handler 10 "down") 8)
(check-expect (key-handler 100 "down") 80)
(check-expect (key-handler 0 "down") 0)
(check-expect (key-handler 100 "up") 100)
(check-expect (key-handler 60 "up") 80)
(check-expect (key-handler 0 "up") 0)
(define (key-handler happiness a-key)
    (cond
      [(key=? a-key "up")    (if (> (* 4/3 happiness) 100 ) 100 (* 4/3 happiness))]
      [(key=? a-key "down")  (* 4/5 happiness)]
      [else happiness]))

(define (gauge-prog happiness)
   (big-bang happiness
     [on-tick tock]
     [to-draw render]
     [on-key key-handler]))