#!r6rs 

(import 
 (rnrs base (6))
 (rnrs exceptions (6))
 (rnrs io simple (6))
 (rnrs hashtables (6))
 (rnrs records syntactic (6))
 (rnrs records procedural (6))
 (srfi :64)   ; unit testing
 (srfi :88)  ; keywords
 (leg components))


(define runner (test-runner-simple))



(test-with-runner 
 runner
 (test-group 
  "Tests of the support functions for accessing the intermediate data"
  
  )
 (test-group 
  "Tests of Leg pass one operations"
  (test-group 
   "Empty code list"
   (let-values ((processed-code 
                 lines 
                 size)
                (semi-assembled lines '(() 0 0)))
               (test-equal '() processed-code)
               (test-equal lines 0)
               (test-equal lines (length processed-code))
               (test-equal size 0)))

  (test-group 
   "Single instruction"
   (let-values ((processed-code
                 lines 
                 size)
                (make-assembly-encoding '((add imm) r0 r0 1))
                (test-equal lines 1)
                (test-equal size 4)
                (test-equal (processed-code) )))

   (test-group 
    "Single label, no instructions"
    (let-values ((processed-code
                  lines 
                  size)
                 (make-assembly-encoding '(test-label:)))
                (test-equal lines 1)
                (test-equal size 0)
                (test-equal test-label: 0)))
   
   (test-group 
    "Single label, two instruction following"
    (let-values ((processed-code
                  lines
                  size)
                 (make-assembly-encoding 
                  '(test-label:
                    ((add imm) r0 r0 1)
                    (b test-label))))
                (test-equal lines 3)
                (test-equal size (* 2 4))
                (test-equal test-label: 0)))
   
   (test-group
    "Single label, one instruction prior and following"
    (let-values ((processed-code
                  lines
                  size)
                 (make-assembly-encoding 
                  '(((add imm) r0 r0 1)
                    test-label:
                    (b test-label:))))
                (test-equal lines 3)
                (test-equal size (* 2 4))
                (test-equal test-label: 0)))))
