.model small
     
org 100h        
.data
    ascdelta db 30h
.code

main proc

mov dl, 2
add dl, ascdelta
mov ah, 2h; code for printing char
int 21h

endp

end main