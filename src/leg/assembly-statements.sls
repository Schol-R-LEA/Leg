#!r6rs


(library (leg assembly-statements)
  (export
   assembly-listing-line
   assembly-result-record
   identify-expr resolve-expr)
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6))
          (leg labels))


  (define-condition-type &listing-line-error
    &syntax 
    make-listing-line-error listing-line-error?)

  (define-condition-type &listing-opcode-error
    &syntax 
    make-listing-opcode-error listing-opcode-error?)


  (define-record-type assembly-listing-line
    "Simple type holding the listing of a single line of the
     program, with default predicate and accessors.
     The line-number must be a positive integer, while the
     opcode must be a bytevector."
    (fields 
     (line-number opcode source))
    (protocol 
     (lambda (ctor)
       (lambda (line op src)
         (cond 
          ((not (and (integer? line)
                     (positive? line)))
           (raise-continuable 
            (make-listing-line-error
             (make-message-condition 
              "assembly-listing-line: invalid line number entry."))))
          ((not (bytevector? op))  
           (raise-continuable 
            (make-listing-opcode-error
             (make-message-condition 
              "assembly-listing-line: invalid opcode entry."))))
          (else (ctor line opcode source)))))))
  

  (define-record-type assembly-result-record
    (fields
     ((immutable source-code)
      (mutable opcodes)     ;; the final output
      (mutable listing)     ;; annotated, displayble output
      (mutable remaining-code)
      (mutable lines)
      (mutable expr-count)
      (mutable size)
      (mutable labels)
      (mutable constants)
      (mutable data-definitions)
      (mutable operational-directives)
      (mutable warnings)
      (mutable errors))
     (protocol
      (lambda (ctor)
        (lambda (code)
          (ctor code '() '() code 0 0 0 '() '() '() '() '() '()))))))
  
  (define identify-expr
    "Takes a sexpr-encoded assembly language expression and 
     for each type of element returns 
     a list containing 
        expression type, 
        the computed code position, and
        - label: the label;  
        - data definition: a vector of bytevectors;
        - data declaration: an integer size;
        - equate: a pair with the name and value of the constant;
        - non-data directive: the directive type and operand
        - instruction: if it contains one or more labels, 
                         a list of the partial opcode and the operands,
                       else,
                         the assembled mnemonic."
    (case-lambda
      (() '())
      ((label) 
       (cond 
        ((label-formatted-symbol? label) )
        ))))


  (define (resolve-expr expr)
    (())))





