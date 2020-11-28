;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname snakegame) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
;; reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname snake-in-class) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
                                                                                                    
(require 2htdp/image)
(require 2htdp/universe)

                                                                                                                                                   

;; A Food is a Posn

;; Deconstructor
;; food-fn: Food -> ???
#;(define (food-fn food)
    ... (posn-x food) ...
    ... (posn-y food) ...)

;; INTERP: represents the food item on the canvas


(define UP 'up)
(define DOWN 'down)
(define LEFT 'left)
(define RIGHT 'right)


;; A Direction is one of 
;; - UP
;; - DOWN 
;; - LEFT
;; - RIGHT
;; INTERP: represents the snake's direction 

;; Deconstructor
;; direction-fn: Direction -> ???
#;(define (direction-fn direction)
    (cond
      [(symbol=? UP direction) ...]
      [(symbol=? DOWN direction) ...]
      [(symbol=? LEFT direction) ...]
      [(symbol=? RIGHT direction) ...]))


;; A Segment is a Posn
;; INTERP: represents one section of the snake

;; Deconstructor
;; segment-fn: Segment -> ???
#;(define (segment-fn segment)
    ... (posn-x segment) ...
    ... (posn-y segment) ...)


;; A ListOfSegments (Segments) is one of
;; - empty
;; - (cons Segment Segements)
;; INTERP: represents a list of segments

;; Deconstructor
;; segements-fn: Segments -> ???
#;(define (segments-fn segments)
    (cond
      [(empty? segments) ...]
      [(cons? segments) ... (posn-fn (first segments)) ...
                        ... (segments-fn (rest segments)) ...]))
                        
                    

;; A Snake is (make-snake Direction Segments)
;; INTERP: represents a snake with direction and body segments
(define-struct snake (dir segments))

;; Deconstructor
;; snake-fn: Snake -> ???
#;(define (snake-fn snake)
    ... (direction-fn (snake-dir snake)) ...
    ... (segments-fn (snake-segments snake)) ...)
               


;; A World is (make-world Snake Food)
;; INTERP:  snake represents the snake in the game 
;;          food represents the food in the game 
(define-struct world (snake food))

;; Deconstructor
;; world-fn : World -> ???
#;(define (world-fn world)
    ... (snake-fn (world-snake world)) ...
    ... (food-fn (world-food world)) ...)


                                                                 

(define WIDTH 400) ;; scene width in pixels

(define HEIGHT 400) ;; scene height in pixels

(define SEGMENT-SIDE 10) ;; segment side in pixels

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define FOOD-IMAGE (square SEGMENT-SIDE 'solid 'green)) 

(define SEGMENT-IMAGE (square SEGMENT-SIDE 'solid 'red))

