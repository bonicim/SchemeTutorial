;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname space_invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
;;#reader(lib "htdp-beginner-reader.ss" "lang")((modname HW_5_space-invaders-pt2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/image)
(require 2htdp/universe)

;; An Invader is a Posn
;; INTERP: represents the location of the invader
                    
;; A Bullet is a Posn
;; INTERP: represents the location of a bullet

;; A Location is a Posn
;; INTERP: represents a location of a spaceship
                    
;; A Direction is one of:
;; - 'left
;; - 'right
;; INTERP: represent direction of movement for the spaceship
                    
(define-struct ship (dir loc))
;; A Ship is (make-ship Direction Location)
;; INTERP: represent the spaceship with its current direction
;;         and movement


                    
;; A List of Invaders (LoI) is one of
;; - '()
;; - (cons Invader LoI)
                    
;; A List of Bullets (LoB) is one of
;; - '()
;; - (cons Bullet LoB)
                    
(define-struct world (ship invaders ship-bullets invader-bullets))
;; A World is (make-world Ship LoI LoB LoB)
;; INTERP: represent the ship, the current list of invaders, the inflight spaceship bullets
;;         and the inflight invader bullets
                    
                    
(define WIDTH 500)
(define HEIGHT 500)
                    
(define MAX-SHIP-BULLETS 3)
                    
(define MAX-INVADER-BULLETS 15)
                    
(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define SPACESHIP-BULLET-IMAGE (circle 2 'solid 'green))
                    
(define SHIP-WIDTH 25)
                    
(define SHIP-HEIGHT 15)

(define RB 480)

(define LB 20)

(define SPACESHIP-IMAGE (rectangle SHIP-WIDTH SHIP-HEIGHT 'solid 'black))
                    
(define INVADER-SIDE 20)
                    
(define INVADER-IMAGE (square INVADER-SIDE 'solid 'red))
                    
(define INVADER-BULLET-IMAGE (circle 2 'solid 'black))
                    
(define SHIP-SPEED 10)
                    
(define BULLET-SPEED 10)
                    
