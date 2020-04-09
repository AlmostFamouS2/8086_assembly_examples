.model small

org 100h

.data

.code

main proc
    mov ah, 0
    mov al, '8'
    add al, '2'
    aaa; prepares ax, so when "or'ed" agains 30h (for every 2 bytes) it yields it's ascii values
    or ax, 3030h
endp

end main