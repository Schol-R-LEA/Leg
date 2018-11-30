#!r6rs

(library (leg labels)
  (export 
   label-formatted-symbol? string->label label->symbol)
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6)))


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
        #f)))
