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
