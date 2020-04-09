.model small

org 100h

.data

.code

main proc

    ;and
    mov ah, 00001111b
    mov bh, 00001000b
    and ah, bh; expected (0x08)

    ;or
    mov ah, 00001111b
    mov bh, 00001000b
    or ah, bh; expected 00001111 (0x0F)

    ;xor
    mov ah, 00001111b
    mov bh, 00001000b
    xor ah, bh; expected 00000111 (0x07)

    ;not
    mov ah, 00001111b
    not ah; expected 11110000 (0xF0)

ret
endp

end main