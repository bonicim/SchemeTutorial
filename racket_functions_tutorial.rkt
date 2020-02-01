;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname racket_functions_tutorial) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

(define (string-add-prefix w p)
  (string-append p w))

(define (string-add-suffix w p)
  (string-append w p))

 (define (string-join w p)
   (string-add-suffix (string-add-suffix w ",") p))

 (define (iff p q)
   (cond
     [(or (and p q) (and (not p) (not q))) true]
     [else false]))

 (define (tax salary)
   (cond
     [(and (> salary 0) (<= salary 9275)) (* .1 salary)]
     [(and (> salary 9275) (<= salary 37650)) (* .15 salary)]))

 (define (text-stylize string category)
   (cond
     [(symbol=? category 'title) (text string 36 "blue")]
     [(symbol=? category 'body) (text string 24 "black")]
     [(symbol=? category 'code) (text string 20 "red") ]))


 (define (image>? image1 image2)
   (cond
     [(and ( > (image-width image1) (image-width image2)) ( > (image-height image1) (image-height image2))) true]
     [else false]))
 