(define SHIP-INIT (make-ship 'left (make-posn 250 480)))
                    
(define INVADERS-INIT
  (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20)
        (make-posn 220 20) (make-posn 260 20) (make-posn 300 20)
        (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
        (make-posn 100 50) (make-posn 140 50) (make-posn 180 50)
        (make-posn 220 50) (make-posn 260 50) (make-posn 300 50)
        (make-posn 340 50) (make-posn 380 50) (make-posn 420 50)
        (make-posn 100 80) (make-posn 140 80) (make-posn 180 80)
        (make-posn 220 80) (make-posn 260 80) (make-posn 300 80)
        (make-posn 340 80) (make-posn 380 80) (make-posn 420 80)
        (make-posn 100 110) (make-posn 140 110) (make-posn 180 110)
        (make-posn 220 110) (make-posn 260 110) (make-posn 300 110)
        (make-posn 340 110) (make-posn 380 110) (make-posn 420 110)))
                    
(define WORLD-INIT (make-world SHIP-INIT INVADERS-INIT empty empty))

(define w1 (make-world SHIP-INIT INVADERS-INIT
                       (cons (make-posn 1 1) (cons (make-posn 250 250)'()))
                       (cons (make-posn 450 450) (cons (make-posn 75 75) '()))))


;; world-draw : World -> Image
;; Draw the world on the canvas
(define(world-draw w)
  (place-image
   SPACESHIP-IMAGE (posn-x (ship-loc (world-ship w))) (posn-y (ship-loc (world-ship w)))
   (draw-ship-bullets (world-ship-bullets w)
                      (draw-invader-bullets (world-invader-bullets w)
                                            (draw-invaders (world-invaders w))))))
(check-expect (world-draw (make-world
                           (make-ship 'right (make-posn 100 50))
                           (cons (make-posn 145 55) '()) '() '()))
              (place-image SPACESHIP-IMAGE 100 50
                           (place-image INVADER-IMAGE 145 55 BACKGROUND)))
(check-expect (world-draw (make-world
                           (make-ship 'right (make-posn 120 75))
                           (cons (make-posn 13 19) '()) '() '()))
              (place-image SPACESHIP-IMAGE 120 75
                           (place-image INVADER-IMAGE 13 19 BACKGROUND)))
(check-expect (world-draw (make-world
                           (make-ship 'right (make-posn 120 75))
                           (cons (make-posn 13 19) '()) (cons (make-posn 5 5)'()) '()))
              (place-image SPACESHIP-IMAGE 120 75
                           (place-image SPACESHIP-BULLET-IMAGE 5 5
                                        (place-image INVADER-IMAGE 13 19 BACKGROUND))))
(check-expect (world-draw (make-world
                           (make-ship 'right (make-posn 120 75))
                           (cons (make-posn 13 19) '()) '() (cons (make-posn 45 45)'())))
              (place-image SPACESHIP-IMAGE 120 75
                           (place-image INVADER-BULLET-IMAGE 45 45
                                        (place-image INVADER-IMAGE 13 19
                                                     BACKGROUND))))


;; draw-invaders : LoI -> Image
;; draws the invader image at every invader posn on top of BACKGROUND
(define (draw-invaders lop)
  (cond [(empty? lop) BACKGROUND]
        [(cons? lop) (place-image INVADER-IMAGE (posn-x(first lop)) (posn-y (first lop))
                                  (draw-invaders (rest lop)))]))

(check-expect (draw-invaders (cons (make-posn 67 98) (cons (make-posn 77 87) '())))
              (place-image INVADER-IMAGE 67 98
                           (place-image INVADER-IMAGE 77 87 BACKGROUND)))
(check-expect (draw-invaders (cons (make-posn 99 108) (cons (make-posn 4 37) '())))
              (place-image INVADER-IMAGE 99 108
                           (place-image INVADER-IMAGE 4 37 BACKGROUND)))
(check-expect (draw-invaders (cons (make-posn 5 8) (cons (make-posn 87 43) '())))
              (place-image INVADER-IMAGE 5 8
                           (place-image INVADER-IMAGE 87 43 BACKGROUND)))
(check-expect (draw-invaders '()) BACKGROUND)

;; draw-ship-bullets : LoP SCENE -> Image
;; draws the ship bullet image at every ship bullet posn on top of a scene
(define (draw-ship-bullets lop scene)
  (cond [(empty? lop) scene]
        [(cons? lop) (place-image SPACESHIP-BULLET-IMAGE (posn-x(first lop)) (posn-y (first lop))
                                  (draw-ship-bullets (rest lop) scene))]))

(check-expect (draw-ship-bullets (cons (make-posn 17 35) (cons (make-posn 56 45) '())) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 17 35
                           (place-image SPACESHIP-BULLET-IMAGE 56 45 BACKGROUND)))
(check-expect (draw-ship-bullets (cons (make-posn 77 19) (cons (make-posn 170 145) '())) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 77 19
                           (place-image SPACESHIP-BULLET-IMAGE 170 145 BACKGROUND)))
(check-expect (draw-ship-bullets (cons (make-posn 44 135) (cons (make-posn 9 13) '())) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 44 135
                           (place-image SPACESHIP-BULLET-IMAGE 9 13 BACKGROUND)))
(check-expect (draw-ship-bullets '() BACKGROUND) BACKGROUND)

;; draw-invader-bullets : LoP SCENE -> Image
;; draws the invader bullet image at every invader bullet posn on top of a scene
(define (draw-invader-bullets lop scene)
  (cond [(empty? lop) scene]
        [(cons? lop) (place-image INVADER-BULLET-IMAGE (posn-x(first lop)) (posn-y (first lop))
                                  (draw-invader-bullets (rest lop) scene))]))

(check-expect (draw-invader-bullets (cons (make-posn 1 1) (cons (make-posn 5 5) '())) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 1 1
                           (place-image INVADER-BULLET-IMAGE 5 5 BACKGROUND)))
(check-expect (draw-invader-bullets (cons (make-posn 50 7) (cons (make-posn 35 52) '())) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 50 7
                           (place-image INVADER-BULLET-IMAGE 35 52 BACKGROUND)))
(check-expect (draw-invader-bullets
               (cons (make-posn 124 13) (cons (make-posn 57 520) '())) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 124 13
                           (place-image INVADER-BULLET-IMAGE 57 520 BACKGROUND)))
(check-expect (draw-invader-bullets '() BACKGROUND) BACKGROUND)



;; move-right : Ship -> Ship
;; takes a ship and increments the x posn by SPEED
(define (move-right ship)
  (make-ship 'right (make-posn (+(posn-x (ship-loc ship)) SHIP-SPEED) (posn-y (ship-loc ship)))))

(check-expect (move-right (make-ship 'right (make-posn 220 100)))
              (make-ship 'right (make-posn 230 100)))
(check-expect (move-right (make-ship 'right (make-posn 10 100)))
              (make-ship 'right (make-posn 20 100)))
(check-expect (move-right (make-ship 'right (make-posn 0 100)))
              (make-ship 'right (make-posn 10 100)))

;; move-left : Ship -> Ship
;; takes a ship and decrements the x posn by SPEED
(define (move-left ship)
  (make-ship 'left (make-posn (-(posn-x (ship-loc ship)) SHIP-SPEED) (posn-y (ship-loc ship)))))

(check-expect (move-left (make-ship 'left (make-posn 220 100))) (make-ship 'left (make-posn 210 100)))
(check-expect (move-left (make-ship 'left (make-posn 10 100))) (make-ship 'left (make-posn 0 100)))
(check-expect (move-left (make-ship 'right (make-posn 0 100))) (make-ship 'left (make-posn -10 100)))

;; at-rb? : Ship -> Boolean
;; checks if the ship position is at the right bound
(define (at-rb? ship)
  (= (posn-x (ship-loc ship)) RB))

(check-expect (at-rb? (make-ship 'right (make-posn 480 100))) #true)
(check-expect (at-rb? (make-ship 'right (make-posn 0 100))) #false)
(check-expect (at-rb? (make-ship 'right (make-posn 220 100))) #false)

;; at-lb? : Ship -> Boolean
;; checks if the ship position is at the left bound
(define (at-lb? ship)
  (= (posn-x (ship-loc ship)) LB))

(check-expect (at-lb? (make-ship 'right (make-posn 480 100))) #false)
(check-expect (at-lb? (make-ship 'right (make-posn 20 100))) #true)
(check-expect (at-lb? (make-ship 'right (make-posn 220 100))) #false)

;; move-ship : WORLD KeyEvent -> WORLD
;; move the ship right if key is right and ship not at bound or left if key is left and not at bound 
(define (move-ship w ke)
  (cond[(and (key=? ke "right") (at-rb? (world-ship w)))
        (update-ship (make-ship 'right (make-posn RB (posn-y (ship-loc (world-ship w))))) w)]
       [(and (key=? ke "left") (at-lb? (world-ship w)))
        (update-ship (make-ship 'left (make-posn LB (posn-y (ship-loc (world-ship w))))) w)]
       [(key=? ke "right") (update-ship (move-right (world-ship w)) w)]
       [(key=? ke "left") (update-ship (move-left (world-ship w)) w)]
       [(key=? ke " ")(if (< (list-len (world-ship-bullets w)) 3)(player-fire w) w)]
       [else(update-ship (make-ship (ship-dir (world-ship w)) (ship-loc (world-ship w))) w)]))

(check-expect (move-ship (make-world (make-ship 'right (make-posn 100 100)) '() '() '()) "right")
              (make-world (make-ship 'right (make-posn 110 100)) '() '() '()))
(check-expect (move-ship (make-world (make-ship 'right (make-posn 480 100)) '() '() '()) "right")
              (make-world (make-ship 'right (make-posn 480 100)) '() '() '()))
(check-expect (move-ship (make-world (make-ship 'right (make-posn 20 100)) '() '() '()) "left")
              (make-world (make-ship 'left (make-posn 20 100)) '() '() '()))
(check-expect (move-ship (make-world (make-ship 'right (make-posn 120 100)) '() '() '()) "left")
              (make-world (make-ship 'left (make-posn 110 100)) '() '() '()))
(check-expect (move-ship (make-world (make-ship 'right (make-posn 48 100)) '() '() '()) "up")
              (make-world (make-ship 'right (make-posn 48 100)) '() '() '()))

#;(define (move-world w)
  (make-world
   (make-ship (ship-dir (world-ship w)) (ship-loc (world-ship w)))
   (world-invaders w)
   (move-spaceship-bullets (world-ship-bullets w))
   (move-invader-bullets (world-invader-bullets w))))


(define (list-len list)
  (cond [(empty? list) 0]
        [(cons? list)(+ 1 (list-len (rest list)))]))

(define (player-fire w)
  (make-world
   (make-ship (ship-dir (world-ship w)) (ship-loc (world-ship w)))
   (world-invaders w)
   (cons (make-posn (posn-x (ship-loc (world-ship w))) (posn-y (ship-loc (world-ship w))))(world-ship-bullets w))
   (world-invader-bullets w)))

;;LoI LoB -> LoB
#;(define (invader-fire invaders invader-bullets)
  (cond [(< (list-len invader-bullets) 10) (cons (random-invader invaders (random (list-len invaders))) invader-bullet)]
        [else(invader-bullets)]))

;; LoI Number -> Posn
;;(define (random-invader LoI))

(define test1 (list (make-posn 5 5) (make-posn 6 6) (make-posn 7 7) (make-posn 9 9)))

(define (random-invader invaders num)
  (cond [(empty? invaders) '()]
        [(cons? invaders) (if (= 0 num)
                                   (first invaders)
                                   (random-invader (rest invaders) (- num 1)))]))


;; update-ship : Ship World -> World
;; makes a new world with the updated ship everything else is unchanged
(define (update-ship ns w)
  (make-world ns (world-invaders w) (world-ship-bullets w) (world-invader-bullets w)))

(check-expect (update-ship (make-ship 'right (make-posn 5 5))
                           (make-world
                            (make-ship 'left (make-posn 10 10))
                            (cons (make-posn 1 1) '()) '() '()))
              (make-world (make-ship 'right (make-posn 5 5)) (cons (make-posn 1 1) '()) '() '()))

(check-expect (update-ship (make-ship 'left (make-posn 345 15))
                           (make-world
                            (make-ship 'left (make-posn 10 10))
                            '() '() '()))
              (make-world (make-ship 'left (make-posn 345 15)) '() '() '()))

(check-expect (update-ship (make-ship 'right (make-posn 12 19))
                           (make-world
                            (make-ship 'left (make-posn 10 10))
                            '() '() '()))
              (make-world (make-ship 'right (make-posn 12 19)) '() '() '()))

(check-expect (update-ship (make-ship 'right (make-posn 34 190))
                           (make-world
                            (make-ship 'left (make-posn 10 10)) (cons (make-posn 15 15)
                                                                      '()) '() '()))
              (make-world (make-ship 'right (make-posn 34 190)) (cons (make-posn 15 15) '()) '() '()))


(define IB1 (cons (make-posn 4 4) (cons (make-posn 35 66) (cons (make-posn 45 500) '()))))
(define IB2 (cons (make-posn 4 4) (cons (make-posn 35 66) (cons (make-posn 45 510) '()))))

;; in bounds : Posn -> Boolean
;; determines if a posn is within the bounds of the scene
(define (in-bounds p)
  (and (<= 0 (posn-x p) WIDTH) (<= 0 (posn-y p) HEIGHT)))

(check-expect (in-bounds (make-posn 0 0)) #true)
(check-expect (in-bounds (make-posn -1 0)) #false)
(check-expect (in-bounds (make-posn 230 15)) #true)
(check-expect (in-bounds (make-posn 501 0)) #false)
(check-expect (in-bounds (make-posn 500 500)) #true)
(check-expect (in-bounds (make-posn -10 490)) #false)

                            
;; move-spaceship-bullets : LoB -> LoB
;; move each spaceship bullet in the list upwards by SPEED units, removes bullet if out of bounds
(define (move-spaceship-bullets lob)
  (cond[(empty? lob) '()] 
       [(and(cons? lob) (in-bounds (first lob)))
        (cons (make-posn (posn-x (first lob)) (- (posn-y (first lob)) BULLET-SPEED))
              (move-spaceship-bullets (rest lob)))]
       [else(move-spaceship-bullets (rest lob))]))

(check-expect (move-spaceship-bullets (cons (make-posn 4 5) (cons (make-posn 7 7) '())))
              (cons (make-posn 4 -5) (cons (make-posn 7 -3) '())))
(check-expect (move-spaceship-bullets '()) '())
(check-expect (move-spaceship-bullets (cons (make-posn 510 25) '())) '())
(check-expect (move-spaceship-bullets (cons (make-posn 550 60) (cons (make-posn 28 56) '())))
              (cons (make-posn 28 46) '()))

;; move-invader-bullets : LoB -> LoB
;; move each bullet in the list downwards by SPEED units, removes bullet if out of bounds
(define (move-invader-bullets lob)
  (cond[(empty? lob) '()]
       [(and(cons? lob) (in-bounds (first lob)))
        (cons (make-posn (posn-x (first lob)) (+ (posn-y (first lob)) BULLET-SPEED))
              (move-invader-bullets (rest lob)))]
       [else(move-spaceship-bullets (rest lob))]))

(check-expect (move-invader-bullets (cons (make-posn 4 5) (cons (make-posn 7 7) '())))
              (cons (make-posn 4 15) (cons (make-posn 7 17) '())))
(check-expect (move-invader-bullets '()) '())
(check-expect (move-invader-bullets (cons (make-posn 510 25) '())) '())
(check-expect (move-invader-bullets (cons (make-posn 45 66) (cons (make-posn 33 52) '())))
              (cons (make-posn 45 76) (cons (make-posn 33 62) '())))
(check-expect (move-invader-bullets (cons (make-posn 510 25) (cons (make-posn 410 550) '()))) '())





;; invaders-fire : LoB LoI -> LoB
;; fire from a random invader to hit the ship
                            
;; remove-hits-and-out-of-bounds: World -> World
;; remove any invaders that have been hit by a spaceship bullet.
;; Remove any bullets that are out of bounds
                            
;; ship-hit : Ship LoB -> Boolean
;; true if a bullet hit the ship, false otherwise

;;(define-struct world (ship invaders ship-bullets invader-bullets))

(define (invader-fire invaders invader-bullets)
  (cond [(< (list-len invader-bullets) 10) (cons (random-invader invaders (random (list-len invaders))) invader-bullets)]
        [else invader-bullets]))


#;(define (move-world w)
  (make-world
   (make-ship (ship-dir (world-ship w)) (ship-loc (world-ship w)))
   (world-invaders w)
   (move-spaceship-bullets (world-ship-bullets w))
   (move-invader-bullets (world-invader-bullets w))))

(define (move-world w)
  (make-world
   (make-ship (ship-dir (world-ship w)) (ship-loc (world-ship w)))
   (world-invaders w)
   (move-spaceship-bullets (world-ship-bullets w))
   (move-invader-bullets (invader-fire (world-invaders w) (world-invader-bullets w)))))

(define (main w)
    (big-bang w
      [to-draw world-draw]
      [on-tick move-world]
      [on-key move-ship]))

(main w1)