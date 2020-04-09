.model small

org 100h

call_set_var MACRO x_byref
    push offset x_byref;pass variable address
    call set_var
    add sp,2
ENDM

.data
    myvar dw 10h

.code

main proc near

    mov ax,myvar
    
    call_set_var myvar

    mov ax,myvar

    ret

main endp

set_var proc near
    mov bp,sp;pointer o the stack
    mov di,[bp+2];di to value in stack+2 (offset x_byref)
    ;di now is a pointer to x_byref
    mov [di],02h;set value pointed by the pointer
    ret
set_var endp
end