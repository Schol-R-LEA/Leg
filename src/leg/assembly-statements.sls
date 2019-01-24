#!r6rs


(library (leg assembly-statements)
  (export
   assembly-listing-line make-assembly-listing-line assembly-listing-line?
   get-line-number get-byte-values get-line-source-code
   
   assembly-result-record make-assembly-result-record assembly-result-record?
   identify-expr resolve-expr)
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6))
          (leg labels))

  
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





