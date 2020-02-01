;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname assignment2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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




;;;; Data Analysis and Definitions:
;; A bool1 is a Boolean
;; A bool2 is a Boolean

;;;; Signature: logical-xor : bool1 bool2 -> Boolean

;;;; Purpose: 
;; GIVEN: two booleans
;; RETURNS: a boolean as a result of the logical exclusive-or

;;;; Examples:
;; (logical-xor true true) => #false

;;;; Function Definition:
(define (logical-xor bool1 bool2)
  (cond
    [(and bool1 bool2) false]
    [(not(and bool1 bool2)) false]
    [else true]))

;;;; Tests:
(check-expect (logical-xor true true)
              false)
(check-expect (logical-xor false false)
              false)
(check-expect (logical-xor true false)
              false)
(check-expect (logical-xor false true)
              false)










;;;; Data Definitions: None

;;;; Signature
;; undefined?: Any -> Boolean

;;;; Purpose
;; GIVEN: a value 
;; RETURNS: true if it is the 'undefined symbol
;;          false otherwise

;;;; Examples
;; (undefined? 1) => #false
;; (undefined? 't) => #false
;; (undefined? 'undefined) => #true

(define UNDEFINED 'undefined)

;;;; Function Definition
(define (undefined? val)
  (and (symbol? val)
       (symbol=? UNDEFINED val)))

;;;; Tests
(check-expect (undefined? 1) #false)
(check-expect (undefined? 't) #false)
(check-expect (undefined? UNDEFINED) #true)


;;;; Data Analysis and Definitions:
;; A MaybeNumber is one of 
;; - Number 
;; - 'undefined 

;; Deconstructor Template
;; maybe-number-fn: MaybeNumber -> ??? 
#;(define (maybe-number-fn maybe-num) 
    (cond                             
      [(number? maybe-num) ...]       
      [(undefined? maybe-num) ...]))  

;;;; Signature: add : MaybeNumber MaybeNumber -> MaybeNumber

;;;; Purpose: 
;; GIVEN: two numbers that maybe undefined
;; RETURNS: the sum of both numbers if defined; otherwise 'undefined
;; if one of the maybenumbers is the symbol 'undefined, return 'undefined

;;;; Examples 
;;(maybe-num-add 1 2) => 3
;;(maybe-num-add 1 UNDEFINED) => UNDEFINED
;;(maybe-num-add UNDEFINED 2) => UNDEFINED
;;(maybe-num-add UNDEFINED UNDEFINED) => UNDEFINED

;;;; Function Definition:
(define (add maybenumber1 maybenumber2)
  (cond
    [(none-undef? maybenumber1 maybenumber2) (+ maybenumber1 maybenumber2)]
    [(either-undef? maybenumber1 maybenumber2) UNDEFINED]))
    
;;;; Tests:
(check-expect (add 2 3) 5)
(check-expect (add 2 UNDEFINED) UNDEFINED)
(check-expect (add UNDEFINED 3) UNDEFINED)
(check-expect (add UNDEFINED UNDEFINED) UNDEFINED)


;;;; Data Definitions: None

;;;; Signature:
;; none-undef?: MaybeNumber MaybeNumber -> Boolean
;;;; Purpose
;; GIVEN: two maybe numbers
;; RETURNS: true if both inputs are defined (are numbers)
;;          false otherwise

;;;; Examples
;;(none-undef? 1 2) => #true
;;(none-undef? 1 UNDEFINED) => #false
;;(none-undef? UNDEFINED 2) => #false
;;(none-undef? UNDEFINED UNDEFINED) => #false

;;;; Function Definition
(define (none-undef? maybenum1 maybenum2)
  (and (number? maybenum1) (number? maybenum2)))

;;;; Tests
(check-expect (none-undef? 1 2) #true)
(check-expect (none-undef? 1 UNDEFINED) #false)
(check-expect (none-undef? UNDEFINED 2) #false)
(check-expect (none-undef? UNDEFINED UNDEFINED) #false)


;;;; Data Definitions: None

;;;; Signature:
;; either-undef?: MaybeNumber MaybeNumber -> Boolean
;;;; Purpose
;; GIVEN: two maybe numbers
;; RETURNS: true if either or both inputs are undefined 
;;          false otherwise

;;;; Examples
;;(either-undef? 1 2) => #false
;;(either-undef? 1 UNDEFINED) => #true
;;(either-undef? UNDEFINED 2) => #true
;;(either-undef? UNDEFINED UNDEFINED) => #true

;;;; Function Definition
(define (either-undef? maybenum1 maybenum2)
  (not (none-undef? maybenum1 maybenum2)))

;;;; Tests
(check-expect (either-undef? 1 2) #false)
(check-expect (either-undef? 1 UNDEFINED) #true)
(check-expect (either-undef? UNDEFINED 2) #true)
(check-expect (either-undef? UNDEFINED UNDEFINED) #true)



;PROBLEM 3

;;;; Data Definitions:
;; An Hour is a NonNegInteger
;; WHERE: Hour is in the range of [0,23]
;; INTERP: represents the hour of the day in the 24 hour format
 
;; A Minute is a NonNegInteger
;; WHERE: Minute is in the range of [0, 59]
;; INTERP: represents the minute of the day in the 60 minute format

;; A Time is a String with the format "XX:YY"
;; INTERP: represents the time in hours, XX, and minutes, YY


;;;; Signature
;; add-1-minute : Hour Minute -> Time
;;;; Purpose: adds one minute to the current time
;; GIVEN: the hours and minutes of the current time
;; RETURNS: a new time of the current time plus one minute


;;;; Examples:
;; (add-1-minute 16 50) => "16:51"
;; (add-1-minute 16 59) => "17:00"
;; (add-1-minute 23 59) => "00:00"

(define MAX-MINUTES 59)
(define MAX-HOURS 23)

;;;; Function Definition:
(define (add1-minute hours minutes)
  (cond
    [(= MAX-MINUTES minutes) (time->string (add-1-hour hours) 0)]
    [else (time->string hours (+ 1 minutes))]))
  

;;;; Tests:
(check-expect (add1-minute 0 0) "0:1")
(check-expect (add1-minute 0 59) "1:0")
(check-expect (add1-minute 23 59) "0:0")
(check-expect (add1-minute 12 23) "12:24")  

;;;; Data Definitions: None

;;;; Signature
;; add-1-hour : Hour -> Hour

;;;; Purpose: to add one hour to the hour
;; GIVEN: the hour
;; RETURNS: a new hour in which one hour is added to the hour

;;;; Examples:
;; (add-1-hour 4) => 5
;; (add-1-hour 0) => 1
;; (add-1-hour 23) => 0

;;;; Function Definition:
(define (add-1-hour hour)
  (cond
    [(= MAX-HOURS hour) 0]
    [else (+ 1 hour)]))

;;;; Tests:
;;;; Tests
(check-expect (add-1-hour 7) 8)
(check-expect (add-1-hour 23) 0)



;;;; Data Definitions: None

;;;; Signature
;; time->string : Hour Minute -> String

;;;; Purpose: to produce the time in the string format "XX:YY, where XX is Hour and YY is Minute
;; GIVEN: the hours and minutes of a time
;; RETURNS: the time as a string in the format "XX:YY"

;;;; Examples:
;; (time->string 23 59) => "23:59"
;; (time->string 13 0) => "13:00"

;;;; Function Definition:
(define (time->string hour minute)
  (string-append (number->string hour) ":" (number->string minute)))
  
;;;; Tests:
(check-expect (time->string 10 10) "10:10")



