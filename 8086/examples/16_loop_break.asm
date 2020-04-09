.model small

org 100h

.data

.code

main proc

    ;loopz: uses CX (16 bit) or EX (32 bit) as a counter, but breaks if ZF is ZERO

    mov cx, 5
    mov bx, 2;loop end

    my_loop:
    mov dl, cl
    add dl, 30h

    mov ah,2h;print function
    int 21h
    
    cmp bx, cx

    loopnz my_loop

    ret
endp

end main

