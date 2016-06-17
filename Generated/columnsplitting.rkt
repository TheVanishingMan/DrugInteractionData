#lang racket

(define lengthoflist 4881)
(define numberofnodes 100)
(define x (round (/ lengthoflist numberofnodes)))

(define node2
  (λ (n)
    (/ (* n (- n 1)) 2)))

(define node3
  (λ (start end)
    (- (node2 end) (node2 start))))

(define sortamax (round (/ (/ (* lengthoflist (- lengthoflist 1)) 2) numberofnodes))) ;;119096

(define split-columns
  (λ (start next node)
    (cond
      ((> next 4881) 'limit)
      ((> (node3 start next) sortamax) (and (println next) (split-columns (+ next 1) next node)))
      (else  (split-columns start (+ next 1) node))
      )))
