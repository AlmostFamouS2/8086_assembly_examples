;book: assembly language for 8086 processors
;09h display string
;4ch terminate process

.model tiny; Code Data & Stack in on 64k segment

.code ; code segment
org 100h; offset 255

main proc near

mov ah,09h; function to display string
mov dx,offset message; offset of mesage
int 21h; DOS interrupt

mov ah,4ch; function to terminate
mov al,00
int 21h; Dos interrupt

endp
message db "Hello World $"

end main

