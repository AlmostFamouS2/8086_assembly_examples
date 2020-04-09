.model small

org 100h

.data
    message db "Enter a number: $ "
    message2 db " Enter another number $ "
    message3 db " + $"
    message4 db " = $"
    asc_offset db 30h
.code
    main proc

    ;print message
    mov ax, seg message
    mov ds, ax
    mov dx, offset message
    mov ah, 9h;print string
    int 21h

    mov ah, 1h; read character (store in al)
    int 21h

    mov bl, al

    ;print message2
    mov ax, seg message2
    mov ds, ax
    mov dx, offset message2
    mov ah, 9h;print string
    int 21h

    mov ah, 1h; read character (store in al)
    int 21h

    mov cl, al

    ;print character
    mov dl, bl
    mov ah, 2h
    int 21h

    ;print message3
    mov ax, seg message3
    mov ds, ax
    mov dx, offset message3
    mov ah, 9h;print string
    int 21h

    ;print character
    mov dl, cl
    mov ah, 2h
    int 21h

    ;print message4
    mov ax, seg message4
    mov ds, ax
    mov dx, offset message4
    mov ah, 9h;print string
    int 21h

    ;do the math (can be simplified)
    sub bl, asc_offset
    sub cl, asc_offset

    add bl, cl
    add bl, asc_offset

    ;print character
    mov dl, bl
    mov ah, 2h
    int 21h

    ret
    endp

end main