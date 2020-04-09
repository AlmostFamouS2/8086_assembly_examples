.model small

org 100h

.data

.code
main proc

mov cx, 5;loop counter

top:
mov dl, 5
add dl, 48
mov ah,2h;print
int 21h

loop top

endp

end main