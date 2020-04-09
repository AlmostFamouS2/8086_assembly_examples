.model small

org 100h

.data

.code

main proc

    ;multiplication
    ;8 bit: mul x. Multiply x with al, store result in ax
    ;16 bit: mul x. Multiply x with ax, store rsult in dx:ax

    mov al, 5h
    mov bl, 2h

    mul bl; expect ax = 000A

    mov ax, 0x8000
    mov bx, 2h

    mul bx; expect dx:ax = 0001:0000

    ;division
    ;8 bit: div x. Divide ax by x, result in al, remainder in ah
    ;16 bit: div x. Divide DX:AX by x, result in ax, remainder in dx

    mov ax, 8
    mov bl, 5

    div bl; expected al = 1, ah = 3

    mov dx, 0x0F
    mov ax, 1
    mov bx, 16

    div bx; expected ax = 0xF0, dx = 1

    ;adc: adds the value of the CF and stores in the destination operand. You can adc 0 to move the carry to the register you want (like in this case the result is DL:AL)

    mov dl, 0
    mov al, 0ffh
    add al, 0ffh
    adc dl, 0

    ;sbb: Add with CF and subtract the destionation operand

    mov ah, 7
    mov bh, 1
    sub bh, 2
    sbb ah, 0


ret
endp

end main