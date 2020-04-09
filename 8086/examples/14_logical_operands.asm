.model small

org 100h

.data

.code

main proc

    ;test: bitwise AND, but doesn't set value
    mov ah, 1h
    test ah, 1h; ZF (zero flag) is 1 if the result of the last operation was 0, so in this case it will be zero
    test ah, 0h; ZF = 1

    ;cmp: destination - source = Set ZF and CF
    ;destination < source ZF 0 CF 1
    ;destination > source ZF 0 CF 0
    ;destination = source ZF 1 CF 0
    mov ah, 1h
    mov bh, 2h
    mov ch, 1h

    cmp ah, bh
    cmp bh, ah
    cmp ah, ch

    ;conditional jump
    ;jc Jump if CF -- jnc Jump it NOT CF
    ;jz Jump if ZF -- jnz Jump if NOT ZF

    ;Ex 1 if ax == bx
    mov ax, 5
    mov bx, 5

    cmp ax, bx
    jz isEqual; ZF is 1 if ax == bx

    mov cx, 0x0E
    isEqual:
    mov cx, 0x0F

    ;Ex 2 if ax < bx
    mov ax, 4
    mov bx, 5

    cmp ax, bx
    jc ax_less_bx

    mov cx, 0x0e

    ax_less_bx:
    mov cx, 0x0f

    ;Ex 3 if ax > bx
    mov ax, 5
    mov bx, 4

    cmp bx, ax; just invert the order
    jc bx_less_ax

    mov cx, 0x0e

    bx_less_ax:
    mov cx, 0x0f

    ;Ex 4 if ax >= bx
    mov ax, 5
    mov bx, 4

    cmp ax, bx

    jnc ax_more_or_equal_bx
    mov cx, 0x0e

    ax_more_or_equal_bx:
    mov cx, 0x0f

    ;Ex 5 if ax <= bx
    mov ax, 4
    mov bx, 5

    cmp bx, ax; just invert

    jnc ax_less_or_equal

    mov cx, 0x0e

    ax_less_or_equal:

    mov cx, 0x0f

    ;Ex 6 if ax != bx
    mov ax, 5
    mov bx, 6

    cmp ax, bx

    jnz ax_diff_bx

    mov cx, 0x0e

    ax_diff_bx:
    mov cx, 0x0f

endp

end main