(define SNAKE-INIT (make-snake 'right (list (make-posn 10 10))))

(define FOOD-INIT (make-posn 200 200))

(define WORLD-INIT (make-world SNAKE-INIT FOOD-INIT))

                                                                  

;;;; Signature
;; draw-world : World -> Image
;;;; Purpose
;; GIVEN: a world 
;; RETURNS: an image representation of the given world  
(define (draw-world w)
  (draw-snake (world-snake w)
              (draw-food (world-food w) BACKGROUND)))

;;;; Signature
;; draw-snake : Snake Image -> Image
;;;; Purpose
;; GIVEN: a snake and an image
;; RETURNS: a new image that draws the snake on the given image 
(define (draw-snake s img)
  (draw-segments (snake-segments s) img))

;;;; Signature
;; draw-segments : Segments Image -> Image
;;;; Purpose
;; GIVEN: a list of Segments and an image
;; RETURNS: a new image with the segments drawn on the given image 
(define (draw-segments los img)
  (cond 
    [(empty? los) img]
    [else (place-image SEGMENT-IMAGE 
                       (posn-x (first los))
                       (posn-y (first los))
                       (draw-segments (rest los) img))]))

;;;; Siganture
;; draw-food : Food Image -> Image
;;;; Purpose
;; GIVEN: a food and an image
;; RETURNS: a new image that places the food on the given image
(define (draw-food f img)
  (place-image FOOD-IMAGE 
               (posn-x f)
               (posn-y f)
               img))

                                                                                                            

;;;; Signature 
;; world-step: World -> World
;;;; Purpose
;; GIVEN: the current world
;; RETURNS: the next world after one clock tick  
(define (world-step w)  
  (cond 
    [(eating? w) (eat&grow w)]
    [else (make-world (snake-move (world-snake w))
                      (world-food w))]))


;;;; Signature 
;; eat&grow : World -> World
;;;;; Purpose
;; GIVEN: the current world
;; RETURNS: a new world where 
;; 1. The snake moves in the given direction
;; 2. The snakes increases in size by one segment 
;; 3. A new food appears in a new random location 
(define (eat&grow w)
  (make-world (snake-grow (world-snake w))
              (make-posn (* SEGMENT-SIDE
                            (random (floor (/ WIDTH SEGMENT-SIDE))))
                         (* SEGMENT-SIDE
                            (random (floor (/ HEIGHT SEGMENT-SIDE)))))))

;;;; Signature 
;; snake-grow : Snake -> Snake
;;;; Purpose
;; GIVEN: the snake
;; RETURNS: the snake increased by 1 segment 
(define (snake-grow s)
  (make-snake (snake-dir s)
              (snake-move&grow (snake-segments s) (snake-dir s))))

;;;; Signature
;; snake-move&grow: Segments Direction  -> Segments
;;;; Purpose
;; GIVEN: a list of segments and a direction
;; RETURNS: a new list of segments by adding a new segment 
(define (snake-move&grow los dir)
  (cond 
    [(empty? los) los]
    [else (cons (create-new-head dir (first los))
                los)]))

;;;; Signature 
;; eating? : World -> Boolean 
;;;; Purpose
;; GIVEN: a world
;; RETURNS: true if the snake is about to consume a food else false
(define (eating? w)
  (segment-over-food (snake-segments (world-snake w)) (world-food w)))

;;;; Signature 
;; segment-over-food : Segments Food -> Boolean
;;;; Purpose
;; GIVEN: a list of segments and a food
;; RETURNS: True if the first of the list is over the food, false otherwise
(define (segment-over-food los food)
  (cond
    [(empty? los) false]
    [else (posn=? (first los) food)]))


;;;; Signature 
;;posn=? : Posn Posn -> Boolean
;;;; Purpose
;;GIVEN: two posns
;; RETURNS: true if the two posns have the same coordinates, false otherwise
(define (posn=? p1 p2)
  (and (= (posn-x p1) (posn-x p2))
       (= (posn-y p1) (posn-y p2))))


;;;; Signature 
;; snake-move : Snake -> Snake
;;;; Purpose: 
;; GIVEN: a snake
;; RETURNS: the snake after it moves by one segment distance in the
;;          correct direction 
(define (snake-move s)
  (make-snake (snake-dir s)
              (segments-move (snake-dir s) (snake-segments s))))


;;;; Signature 
;; segments-move : Direction Segments -> Segments
;;;; Purpose
;; GIVEN: a direction and a list of segments
;; RETURNS: the updated list of segments after moving one segment unit in the
;;          appropriate direction.
(define (segments-move dir los)
  (cond 
    [(empty? los) los]
    [else (cons (create-new-head dir (first los))
                (remove-last-element los))]))

;;;; Signature 
;; create-new-head : Direction Segment -> Segment
;;;; Purpose
;; GIVEN: a direction and a segment 
;; RETURNS: a new segment in the direction given 
(define (create-new-head dir segment)
  (cond 
    [(symbol=? 'up dir) 
     (make-posn (posn-x segment) (- (posn-y segment) SEGMENT-SIDE))] 
    [(symbol=? 'down dir) 
     (make-posn (posn-x segment) (+ (posn-y segment) SEGMENT-SIDE))]
    [(symbol=? 'left dir)
     (make-posn (- (posn-x segment) SEGMENT-SIDE) (posn-y segment))]
    [(symbol=? 'right dir) 
     (make-posn (+ (posn-x segment) SEGMENT-SIDE) (posn-y segment))]))

;;;; Signature 
;; remove-last-element : Segments -> Segments
;;;; Purpose
;; GIVEN: a list of segments
;; RETURNS: the same list with the last element removed
(define (remove-last-element los)
  (cond 
    [(empty? los) los]
    [(empty? (rest los)) empty]
    [else (cons (first los) (remove-last-element (rest los)))]))



;;;; Signature 
;; key-handler : World Key-Event -> World
;;;; Purpose
;; GIVEN: the current world and a key event
;; RETURNS: a new world with direction updated according to the key event.
(define (key-handler w ke)
  (cond 
    [(or (key=? ke "up")
         (key=? ke "down")
         (key=? ke "left")
         (key=? ke "right"))
     (make-world (make-snake (string->symbol ke)
                             (snake-segments (world-snake w)))
                 (world-food w))]
    [else w])) 




;;;; Signature 
;; end-game? : World -> Boolean
;;;; Signature 
;; GIVEN: the current world
;; RETURNS: true if one of the condition that end the game has been met,
;;          false otherwise
(define (end-game? w)
  (or (out-of-bounds? (snake-segments (world-snake w)))
      (snake-collide-with-self (snake-segments (world-snake w)))))

;;;; Signature 
;; snake-collide-with-self : Segments -> Boolean
;;;; Purpose
;; GIVEN: the list of segments that make up the snake
;; RETURNS: true if the head collides with another segment, false otherwise
(define (snake-collide-with-self los)
  (cond 
    [(empty? los) false]
    [else (head-collides-with-tail? (first los) (rest los))]))

;;;; Signature 
;; head-collides-with-tail? : Segment Segments -> Boolean
;;;; Purpose
;; GIVEN: a segment and a list of segments
;; RETURNS: true if the segment has the same coordinates as one of the elements
;;          in Segments, false otherwise 
(define (head-collides-with-tail? p lop)
  (cond
    [(empty? lop) false]
    [else (or (posn=? p (first lop))
              (head-collides-with-tail? p (rest lop)))]))

;;;; Signature 
;; out-of-bounds? : Segments -> Boolean
;;;; Purpose
;; GIVEN: a list of segments that represent the snake 
;; RETURNS: true if the head of the snake has gone out of bounds,
;;          false otherwise 
(define (out-of-bounds? los) 
  (cond 
    [(empty? los) false]
    [else (posn-out-of-bounds (first los))]))

;;;; Signature 
;; posn-out-of-bounds : Posn -> Boolean
;;;; Purpose
;; GIVEN: a posn
;; RETURNS: true if the posn is out of bounds, false otherwise
(define (posn-out-of-bounds p)
  (or (<  (posn-x p) 0)
      (>= (posn-x p) WIDTH)
      (<  (posn-y p) 0)
      (>= (posn-y p) HEIGHT)))


                                                                              

(big-bang WORLD-INIT
          (to-draw draw-world)
          (on-tick world-step 0.15)
          (on-key key-handler)
          (stop-when end-game?))



















