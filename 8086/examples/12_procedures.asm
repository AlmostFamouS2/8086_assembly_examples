;the program will still keep going from the main if you don't call ret
.model small

org 100h

.data

.code
    main proc
    mov ax,1
    call blue
    mov bx,1
    ret
    endp

    blue proc
    mov ax, 4
    mov bx, 4
    ret
    blue endp

end main