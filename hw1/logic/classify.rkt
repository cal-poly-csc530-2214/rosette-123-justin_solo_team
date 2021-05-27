#lang rosette

(require rackunit)

(provide (all-defined-out))

; Takes as input a propositional formula and returns
; * 'TAUTOLOGY if every interpretation I satisfies F;
; * 'CONTRADICTION if no interpretation I satisfies F;
; * 'CONTINGENCY if there are two interpretations I and I′ such that I satisfies F and I' does not.
(define (classify F)
  (cond
    [(unsat? (solve (assert (! F)))) 'TAUTOLOGY] ; are interpretations of (not F) unsatisfiable?
    [(unsat? (solve (assert F))) 'CONTRADICTION] ; are interpretations of F unsatisfiable?
    [else 'CONTINGENCY])) ; otherwise

(define-symbolic* p q r boolean?)

; (p → (q → r)) → (¬r → (¬q → ¬p))
(define f0 (=> (=> p (=> q r)) (=> (! r) (=> (! q) (! p)))))

; (p ∧ q) → (p → q)
(define f1 (=> (&& p q) (=> p q)))

; (p ↔ q) ∧ (q → r) ∧ ¬(¬r → ¬p)
(define f2 (&& (<=> p q) (=> q r) (! (=> (! r) (! q)))))

(check-equal? (classify f0) 'CONTINGENCY)
(check-equal? (classify f1) 'TAUTOLOGY)
(check-equal? (classify f2) 'CONTRADICTION)

