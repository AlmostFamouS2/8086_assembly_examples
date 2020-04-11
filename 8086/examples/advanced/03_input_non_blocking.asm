.model small

.code

main proc near 
    read_char:
    ;read character to al without removing it from the keyboard buffer
    ;ZF 1 if there is a character in the buffer
    mov ah, 01h
    int 16h
    jz read_char
    
    ;print character
    mov dl, al; move read character to dl
    mov ah,2h; code for write character (in dl)
    int 21h
    
    ;clean the input buffer
    mov ah, 00h
    int 16h
    
    jmp read_char
    ret
main endp