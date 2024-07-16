#lang racket

(require 2htdp/image)
(require 2htdp/universe)
(require rackunit)

(define-struct editor [pre post cursor cursor-color]
  #:transparent)
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

(define (delete-pre editor)
  (define pre-length (string-length (editor-pre editor)))
  (if (<= pre-length 0)
      editor
      (make-editor
       (substring (editor-pre editor) 0 (- pre-length 1))
       (editor-post editor)
       (editor-cursor editor)
       (editor-cursor-color editor))))

(define (delete-post editor)
  (define post-length (string-length (editor-post editor)))
  (if (<= post-length 0)
      editor
      (make-editor
       (editor-pre editor)
       (substring (editor-post editor) 1 post-length)
       (editor-cursor editor)
       (editor-cursor-color editor))))

(define (too-large? editor)
  (< 200
     (+ (image-width (text (editor-pre editor) 11 "black"))
        (image-width (text (editor-post editor) 11 "black")))))

(define (append-pre editor character)
  (if (too-large? editor)
      editor
      (make-editor
       (string-append (editor-pre editor) character)
       (editor-post editor)
       (editor-cursor editor)
       (editor-cursor-color editor))))

(define (insert-head-post editor character)
  (make-editor
   (editor-pre editor)
   (string-append character (editor-post editor))
   (editor-cursor editor)
   (editor-cursor-color editor)))

(define (get-last-pre editor)
  (define e-pre (editor-pre editor))
  (define end (string-length e-pre))
  (define start (- end 1))
  (if (< start 0)
      ""
      (substring (editor-pre editor) start end)))

(define (get-first-post editor)
  (define post (editor-post editor))
  (if (string=? "" post)
      ""
      (substring (editor-post editor) 0 1)))

(define (move-cursor-left editor)
  (define last-pre (get-last-pre editor))
  (delete-pre
   (insert-head-post editor last-pre)))

(define (move-cursor-right editor)
  (define first-post (get-first-post editor))
  (delete-post (append-pre editor first-post)))

(define (tock editor)
  (cond [(string=? "white" (editor-cursor-color editor))
         (make-editor
          (editor-pre editor)
          (editor-post editor)
          (rectangle 1 16 "solid" "black")
          "black")]
        [else (make-editor
               (editor-pre editor)
               (editor-post editor)
               (rectangle 1 16 "solid" "white")
               "white")]))

(define (edit editor keyevent)
  (cond 
    [(string=? "right" keyevent) (move-cursor-right editor)]
    [(string=? "left" keyevent) (move-cursor-left editor)]
    [(string=? "\r" keyevent) editor]
    [(string=? "\b" keyevent) (delete-pre editor)]
    [else (append-pre editor keyevent)]))

(define (main pre post)
  (big-bang (make-editor pre post (rectangle 1 16 "solid" "black") "black")
    [to-draw render]
    [on-key edit]
    [on-tick tock 1/2]))

(provide delete-pre
         append-pre
         move-cursor-left
         move-cursor-right
         delete-post
         (struct-out editor))