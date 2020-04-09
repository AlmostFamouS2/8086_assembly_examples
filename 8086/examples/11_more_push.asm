.model asm

org 100h

.data

.code
main proc
    mov ax, 1
    mov bx, 1
    mov cx, 1

    ;Push AX, CX, DX, BX, original SP, BP, SI, and DI
    pusha

    mov ax, 5
    mov bx, 5
    mov cx, 5

    popa

endp
end main