(library (leg components)
  (export process-labels)

  (import (rnrs base)
          (rnrs io simple))

  (define process-labels
    (lambda (src)
      (let process ((code src)
                    (position 0)
                    (processed-code '()))
        (if (null? code) position
            (let ((expression (car code))
                  (next (cdr code))
                  (next-pos (+ 1 position)))
              ))))))
