;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname LabOnLists) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; Desing a function that takes a list of numbers and returns their product, i.e., multiplies all the numbers together.

; DESIGN RECIPE TEMPLATE
;;;; Data Definitions:
; A ListOfNumbers (Lon) is one of:
; - empty
; - (cons Number Lon)

;; Deconstructor Template
;; segements-fn: Segments -> ???
#;(define (lon-fn lon)
    (cond
      [(empty? lon) ...]
      [(cons? lon) ... (first lon)
                       (rest lon) ...]))

;;;; Examples:
(cons 4 empty)
(cons 4 (cons 2 empty))

;;;; Signature
;;;; product : Lon -> Number
;;;; Purpose: Multiplies a list of numbers and returns the product
;; GIVEN: Lon
;; RETURNS: Number
;;;; Examples:
;;;; product : (4,2) -> 8
;;;; Function Definition:
(define (product lon)
  (cond [(empty? lon) 1]
        [else (* (first lon) (product (rest lon)))]))
        
;;;; Tests:
(check-expect (product empty) 1)
(check-expect (product (cons 4 (cons 2 empty))) 8)
(check-expect (product (cons 4 (cons 2 (cons 3 empty)))) 24)
(check-expect (product (cons 4 (cons 2 (cons -3 empty)))) -24)
(check-expect (product (cons 4434 (cons 0 (cons 3653 empty)))) 0)

;; Design a function that takes a list of number and returns the same list of numbers but with the last element removed

;;;; Signature
;;;; remove-last : Lon -> Lon
;;;; Purpose: Removes last number in list
;; GIVEN: Lon
;; RETURNS: Lon
;;;; Examples:
;;;; remove-last : (4,2) -> (4)
;;;; Function Definition:
(define (remove-last lon)
  (cond [(empty? lon) empty] 
        [(empty? (rest lon)) empty]
        [else (cons (first lon) (remove-last (rest lon)))]))
        
;;;; Tests:
(check-expect (remove-last (cons 1 (cons 2 (cons 3 empty)))) (cons 1 (cons 2 empty)))
(check-expect (remove-last (cons 1 empty)) empty)
(check-expect (remove-last empty) empty)

;; Design a function called occurrences that given a List of Numbers and a Number n returns the number of times n appears in the list
;;;; Signature
;;;; occurences : Lon Number -> Number
;;;; Purpose: returns the number of times n appears in the list
;; GIVEN: Lon Number
;; RETURNS: Number
;;;; Examples:
;;;; occurences : (4, 2, 2, 3, 2, 2) 2 -> 4
;;;; Function Definition:
(define (occurences lon target)
  (cond [(empty? lon) 0] 
        [(equal? (first lon) target) (+ 1 (occurences (rest lon) target))]
        [else (occurences (rest lon) target)]))
        
;;;; Tests:
(check-expect (occurences (cons 4 (cons 2 (cons 2 (cons 3 (cons 2 (cons 2  empty)))))) 2) 4)
(check-expect (occurences (cons 4 (cons 2 (cons 2 (cons 3 (cons 2 (cons 2  empty)))))) 4) 1)
(check-expect (occurences (cons 4 (cons 2 (cons 2 (cons 3 (cons 2 (cons 2  empty)))))) 76887) 0)
(check-expect (occurences empty 4) 0)

;; Design the functions all-even? that given a list of numbers, returns true if all elements of the list are even and false otherwise
;;;; Signature
;;;; all-even? : Lon -> Boolean
;;;; Purpose: returns true if all elements are even; false otherwise
;; GIVEN: Lon 
;; RETURNS: Boolean
;;;; Examples:
;;;; all-event? : (4, 2, 2, 3, 2, 2) -> False
;;;; Function Definition:
(define (all-even? lon)
  (cond [(empty? lon) #f]
        [(empty? (rest lon)) (equal? (modulo (first lon) 2) 0)]  
        [else (and (equal? (modulo (first lon) 2) 0) (all-even? (rest lon)))]))
        
;;;; Tests:
(check-expect (all-even? (cons 4 (cons 2 (cons 2 (cons 6 (cons 8 (cons 10  empty))))))) #t)
(check-expect (all-even? (cons 4 (cons 2 (cons 2 (cons 3 (cons 2 (cons 2  empty))))))) #f)
(check-expect (all-even? (cons 4 empty)) #t)
(check-expect (all-even? (cons 3 empty)) #f) 
(check-expect (all-even? empty) #f)