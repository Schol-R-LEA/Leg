#!r6rs

(library (leg assembly-record)
  (export
   reg register-file-32
   r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r13 r14 r15
   link pc)
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6)))

  (define (reg n)
    (if (and (integer? n) (< 16 n))
        n
        #f))

  (define register-file-32
    '(r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r13 r14 r15 link pc))
  
  (define r0 0)
  (define r1 1)
  (define r2 2)
  (define r3 3)
  (define r4 4)
  (define r5 5)
  (define r6 6)
  (define r7 7)
  (define r8 8)
  (define r9 9)
  (define r10 10)
  (define r11 11)
  (define r12 12)
  (define r13 13)
  (define r14 14)
  (define r15 15)

  (define link 14)
  (define pc 15))  
