.model small

org 100h

.data

.code

main proc

    ;je: Jump if equal
    mov ax, 100
    mov bx, 100

    cmp ax, bx

    je equal

    mov cx, 0x0e

    equal:

    mov cx, 0x0f

    ;jne; Jump not equal

    mov ax, 100
    mov bx, 101

    cmp ax, bx

    jne not_equal

    mov cx, 0x0e

    not_equal:

    mov cx, 0x0f

    ;jcxz: jumps if cx is zero (lol)

    mov cx, 1
    mov ax, 1

    sub cx, ax

    jcxz cx_zero

    mov cx, 0x0e

    cx_zero:

    mov cx, 0x0f

    ret

    ;ja: jump if above (d > s)
    ;jnbe: jump NOT below or equal (!(d <= s) which is equal ja)

    ;jae: jump if above or equal (d >= s)
    ;jnb: jump NOT below (!(d < s) which is equal jae)

    ;jb: jump below (d < s)
    ;jnae: jump NOT above or equal (!(d >= s) which is equal jb)

    ;jbe: jump below or equal (d <= s)
    ;jna: jump NOT above (!(d > s) which is equal jbe)

    ;tiny example

    mov ax, 1
    mov bx, 2

    cmp ax, bx
    ja ax_above

    cx 0x0e

    ax_above:

    cx 0x0f

endp

end main