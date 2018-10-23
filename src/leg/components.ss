#!r6rs

|#
Leg assembly format:
      - expression: (<mnemonic> <operand-0> ... <operand-n>)  
      - label: <label>:
      - directives:
       - (def-[byte/half/word/dword/qword/str/zstr] <value-0>...<value-n>)
       - (res-[byte/word/quad/octo/hex/256/512/1024/4096/str/zstr] <size>)
       - (is <equate-label> <constant>)
       - (bits [8/16/32/64/128])
       - (align [1/2/4/8/16/32/64/128/256/512])
       - (require <expression>)

During assembly, a mnemonic is in fact a Scheme symbol; each mnemonic
is in fact a Scheme function local to the assembler's internal
environment, which accepts the operands and returns either an assembled
opcode, or a function which can later be applied to the list of labels
and equates. 

(add r0 r1 r2) => ('opcode <location> 0x020081E0)


Immediates, and equates and labels which have already been processed,
are automagically recognized and inserted directly, allowing the 
instruction to be assembled completely:

    (is foo 17)
    (add r3 r4 foo)
                   => 
                    ('equate <location> (foo . 42))
                    ('opcode <location> #x2a3084e2)

or
    bar:              ; assuming a location of 0x00000000
    (res-word 1)
    (la r0 bar)       ; equivalent to "ldr ro, =bar" in std ARM asm
    (ldr r1 (at ro)) 

     => ('label (bar . #x17000000))
        #xF800A0E3
        #x001090E5
 
For labels that have not been resolved yet, the result becomes




In the case of a compound mnemonic (the such as the 'B <comparison>'
instructions for ARM, or prefixed x86 instructions), the prefix is
represented by a HOF that returns a function to be applied to the
operands. For example, 

((add le flags) r3 r8 (imm 42))  => (addles r3 r8 (imm 42)) =>  


For A32 implicit shifts, apply the HOF (shift (<instruction>) <amount>). 
Naturally, if the (bits 64) directive is in use, this should not be
applied, but instead should reoprt an error.

A label is represented by a Common-Lisp style keyword (in Scheme,
these are defined in SRFI 88). When referenced in an expression, the
colon (':') is ommitted. 
#|


(library (leg components)
  (export make-assembly-encoding)
  
  (import (rnrs base (6))
          (rnrs exceptions (6))
          (srfi :41 streams)
          (srfi :88))  ; keywords
  
  (define (keyword->symbol kw)
    (string->symbol (keyword->string kw)))
  

  (define (identify-labels expr)
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
                         the assembled mnenomic."




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

    (if (null? code)
        (make-assembly-record )

        ; step one - apply gather labels to each entry in the code list
        (let* ((labels (for-each identify-labels code))
                                        ; step two - 
               ((labelless-code 
                 (for-each resolve-labels opcode-resolutions labels)))
               ())))
