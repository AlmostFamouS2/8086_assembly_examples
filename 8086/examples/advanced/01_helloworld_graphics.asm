name "hi-world"

; writes "Hello World to video memory"
; vga memory: first byte is ASCII, second bite is character attribute
; Character attribute (8): high 4 bits for background color, low 4 bits foreground color
; hex    bin        color
;
; 0      0000      black
; 1      0001      blue
; 2      0010      green
; 3      0011      cyan
; 4      0100      red
; 5      0101      magenta
; 6      0110      brown
; 7      0111      light gray
; 8      1000      dark gray
; 9      1001      light blue
; a      1010      light green
; b      1011      light cyan
; c      1100      light red
; d      1101      light magenta
; e      1110      yellow
; f      1111      white

BLACK           equ 0h
BLUE            equ 1h
GREEN           equ 2h
CYAN            equ 3h
RED             equ 4h
MAGENTA         equ 5h
BROWN           equ 6h
LIGHT_GRAY      equ 7h
DARK_GRAY       equ 8h
LIGHT_BLUE      equ 9h
LIGHT_GREEN     equ 0ah
LIGHT_CYAN      equ 0bh
LIGHT_RED       equ 0ch
LIGHT_MAGENTA   equ 0dh
YELLOW          equ 0eh
WHITE           equ 0fh

org 100h

.code

main proc

    ; set video mode
    mov ax,3; text mode 80x25, 16 colors, 8 pages)
    int 10h; do it

    ;cancel blinking and enable all 16 colors
    mov ax, 1003h
    mov bx, 0
    int 10h

    ; set segment registers
    mov ax, 0b800h;this is the video memory segment
    mov ds, ax

    ; print hello world. Is this writting to video memory?
    mov [02h], 'H'
    mov [04h], 'e'
    mov [06h], 'l'
    mov [08h], 'l'
    mov [0ah], 'o'
    mov [0ch], ' '
    mov [0eh], 'W'
    mov [10h], 'o'
    mov [12h], 'r'
    mov [14h], 'l'
    mov [16h], 'd'
    mov [18h], '!'

    ;color the background
    mov cx, 12; number of characters
    mov di, 03h; start from byte after 'h'

    c:  mov [di], LIGHT_MAGENTA
        shl [di], 4
        add [di], YELLOW
        add di, 2
        loop c

    ; wait for any key presses
    mov ah, 0
    int 16h

    ret

endp

end main



