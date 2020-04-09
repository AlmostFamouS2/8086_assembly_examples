BLACK equ 0h
WHITE equ 0fh

stack segment para stack
    DB 64 DUP (' ')
stack ends

data segment para 'data'

data ends

code segment para 'code'

    main proc far

        ;set video mode
        mov ah, 00h
        mov al, 13h
        int 10h

        ;set background color
        mov ah, 0bh
        mov bh, 00h
        mov bl, BLACK
        int 10h

        ;
        mov ah, 0ch;configuration to write pixel
        mov al, WHITE
        mov bh, 00h
        mov cx, 0ah;x position
        mov dx, 0ah;y position
        int 10h

        ret
    main endp
code ends
end