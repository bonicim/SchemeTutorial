;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname assignment4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; DESIGN RECIPE TEMPLATE
;;;; Data Definitions:
;; Deconstructor Template
;;;; Signature
;;;; Purpose: 
;; GIVEN: 
;; RETURNS:
;;;; Examples:
;;;; Function Definition:
;;;; Tests:

; Problem 1
; Provide a data definition for a list of booleans (lob)
;Design the function lob-or that consumes a list of booleans and returns the result of logically or-ing all the elements of the list. For example
;; (lob-or (cons #true (cons #false (cons #true empty)))) is equivalent to
;; (or #true #false #true)
;(lob-or (cons #true (cons #false (cons #true empty))))   ;; returns #true
;(lob-or (cons #false (cons #false (cons #false empty)))) ;; returns #false

; A LoB (List of Booleans) is one of
; - empty
; - (cons boolean empty)

;; Deconstructor Template
;; segements-fn: ListOfBooleans -> ???
#;(define (lob-fn lon)
    (cond
      [(empty? lob) ...]
      [(cons? lob) ... (first lob)
                       (rest lob) ...]))
;;;; Signature
; lob -> Boolean
;;;; Purpose: Return result of logicically or-ing all the elements in the list

; examples
;(lob-or (cons #true (cons #false (cons #true empty))))   ;; returns #true
;(lob-or (cons #false (cons #false (cons #false empty)))) ;; returns #false

;;;; Function Definition:
(define (lob-or lob)
  (cond [(empty? lob) #t]
        [(empty? (rest lob)) (first lob)]
        [else (or (first lob) (lob-or (rest lob)))]))

; tests
(check-expect (lob-or (cons #true (cons #false (cons #true empty)))) #true)
(check-expect (lob-or (cons #false (cons #false (cons #false empty)))) #false)
(check-expect (lob-or empty) #t)
(check-expect (lob-or (cons #t empty)) #t)
(check-expect (lob-or (cons #f empty)) #f)


;Design the function lob-and that consumes a list of booleans and returns the result of logically and-ing all the elements of the list. For example
;; (lob-and (cons #true (cons #false (cons #true empty)))) is equivalent to 
;; (and #true #false #true)
;(lob-and (cons #true (cons #false (cons #true empty)))) ;; returns #false
;(lob-and (cons #true (cons #true (cons #true empty))))  ;; returns #true
(define (lob-and lob)
  (cond [(empty? lob) #t]
        [(empty? (rest lob)) (first lob)]
        [else (and (first lob) (lob-and (rest lob)))]))
; tests
(check-expect (lob-and (cons #true (cons #false (cons #true empty)))) #f) ;; returns #false
(check-expect (lob-and (cons #true (cons #true (cons #true empty)))) #t)  ;; returns #true
(check-expect (lob-and empty) #t)


; Problem 2
;Provide the data definition for a list of strings (los)
;Design the function los-total-length that consumes a list of strings and returns the sum of the length of each element in the list. For example
;(los-total-length (cons "a" empty))             ;; returns 1
;(los-total-length (cons "aa" (cons "a" empty))) ;; returns 3
(define (los-total-length los)
  (cond [(empty? los) 0]
        [(empty? (rest los)) (string-length (first los))]
        [else (+ (string-length (first los)) (los-total-length (rest los)))]))

; tests
(check-expect (los-total-length (cons "a" empty)) 1)             ;; returns 1
(check-expect(los-total-length (cons "aa" (cons "a" empty))) 3) ;; returns 
(check-expect (los-total-length empty) 0)


;Design the function string-at-index that consumes a list of strings and an index and returns the element at that index in the string. The first element of the list has index 0. You may assume that the index provided as input is always valid, i.e., it is greater or equal to 0 and less than the size of the list.

(define (string-at-index los index)
  (cond [(empty? los) empty]
        [(equal? index 0) (first los)]
        [else (string-at-index (rest los) (- index 1))]))

(check-expect (string-at-index (cons "abc" (cons "def" empty)) 0) "abc")
(check-expect (string-at-index (cons "abc" (cons "def" empty)) 1) "def")
(check-expect (string-at-index (cons "abc" empty) 0) "abc")
(check-expect (string-at-index empty 0) empty)


;Design the function los-contains that consumes a list of strings string-list and a string s and returns true if s is in string-list, otherwise returns false.

(define (string-list los s)
  (cond [(empty? los) #f]
        [(equal? (first los) s) #t]
        [else (string-list (rest los) s)]))

(check-expect (string-list (cons "abc" (cons "def" empty)) "abc") #t)
(check-expect (string-list (cons "abc" (cons "def" empty)) "xxxxx") #f)
(check-expect (string-list empty "Fdf") #f)


;Design the function los-replace-first that consumes a list of strings string-list and two strings  old and new and returns the string-list but with the first  old replaced by new. For example
; (los-replace-first (cons "a" (cons "b" (cons "a" empty))) "a" "x") 
;; returns 
;; (cons "x" (cons "b" (cons "a" empty)))

;(los-replace-first (cons "a" (cons "b" (cons "a" empty))) "c" "x") 
;; returns 
;; (cons "a" (cons "b" (cons "a" empty))) 
(define (los-replace-first los old new)
  (cond [(empty? los) empty]
        [(equal? (first los) old) (cons new (rest los))]
        [else (cons (first los) (los-replace-first (rest los) old new))]))

(check-expect (los-replace-first (cons "x" (cons "b" (cons "a" empty))) "a" "x") (cons "x" (cons "b" (cons "x" empty))))
(check-expect (los-replace-first (cons "a" (cons "b" (cons "a" empty))) "a" "x") (cons "x" (cons "b" (cons "a" empty))))
(check-expect (los-replace-first empty "x" "c") empty)

;Design the function los-replace-all that consumes a list of strings string-list and two strings  old and new and returns the string-list but with all  old replaced by new. For example

(define (los-replace-all los old new)
  (cond [(empty? los) empty]
        [else (cons (first (los-replace-first (cons (first los) empty) old new)) (los-replace-all (rest los) old new))])) 

(check-expect (los-replace-all (cons "a" (cons "b" (cons "a" empty))) "a" "x") (cons "x" (cons "b" (cons "x" empty))))
(check-expect (los-replace-all (cons "a" (cons "b" (cons "a" empty))) "c" "x")  (cons "a" (cons "b" (cons "a" empty))))
(check-expect (los-replace-all empty "c" "x") empty)
(check-expect (los-replace-all (cons "a" (cons "a" (cons "a" empty))) "a" "x") (cons "x" (cons "x" (cons "x" empty))))
(check-expect (los-replace-all (cons "a" (cons "a" (cons "a" empty))) "x" "a") (cons "a" (cons "a" (cons "a" empty))))