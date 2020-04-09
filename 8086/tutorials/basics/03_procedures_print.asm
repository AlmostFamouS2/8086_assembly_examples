lea si, msg
call print
ret

; =============================================
; prints a null terminated string
; string should be in the SI register
print PROC       
    next_char:
    cmp [si], 0
    je stop; stop print if ZF is 0

    mov al, [si];move the value si is pointing al

    mov ah, 0eh
    int 10h

    add si, 1

    jmp next_char

    stop:
    ret
print endp
; =============================================

msg db "Hello World!",0

end