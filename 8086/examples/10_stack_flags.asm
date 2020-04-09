.model asm
   
org 100h

.data
    saveflags dw ?
.code
main proc
    pushf;push flags to top of stack
    pop saveflags;pop stack to this variable
    mov dx,saveflags;check the debugger
    
    mov saveflags, 0xffff
    push saveflags
    popf;set flags states to value in top of stack
endp
end main

