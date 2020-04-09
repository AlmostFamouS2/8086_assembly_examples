.model small

org 100h

call_test_func MACRO x,y,z
    push z
    push y
    push x
    call test_func
    add sp,6
ENDM


.code

main proc near
            
    ;test_func(1,2,3)        
    call_test_func 1,2,3
    
    mov ax,02h
    
    ret
    
main endp

test_func proc near
    ;stack head is the address to jump back to
    ;mov stack head to bx
    mov bx,sp
    mov ax,[bx+2];1
    mov cx,[bx+4];2
    mov dx,[bx+6];3
    
    ret
test_func endp
end