.model small

org 100h
.data
.code

main proc

mov dl, 5
neg dl
add dl, 5
add dl, 48;asc offset
mov ah,2h;print a haracter
int 21h

endp

end main