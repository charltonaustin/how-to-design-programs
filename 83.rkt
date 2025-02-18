#lang racket
(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t


(define (render editor)
  (overlay/align "left" "center"
               (beside (text (editor-pre editor) 11 "black") (rectangle 1 16 "solid" "black") (text (editor-post editor) 11 "black"))
               (empty-scene 200 20)))

(define (edit editor keybinding)
  editor)
