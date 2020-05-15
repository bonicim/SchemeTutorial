;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname assignment3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;;;;;;
;;For each of the following structure definitions provide

;;Signatures for all selectors
;;Signature for the constructor
;;Signature for the predicate
;;A deconstructor template




;; A Grade is a NonNegReal within the range [0,100]

(define-struct student (name id grade))
;; Constructor Template:
;; A Student is (make-student String PosInt Grade)
;; INTER: represents a student with the student's name 
;;        the student's id and the student's grade. 

;;;; Signatures for selectors, constructor, predicate
;; student-name : Student -> String
;; student-id : Student -> PosInt
;; student-grade : Student -> Grade
;; make-student : String PosInt Grade -> Student
;; student? : Any -> Boolean

;; Deconstructor Template
#; (define (student-fn s)
     ... (student-name s) ...
     ... (student-id s) ...
     ... (student-grade s) ...)

     


(define-struct container (width height depth capacity label))
;; Constructor Template:
;; A Container is (make-container PosInt PosInt PosInt PosInt Symbol)
;; WHERE: capacity = width * height * depth
;; INTERP: represents a container with its width, height, depth 
;;         in centimeters, it's capacity in cubic centimeters and 
;;         it's label


;;;; Signatures for selectors, constructor, predicate
;; container-width: Container -> PosInt                           
;; container-height: Container -> PosInt                          
;; container-depth: Container -> PosInt                           
;; container-capacity: Container -> PosInt                        
;; container-label: Container -> Symbol   
;; make-container : PosInt PosInt PosInt PosInt Symbol
;; container? : Any -> Boolean

;; Deconstructor Template
;; container-fn: Container -> ???  
#;(define (container-fn c)         
    ... (container-width c) ...    
    ... (container-height c) ...   
    ... (container-depth c) ...    
    ... (container-capacity c) ... 
    ... (container-label c) ...)   
     
     

(define-struct sweater (material size producer))
;; Constructor Template:
;; A Sweater is (make-sweater Symbol PosInt String)
;; INTERP: represents a sweater with the sweater's material 
;;         its size and the name of the manufacturer

;; sweater-material: Sweater -> Symbol           
;; sweater-size: Sweater -> PosInt               
;; sweater-producer: Sweater -> String           
;; make-sweater: Symbol PosInt String -> Sweater 
;; sweater? : Any -> Boolean                     


;;;; Template 
;; sweater-fn: Sweater -> ???     
#;(define (sweater-fn s)          
    ... (sweater-material s) ...  
    ... (sweater-size s) ...      
    ... (sweater-producer s) ...) 


     
(define-struct game (name min-ram min-graphics-ram online?))
;; Constructor Template:
;; A Game is (make-game String PosInt PosInt Boolean
;; INTERP: represents a game with it's name, the minimum ram 
;;         capacity needed , the minimum graphics 
;;         card memory needed and whether it is an online game or not


;;;; Signatures 

;; game-name: Game -> String                       
;; game-min-ram: Game -> PosInt                    
;; game-min-graphics-ram:  Game -> PosInt          
;; game-online?:  Game -> Boolean                  
;; make-game: String PosInt PosInt Boolean -> Game 
;; game? : Any -> Boolean                          


;;;; Template 
;; game-fn: Game -> ??                
#;(define (game-fn g)                 
    ... (game-name g) ...             
    ... (game-min-ram g) ...          
    ... (game-min-graphics-ram g) ... 
    ... (game-online? g) ...)

;; P2

;;;; Data Definitions:
#; (define-struct posn (x y))
;; Constructor Template:
;; A Posn is a (make-posn Real Real)
;; INTERP: represents a Cartesian Coordinate (x,y)

;; Deconstructor Template: 
#; (define (posn-fn point)
     ... (posn-x point) ...
     ... (posn-y point) ...)

;;;; Data examples
;; (make-posn 2 2)

;;;; Signature
;; dist : Posn Posn => Integer

