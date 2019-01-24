#!r6rs

(library (leg labels)
  (export 
   label-formatted-symbol? string->label label->symbol
   label-record make-label-record label-record?
   get-label get-label-address set-label-address
   &invalid-label-error make-invalid-label-error invalid-label-error?
   &invalid-label-address-error make-invalid-label-address-error invalid-label-address-error?   
   )
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6)))


  (define-condition-type &invalid-label-error
    &syntax 
    make-invalid-label-error invalid-label-error?)


  (define-condition-type &invalid-label-address-error
    &syntax 
    make-invalid-label-address-error invalid-label-address-error?)
  

  (define (string->label label-representation)
    (string->symbol (string-append label-representation ":")))


   (define (label-formatted-symbol? label)
    (if (not (symbol? label))
        #f
        (let ((candidate (symbol->string label)))
          (char=?
           #\:
           (string-ref candidate 
                       (- (string-length candidate) 1))))))


  (define (label->symbol label)
    (if (label-formatted-symbol? label)
        (let* ((label-representation (symbol->string label))
               (sym-end (- (string-length label-representation) 1)))
          (string->symbol (substring label-representation 0 sym-end)))
        #f))

  (define-record-type (label-record make-label-record label-record?)
    (fields (immutable label get-label)
            (mutable address get-label-address set-label-address))
   (protocol
    (lambda (ctor)
      (lambda (lbl . addr)
        (ctor (if (label-formatted-symbol? lbl)
                  (label->symbol lbl)
                  (raise-continuable 
                   (make-invalid-label-error
                    (make-message-condition 
                     "label-record: invalid label."))))
              (if (and (not (null? addr))
                       (list? addr))
                  (if (number? (car addr))
                      (car addr)
                      (make-invalid-label-address-error
                       (make-message-condition 
                        "label-record-address: invalid label address.")))
                  #f)))))))
