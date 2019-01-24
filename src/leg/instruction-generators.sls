#!r6rs

(library (leg instruction-generators)
  (export
   ;data-manipulation-instruction
          primary-opcodes-reverse-lookup
          condition-codes data-opcodes
          bitwise-pack get-packable-value
          get-packing-high-bit get-packing-low-bit
          )
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6)))

  
  (define (bitwise-packing-field? field)
    (and
     (pair? field)
     (integer? (car field))
     (pair? (cdr field))
     (integer? (cadr field))
     (integer? (cddr field))
     (> (cadr field) 0)
     (> (cadr field) (cddr field))))


  (define (get-packable-value field)
    (if (bitwise-packing-field? field)
        (car field)))
  
  (define (get-packing-high-bit field)
    (if (bitwise-packing-field? field)
        (cadr field)))

  (define (get-packing-low-bit field)
    (if (bitwise-packing-field? field)
        (cddr field)))
  
  (define (bitwise-pack mask max-size . fields)
    "pack a series of integer field values into a single bitstring of size max-size.
     Takes a bit mask starting value, a maximum field size, a 'packing manifest'
     consisting of a pair with a value and a pair consisting of a high and low bit number
     for where to insert the value, and an optional list of additional 'manifests'.
     example uses:
         (bitwise-pack 0 8 '((#xA 7 . 4)) (#x5 3 . 0))))  ==> #xA5

     Primarily meant to be used for preparing fields in a bytevector."
    (display mask)
    (newline)
    (display max-size)
    (newline)
    (display (car fields))
    (newline)
    (if (and (not (null? fields))
             (list? fields)
             (not (null? (car fields)))
             (bitwise-packing-field? (caar fields))
             (> max-size (get-packing-high-bit (caar fields))))
        (let* ((field (caar fields))
               (result
                (bitwise-ior
                 mask
                 (bitwise-arithmetic-shift-left
                  (get-packable-value field)
                  (get-packing-low-bit field)))))
          (display result)
          (newline)
          (bitwise-pack result
                        (get-packing-high-bit field)
                        (cdar fields)))
        (begin
          (display "Final mask value is: ")
          (display mask)
          (newline)
          mask)))
  

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
      (mvn 15)))


  )



