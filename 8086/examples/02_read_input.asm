.model small

.data

.code

    mov ah, 1h; read a character (save in "al")
    int 21h; interrupt
    mov dl, al; move read character to dl
    mov ah,2h; code for write character (in dl)
    int 21h

end