;;;; Purpose: To calculate the distance between two points on a Cartesian plane
;; GIVEN: two Posn's
;; RETURNS: the distance between the two posn's

;;;; Examples:
;; (dist (make-posn 0 0) (make-posn 100 100)) =>  141

;;;; Function Definition:
(define (dist p1 p2)
  (integer-sqrt (+ (sqr (- (posn-x p2) 
                              (posn-x p1)))
                      (sqr (- (posn-y p2)  
                              (posn-y p1))))))
    
;;;; Tests:
(check-expect (dist (make-posn 0 0) (make-posn 100 100)) 141)
(check-expect (dist (make-posn 3 2) (make-posn 9 7)) 7)




;; P3

;;;; Data Definitions:

;; Dollars is a NonNegInteger

;; Cents is a NonNegInteger in the range [0,99]

(define-struct amount (dollars cents))
;; An Amount is (make-amount Dollars Cents)
;; INTERP: represents total amount in dollars and cents.

;; Deconstructor Template
;; amount-fn: Amount -> ???  
#;(define (amount-fn c)         
    ... (amount-dollars c) ...
    ... (amount-cents c) ...)

;; Data Examples
;; (make-amount 3 4) 

;;;; Signature
;; add-to-amount : Amount Dollars Cents => Amonut

;;;; Purpose: To add dollars and cents to the amount
;; GIVEN: the current amount and the dollars and cents to be added
;; RETURNS: the amount, which is the amount plus the dollars and cents

;;;; Examples:
;; (add-to-amount (make-amount 1 99) 1 1) => (make-amount 3 0)
;; (add-to-amount (make-amount 2 23) 4 22) => (make-amount 6 45)


;;;; Function Definition:
(define (add-to-amount amt dollars cents)
    (make-amount (+ (amount-dollars amt)
                  dollars
                  (quotient (+ (amount-cents amt)
                               cents)
                            100))
               (remainder (+ (amount-cents amt)
                             cents)
                          100)))
    

;;;; Tests:
(check-expect (add-to-amount (make-amount 1 99) 1 1) (make-amount 3 0))
(check-expect (add-to-amount (make-amount 2 23) 4 22) (make-amount 6 45))


















;; P4

;;; Data Definitions 
(define-struct official (first middle last title))
;; Constructor Template:
;; An OfficialName is (make-official String String String String)
;; INTERP: represents a person's official name with first, middle, last name
;;         and title.

;; Deconstructor Template: 
;; official-fn: Official -> ???  
#;(define (official-fn c)         
    ... (official-first c) ...
    ... (official-middle c) ...
    ... (official-last c) ...
    ... (official-title c) ...)


    
;;; Data Examples
(define JOHN-OFFICIAL (make-official "John" "D." "Doe" "PhD"))



(define-struct full (first last))
;; A FullName is a (make-full String String)
;; INTERP: represents a person's name with first and last name. 

;; Deconstructor Template: 
;; full-fn : FullName ->??
#; (define (full-fn f)
     ... (full-first f) ...
     ... (full-last f) ...)

;;; Data Examples
(define JOHN-FULL (make-full "John" "Doe"))



;; An Author is one of
;; - OfficialName
;; - FullName
;; INTERP: represents the name of an author for a publication as either
;;         a full name (first and last) or an offical name (first, middle, last
;;         and title)

;; Deconstructor Template:
;; author-fn : Author -> ???
#; (define (author-fn author)
     (cond
       [(official? author) ... (official-fn author)...]
       [(full? author) ... (full-fn author) ...]))

;; Data examples
(define AUTHOR1 (make-official "Martin"
                               "Luther"
                               "King"
                               "Dr"))
(define AUTHOR2 (make-full "Martin"
                           "King"))







;; A Year is a PosInt with 4 digits, e.g., 1999
;; INTERP: represents a calendar year. 

;; A Month is one of
;; - 'Jan
;; - 'Feb
;; - 'Mar
;; - 'Apr
;; - 'May
;; - 'Jun
;; - 'Jul
;; - 'Aug
;; - 'Sep
;; - 'Oct
;; - 'Nov
;; - 'Dec
;; INTERP: represents a month in a calendar year. 






