; Generally you cannot access these registers directly.

; Carry Flag (CF) - this flag is set to 1 when there is an unsigned overflow. For example when you add bytes 255 + 1 (result is not in range 0...255). When there is no overflow this flag is set to 0.
; Parity Flag (PF) - this flag is set to 1 when there is even number of one bits in result, and to 0 when there is odd number of one bits.
; Auxiliary Flag (AF) - set to 1 when there is an unsigned overflow for low nibble (4 bits).
; Zero Flag (ZF) - set to 1 when result is zero. For non-zero result this flag is set to 0.
; Sign Flag (SF) - set to 1 when result is negative. When result is positive it is set to 0. (This flag takes the value of the most significant bit.)
; Trap Flag (TF) - Used for on-chip debugging.
; Interrupt enable Flag (IF) - when this flag is set to 1 CPU reacts to interrupts from external devices.
; Direction Flag (DF) - this flag is used by some instructions to process data chains, when this flag is set to 0 - the processing is done forward, when this flag is set to 1 the processing is done backward.
; Overflow Flag (OF) - set to 1 when there is a signed overflow. For example, when you add bytes 100 + 50 (result is not in range -128...127).

.model small

org 100h
.data
    ascd db 48
.code
main proc

mov cl,8
add cl,8

mov dl,cl
add dl,ascd
mov ah,2h
int 21h

endp

end main