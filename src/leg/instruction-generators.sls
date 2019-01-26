#!r6rs

(library (leg instruction-generators)
  (export
   ;; data-manipulation-instruction
   primary-opcodes-reverse-lookup
   condition-codes data-opcodes
   )
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6))
          (leg bitfield-packing))


  (define primary-opcodes-reverse-lookup
    '((data 0)
      (branch 2)
      (load 4)))
  
  (define condition-codes
    '((eq 0)
      (ne 1)
      (cs 2)
      (cc 3)
      (mi 4)
      (pl 5)
      (vs 6)
      (vc 7)
      (hi 8)
      (ls 9)
      (ge 10)
      (lt 11)
      (gt 12)
      (le 13)
      (al 14)
      (nv 15)))


  (define data-opcodes
    '((and 0)
      (eor 1)
      (sub 2)
      (rsb 3)
      (add 4)
      (adc 5)
      (sbc 6)
      (rsc 7)
      (tst 8)
      (teq 9)
      (cmp 10)
      (cmn 11)
      (orr 12)
      (mov 13)
      (bic 14)
      (mvn 15))))



