;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 177-180) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 20) ; the height of the editor 
(define WIDTH 200) ; its width 
(define FONT-SIZE 16) ; the font size 
(define FONT-COLOR "black") ; the font color 
 
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor Lo1S Lo1S) 
; An Lo1S is one of: 
; – '()
; – (cons 1String Lo1S)

(define (create-editor pre post)
  (make-editor (reverse (explode pre)) (explode post)))

; Editor -> Image
; renders an editor as an image of the two texts 
; separated by the cursor 
(define (editor-render e)
  (overlay/align
   "left" "center"
   (beside
    (text (implode (reverse (editor-pre e))) FONT-SIZE FONT-COLOR)
    CURSOR
    (text (implode (editor-post e)) FONT-SIZE FONT-COLOR))
   MT))

(define (move-left-to-right left right)
  (make-editor (rest left) (cons (first left) right)))

(define (move-cursor-left ed)
  (move-left-to-right (editor-pre ed) (editor-post ed)))

(define (move-cursor-right ed)
  (move-left-to-right (editor-post ed) (editor-pre ed)))

(define (delete-character ed)
  (make-editor (rest (editor-pre ed)) (editor-post ed)))

(define (append-to-pre ed k)
  (make-editor (cons k (editor-pre ed)) (editor-post ed)))
 
; Editor KeyEvent -> Editor
; deals with a key event, given some editor
(check-expect
 (editor-kh (create-editor "" "") "e")
 (create-editor "e" ""))
(check-expect
 (editor-kh (create-editor "cd" "fgh") "e")
 (create-editor "cde" "fgh"))
(define (editor-kh ed k)
  (cond
    [(key=? k "left") (move-cursor-left ed)]
    [(key=? k "right") (move-cursor-right ed)]
    [(key=? k "\b") (delete-character ed)]
    [(key=? k "\t") ed]
    [(key=? k "\r") ed]
    [(= (string-length k) 1) (append-to-pre ed k)]
    [else ed]))

; main : String -> Editor
; launches the editor given some initial string 
(define (main s)
  (big-bang (create-editor s "")
    [on-key editor-kh]
    [to-draw editor-render]))