(define-struct conference (title author cname location month year))
;; Constructor Template:
;; A Conference is (make-conference String Author String String Month Year)
;; INTERP: represents a conference paper with title, author, conference name,
;;         conference location, month and year

;;; Data Examples
(define JOHN-FULL-CONF (make-conference "Anatomy of a mouse"
                                        JOHN-FULL
                                        "Animal Anatomy"
                                        "London, UK"
                                        'Jul
                                        2003))
(define JOHN-OFFICIAL-CONF (make-conference "Anatomy of a mouse"
                                            JOHN-OFFICIAL
                                            "Animal Anatomy"
                                            "London, UK"
                                            'Jul
                                            2003))


;; Deconstructor Template:
;; conference-fn : Conference => ???
#; (define (conference-fn)
     ... conference-title ...
     ... conference-author ... (author-fn conference-author)
     ... conference-cname ...
     ... conference-location ...
     ... conference-month ...
     ... conference-year ...)



;; An Issue is a PosInt
;; INTERP: represents a journal's issue number





(define-struct journal (title author jname issue month year))
;; Constructor Template:
;; A Journal is (make-journal String Author String Issue Month Year)
;; INTERP: represents a journal paper with title, author, journal name,
;;         month and year.

;;; Data Examples
(define JOHN-FULL-JOURNAL  (make-journal "Anatomy of a mouse"
                                         JOHN-FULL
                                         "Mouse Journal"
                                         23
                                         'Feb
                                         2002))

(define JOHN-OFFICIAL-JOURNAL  (make-journal "Anatomy of a mouse"
                                             JOHN-OFFICIAL
                                             "Mouse Journal"
                                             23
                                             'Feb
                                             2002))

;; Deconstructor Template:
;; journal-fn : Journal => ???
#; (define (journal-fn)
     ... journal-title ...
     ... journal-author ... (author-fn journal-author)
     ... journal-jname ...
     ... journal-issue ...
     ... journal-month ...
     journal-year ...)






(define-struct techreport (title author tr-id institution year))
;; Constructor Template:
;; A TechnicalReport is (make-techreport String Author PosInt String Year)
;; INTERP: represents a technical report with title, author,
;;         technical report id, institution name, month and year.


;;; Data Examples

(define JOHN-FULL-TR (make-techreport "Anatomy of a mouse"
                                      JOHN-FULL
                                      1234
                                      "Mouse University"
                                      2001))


(define JOHN-OFFICIAL-TR (make-techreport "Anatomy of a mouse"
                                          JOHN-OFFICIAL
                                          1234
                                          "Mouse University"
                                          2001))


;; Deconstructor Template
;; techreport-fn : TechnicalReport => ???
#; (define (techreport-fn)
     ... techreport-title ...
     ... techreport-author ... (author-fn techreport-author)
     ... techreport-tr-id ...
     ... techreport-institution ...
     ... techreport-year ...)






;; A Publication is one of
;; - Conference
;; - Journal
;; - TechnicalReport
;; INTERP: represents a publication as either a confrence, journal or
;;         technical report. 

;; Deconstructor Template:
;; 


;; Data Examples




;;;; Definitions
;; N/A

;;;; Signature
;; tr->journal : TechnicalReport Journal

;;;; Purpose: To turn a technical report into a Journal
;; GIVEN: a technical report, the journal name and its issue, month, year
;; RETURNS: a journal with the technical reports information

;;;; Examples:
;;(tr->journal (make-techreport "My Mouse Report"
;;                                      JANE-FULL
;;                                      1234
;;                                      "Mouse University"
;;                                      1987)
;;             (make-journal "Anatomy of a mouse"
;;                                         JOHN-FULL
;;                                         "Mouse Journal"
;;                                        23
;;                                        'Feb
;;                                         2002)) =>
;;(make-journal "My Mouse Report" JANE-FULL 23 'Feb 2002)

;;;; Function Definition:

;;;; Tests:

     