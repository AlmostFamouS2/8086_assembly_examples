.model small

org 100h

.data

.code
main proc

infinite_loop:
mov dl, 5
mov ah, 2h
int 21h

jmp infinite_loop

endp

end main