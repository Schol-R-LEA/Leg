#!r6rs 

(import 
 (rnrs base (6))
 ;; composite standard library, imports most std libs
 (rnrs (6))  
 ;; unit testing
 (srfi :64)
 (leg components))


(define runner (test-runner-simple))

(test-with-runner 
 runner
 (test-group 
  "Tests of support functions and data types"
  (test-group 
   "(keyword->symbol) utility function"
   ;; first, show that the operations on keywords are sensible
   (define label (string->label "test-keyword")
   (test-equal label 'test-keyword:)
   (define sym (label->symbol label))
   (test-equal sym 'test-keyword))

#|
  (test-group 
   "Construction of and operations on the 'assembly-listing-line' type"
   
  )


  (test-group 
   "Construction of and operations on the 'assembly-results-record' type"
  )
|#
)))
  

  
#|
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
                 ( 
                  '(((add imm) r0 r0 1)
                    test-label:
                    (b test-label:))))
                (test-equal lines 3)
                (test-equal size (* 2 4))
                (test-equal test-label: 0)))))

|#
