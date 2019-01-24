#!r6rs

(library (leg assembly-record)
  (export
   assembly-listing-line make-assembly-listing-line assembly-listing-line?
   get-line-number get-byte-values get-line-source-code)
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6))
          (leg labels))

  
  (define-record-type (assembly-result-record
                       make-assembly-result-record
                       assembly-result-record?)
    (fields
     ((immutable source-code)
      (mutable opcodes)     ;; the final output
      (mutable listing)     ;; annotated, displayable output
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
          (ctor code '() '() code 0 0 0 '() '() '() '() '() '())))))))
  
