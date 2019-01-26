#!r6rs

(library (leg bitfield-packing)
  (export
   bitfield-pack
   bitfield-packing-field?
   get-packable-value get-packing-high-bit get-packing-low-bit
   )
  
  (import (rnrs base (6))
          ;; composite standard library, imports most std libs
          (rnrs (6)))

  
  (define (bitfield-packing-field? field)
    "A bitwise-packing-field is an implicit data record
     for the values, high bit position, and low bit position
     of a bitfield to be either combined with or masked against
     an existing bitwise value. The record consists of an improper
     list with a data value, a high bit, and a low bit, e.g.,
         (value high-bit . low-bit)
     They usually are given in a list of two or more."
    (and
     (pair? field)
     (integer? (car field))
     (pair? (cdr field))
     (integer? (cadr field))
     (integer? (cddr field))
     (> (cadr field) 0)
     (> (cadr field) (cddr field))))


  (define (get-packable-value field)
    "Extract the 'value' field of a bitwise-packing-field."
    (if (bitwise-packing-field? field)
        (car field)))
  
  (define (get-packing-high-bit field)
    "Extract the 'high-bit' field of a bitwise-packing-field."    
    (if (bitwise-packing-field? field)
        (cadr field)))

  (define (get-packing-low-bit field)
    "Extract the 'low-bit' field of a bitwise-packing-field."    
    (if (bitwise-packing-field? field)
        (cddr field)))
  
  (define (bitfield-pack mask operation max-bit-position . fields)
    "pack a series of integer field values into a single bitstring of size max-size.
     Takes a bit mask starting value, a maximum field size, a 'packing manifest'
     consisting of a pair with a value and a pair consisting of a high and low bit number
     for where to insert the value, and an optional list of additional 'manifests'.
     example uses:
         (bitwise-pack 0 'combine 8 '((#xA 7 . 4)) (#x5 3 . 0))))  ==> #xA5

     Primarily meant to be used for preparing fields in a bytevector."
    
    ;; first, test the input both to verify the input and
    ;; guard the recursion.
    (if (and (integer? mask)
             (integer? max-bit-position)
             (> max-bit-position 0)
             (memq operation '(combine mask toggle))
             (not (null? fields))
             (list? fields)
             (not (null? (car fields)))
             (bitfield-packing-field? (caar fields))
             (> max-bit-position (get-packing-high-bit (caar fields))))
        ;; if the data is valid, OR the data value of the next bit field entry
        ;; against the current mask value.
        (let* ((field (caar fields))
               (func (case operation
                       ('combine bitwise-ior)
                       ('mask  bitwise-and)
                       ('toggle  bitwise-xor)))
               (result
                (bitwise-ior
                 mask
                 (bitwise-arithmetic-shift-left
                  (get-packable-value field)
                  (get-packing-low-bit field)))))
          ;; if their are more field records remaining, recurse using the
          ;; result as the new mask and the low bit of the current field
          ;; as the high bit position.
          (bitfield-pack result
                        operation
                        (get-packing-high-bit field)
                        (cdar fields)))
        mask))
