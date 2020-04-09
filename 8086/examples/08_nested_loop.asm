.model small

org 100h

.data

.code
main proc

mov cx, 5;loop counter
mov bx, 5

jmp start_loop

l1:
dec bx
mov dl, 1
add dl, 48
mov ah,2h;print
int 21h

l2:
mov dl, 5
add dl,48
mov ah,2h
int 21h

start_loop:
loop l2

mov cx, bx

loop l1

endp

end main