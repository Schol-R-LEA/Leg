#!r6rs 

(import 
 (rnrs base (6))
 ;; composite standard library, imports most std libs
 (rnrs (6))  
 ;; unit testing
 (srfi :64)
 (leg labels)
 (leg listing)
 (leg instruction-generators))


(define runner (test-runner-simple))

(test-with-runner
 runner
 (test-group 
  "Tests of support functions and data types."
  (test-group 
   "(label->symbol) utility function."
   ;; first, show that the operations on labels are sensible
   (let* ((test-label (string->label "test-label"))
          (sym (label->symbol test-label)))
     (test-equal test-label 'test-label:)
     (test-equal sym 'test-label)))

  (test-group 
   "Construction of and operations on the 'assembly-listing-line' type."
   (let*
       ((label-line (make-assembly-listing-line 0 0 '() 'start:))
        (nop (make-bytevector 4 0))
        (add-op #vu8(00 00 00 00))
        (test-data #vu8(1 3 7 15 31 63 127 255))
        (nop-line (make-assembly-listing-line 1 4 nop '(nop)))
        (add-line (make-assembly-listing-line 1 4 nop '(adds r0 r0 (imm 1))))
        (data-label-line (make-assembly-listing-line 0 0 '() 'pow2:))
        (data-definitions-line (make-assembly-listing-line 4 8 nop '(def-bytes 1 3 7 15 31 63 127 255)))
        (reserved-space (make-bytevector 8 0))
        (reserved-data-label-line (make-assembly-listing-line 0 0 '() 'pow2:))
        (reserved-data-declarations-line (make-assembly-listing-line 4
                                                                     8
                                                                     reserved-space
                                                                     '(reserve-bytes 8))))

     
     (test-equal (get-line-number label-line) 0)
     (test-equal (get-line-size label-line) 0)
     (test-equal (get-line-byte-values label-line) '())
     (test-equal (get-line-source-code label-line) 'start:)
     (test-equal (get-line-number nop-line) 1)
     (test-equal (get-line-size nop-line) 4)
     (test-equal (get-line-byte-values nop-line) nop)
     (test-equal (get-line-source-code nop-line) '(nop))

     (test-error (make-assembly-listing-line 'bad-type 4 nop '(nop)))
     (test-error (make-assembly-listing-line -11 4 '(nop)))
     (test-error (make-assembly-listing-line 1 4 'bad-value '(nop)))
     (test-error (make-assembly-listing-line 1 -4 nop '(nop)))
     (test-error (make-assembly-listing-line 1 4 '() '(nop)))))


  (test-group 
   "Construction of and operations on the 'assembly-results-record' type."
   (test-assert #t))

  (test-group 
   "Construction of and operations on the 'label-record' type."
   (let ((unresolved-label (make-label-record 'unresolved:))
         (resolved-label (make-label-record 'resolved: #x1234)))
     (test-equal (get-label unresolved-label) 'unresolved)
     (test-equal (get-label-address unresolved-label) #f)
     (set-label-address unresolved-label #x555000)
     (test-equal (get-label-address unresolved-label) #x555000)
     (test-equal (get-label resolved-label) 'resolved)     
     (test-equal (get-label-address resolved-label) #x1234)
     (test-error ((make-label-record 'not-a-label #x99999999)))))

  (test-group 
   "Operations on packed bytevectors."
   (test-group 
    "(bitwise-pack) utility function."
    (let* ((high (bitwise-ior 0 (bitwise-arithmetic-shift-left #xA 4)))
           (low (bitwise-ior high #x5))
           (test-high '((#xA . (7 . 4))))
           (test-low  '((#x5 . (3 . 0))))            
           (test-high-low (append test-high test-low)))
      (test-equal #x5 (bitwise-pack 0 'combine 8 test-low))
      (test-equal #xA0 (bitwise-pack 0 'combine 8 test-high))      
      (test-equal #xA5 (bitwise-pack 0 'combine 8 test-high-low)))))))
