#lang racket

(require rackunit
         "83-87.rkt")

(check-true
 (string=?
  (editor-pre (delete-pre (make-editor "pre" "post" "cursor" "")))
  "pr"))

(check-true
 (string=?
  (editor-pre (delete-pre (make-editor "" "post" "cursor" "")))
  ""))

(check-true
 (string=?
  (editor-pre (append-pre (make-editor "pre" "post" "c" "") "a"))
  "prea"))

(check-equal?
 (move-cursor-left (make-editor "pre" "post" "c" ""))
 (make-editor "pr" "epost" "c" ""))

(check-equal?
 (move-cursor-left (make-editor "p" "repost" "c" ""))
 (make-editor "" "prepost" "c" ""))

(check-equal?
 (move-cursor-left (make-editor "" "prepost" "c" ""))
 (make-editor "" "prepost" "c" ""))

(check-equal?
 (delete-post (make-editor "pre" "post" "c" ""))
 (make-editor "pre" "ost" "c" ""))

(check-equal?
 (delete-post (make-editor "pre" "" "c" ""))
 (make-editor "pre" "" "c" ""))