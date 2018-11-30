#!r6rs

(import
  (r6rs base (6))
  (r6rs (6))
  (leg labels)
  (leg))

(define (assemble code)
  "assembles a mixed list of keywords, assembly directives,
   data definitions, and expressions (lists consisting of zero
   or more prefixes, an assembly mnemonic, and zero or more
   operands) and returns a record consisting of a vector of
   bytevectors, a hashtable of label-value pairs, the number of
   lines of code (where each directive, definition, label, and
   expression is considered one line), the total size of the 
   bytevector in bytes, a code listing with line numbers, 
   a list of warning reports, and a list of error reports.

   The assembler will attempt to complete the assembly in spite
   of errors, but instead proceed while returning an error report,
   but a few errors will probably be immediately fatal."

  (let ((intermediates (make-assembly-record))
        (if (null? code)
            intermediates-record

            ;; step one - apply identify-labels to each entry in
            ;; the code list. This is done by currying the
            ;; intermediates record to the identify-expr call,
            ;; returning the actual identifier function. This is
            ;; then applied to a generated list of expression numbers
            ;; and the expressions themselves.
            
            (for-each
             (identify-exprs intermediates)
             code
             ()
             ;; step two - 
             ((delabeled-code 
               (map resolve-labels evaluated-exprs)))
             )))))
