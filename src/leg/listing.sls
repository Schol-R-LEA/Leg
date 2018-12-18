#!r6rs

(library (leg listing)
  (export
   assembly-listing-line make-assembly-listing-line assembly-listing-line?
   get-line-number get-line-size get-line-byte-values get-line-source-code

   &listing-invalid-line-number-error make-listing-invalid-line-number-error listing-invalid-line-number-error?
   &listing-invalid-opcode-error make-listing-invalid-opcode-error listing-invalid-opcode-error?
   &listing-invalid-size-error make-listing-invalid-size-error listing-invalid-size-error?
   )
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6))
          (leg labels))


  (define-condition-type &listing-invalid-line-number-error
    &syntax 
    make-listing-invalid-line-number-error listing-invalid-line-number-error?)
  
  (define-condition-type &listing-invalid-opcode-error
    &syntax 
    make-listing-invalid-opcode-error listing-invalid-opcode-error?)

  (define-condition-type &listing-invalid-size-error
    &syntax 
    make-listing-invalid-size-error listing-invalid-size-error?)  

  ;;; Simple type holding the listing of a single line of the
  ;;; program, with default predicate and accessors.
  ;;; The line-number must be a positive integer, while the
  ;;; opcode must be a bytevector or a null list.

  (define-record-type
      (assembly-listing-line make-assembly-listing-line assembly-listing-line?)
    (fields 
     (immutable line-number get-line-number)
     (immutable size get-line-size)     
     (immutable byte-values get-line-byte-values)
     (immutable source-code get-line-source-code))
    (protocol 
     (lambda (ctor)
       (lambda (line sz bytes src)
         (cond
          ((not (and (integer? line)
                     (or (= 0 line) (positive? line))))
           (raise-continuable 
            (make-listing-invalid-line-number-error
             (make-message-condition 
              "assembly-listing-line: invalid line number entry."))))
          ((not (or (bytevector? bytes) (null? bytes)))
           (raise-continuable 
            (make-listing-invalid-opcode-error
             (make-message-condition 
              "assembly-listing-line: invalid opcode entry."))))
          ((not (and (integer? sz)
                     (or (and (= 0 sz)
                              (null? bytes))
                         (and (< 0 sz)
                              (bytevector? bytes)))))
           (raise-continuable 
            (make-listing-invalid-opcode-error
             (make-message-condition 
              "assembly-listing-line: invalid size or size mismatch."))))          
          (else (ctor line sz bytes src))))))))

