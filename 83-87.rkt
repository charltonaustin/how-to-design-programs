#lang racket

(require 2htdp/image)
(require 2htdp/universe)

(define-struct editor [pre post cursor])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t



(define (render editor)
  (overlay/align
   "left" "center"
   (beside
    (text (editor-pre editor) 11 "black")
    (editor-cursor editor)
    (text (editor-post editor) 11 "black"))
   (empty-scene 200 20)))

(define (delete-previous editor)
  (if (> (editor-pre edit)))
  (make-editor (substring (editor-pre editor) 0 (string-length (editor-pre editor))))

(define (append-previous editor)
  editor)

(define (move-left editor) editor)

(define (move-right editor) editor)

(define (edit editor keyevent)
  (if (not (= (string-length keyevent) 1))
      editor
      (cond 
        [(string=? "\r") editor]
        [(string=? "right") (move-right editor)]
        [(string=? "left") (move-left editor)]
        [(string=? "\\d") (delete-previous editor)]
        [else (append-previous editor)])))