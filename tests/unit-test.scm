#!r6rs 
(import 
 (rnrs (6))
 (rnrs base (6))
 (rnrs io simple (6))
 (srfi :64)
 (leg components))

(define runner (test-runner-simple))

(test-with-runner runner 
  (test-group 
   "Tests of Leg pass one operations"
   (test-group 
    "Single label, no instructions"
    (let ((count (process-labels '(:test-label))))
      (test-equal count 0)
      (test-equal :test-label 0)))
   (test-group 
    "Single label, two instruction following"
    (let ((count (process-labels '(:test-label
                                   ((add imm) r0 r0 1)
                                   (b test-label)))))
      (test-equal count (* 4 3))
      (test-equal :test-label 0)))
   (test-group
    "Single label, two instruction following"
    (let ((count (process-labels '(:test-label
                                   ((add imm) r0 r0 1)
                                   (b :test-label)))))
      (test-equal count (* 4 3))
      (test-equal :test-label 0)))))
