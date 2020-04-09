BLACK equ 0h
WHITE equ 0fh

CALL_DRAW_RECT MACRO x,y,sx,sy
    push sy
    push sx
    push y
    push x
    call draw_rect
    add sp,8
ENDM

stack segment para stack
    db 64 dup(' ')
stack ends

data segment para 'data'
    window_width dw 140h; 320 pixels
    window_height dw 0c8h; 200 pixels
    window_bounds dw 6h

    time_aux db 0

    ball_origin_x dw 0a0h
    ball_origin_y dw 64h

    ball_x dw 0Ah
    ball_y dw 0Ah
    ball_size dw 04h
    ball_vx dw 05h
    ball_vy dw 02h

    paddle_left_x dw 0ah
    paddle_left_y dw 0ah

    paddle_right_x dw 136h
    paddle_right_y dw 0ah

    paddle_width dw 08h
    paddle_height dw 15h

data ends

code segment para 'code'
    main proc far
    assume cs:code,ds:data,ss:stack
    push ds
    sub ax,ax
    push ax
    mov ax,data
    mov ds,ax
    pop ax
    pop ax

        ;init game logic
        call clear_screen
        call reset_ball

        check_time:
            ; get system time
            mov ah, 2ch
            int 21h; ch = hour, cl = minute, dh = second dl = 1/100 seconds

            cmp dl,time_aux
            je check_time

            mov time_aux,dl

        call clear_screen

        ;game logic
        call move_ball
        CALL_DRAW_RECT ball_x,ball_y,ball_size,ball_size
        CALL_DRAW_RECT paddle_left_x,paddle_left_y,paddle_width,paddle_height
        CALL_DRAW_RECT paddle_right_x,paddle_right_y,paddle_width,paddle_height
        ;end game logic

        jmp check_time

        ret
    main endp

    ;====== draw_rect(x,y,size_x,size_y) draws a rectangle with a size (size_x,size_yy) and position (x,y)
    ;CALL_DRAW_RECT macro to safely call this function
    draw_rect proc near
        mov bp, sp
        mov cx, [bp+2]
        mov dx, [bp+4]

        draw_rect_horizontal:
            ;draw a pixel
            mov ah, 0ch;configuration to write pixel
            mov al, WHITE
            mov bh, 00h;page number
            int 10h

            ;inc cx, loop back if cx - [bp+2] <= ball_size
            inc cx
            mov ax,cx
            sub ax,[bp+2]
            cmp ax,[bp+6]
            jng draw_rect_horizontal

            ;jump a line and car another line
            mov cx, [bp+2]
            inc dx
            mov ax,dx
            sub ax,[bp+4]
            cmp ax,[bp+8]
            jng draw_rect_horizontal

        ret
    draw_rect endp

    clear_screen proc near
        ;set video mode
        mov ah, 00h
        mov al, 13h
        int 10h

        ;set background color
        mov ah, 0bh
        mov bh, 00h
        mov bl, BLACK
        int 10h

        ret
    clear_screen endp

    move_ball proc near
        ;move ball horizontally
        mov ax,ball_vx
        add ball_x,ax

        ;horizontal collision check
        mov ax,window_bounds
        cmp ball_x,ax
        jl label_reset_ball

        mov ax,window_width
        sub ax,ball_size
        sub ax, window_bounds
        cmp ball_x, ax
        jg label_reset_ball

        ;mov ball vertically
        mov ax,ball_vy
        add ball_y,ax

        ;vertical collision check
        mov ax, window_bounds
        cmp ball_y, ax
        jl neg_velocity_y

        mov ax, window_height
        sub ax, ball_size
        sub ax, window_bounds
        cmp ball_y, ax
        jg neg_velocity_y

        ret

        label_reset_ball:
        call reset_ball
        ret

        neg_velocity_y:
        neg ball_vy
        ret

    move_ball endp

    reset_ball proc near
        mov ax, ball_origin_x
        mov ball_x, ax
        mov ax, ball_origin_y
        mov ball_y, ax
        ret
    reset_ball endp

code ends

end