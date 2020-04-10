;========= CONSTANTS ========;
BLACK equ 0h
WHITE equ 0fh
;========= END CONSTANTS ========;

;========= MACROS ========;
CALL_DRAW_RECT MACRO x,y,extent_x,extent_y
    push extent_y
    push extent_x
    push y
    push x
    call draw_rect
    add sp,8
ENDM

CALL_MOVE_PADDLE MACRO paddle_y_ref,paddle_vy_ref
    mov ax, offset paddle_vy_ref
    push ax
    mov ax, offset paddle_y_ref
    push ax
    call move_paddle
    add sp,4
ENDM
;========= MACROS ========;

stack segment para stack
    db 64 dup(' ')
stack ends

;========= DATA ========;
data segment para 'data'
    window_width dw 140h; 320 pixels
    window_height dw 0c8h; 200 pixels
    window_bounds dw 6h

    time_aux db 0

    ball_origin_x dw 0a0h
    ball_origin_y dw 64h

    ball_x dw 0Ah
    ball_y dw 0Ah
    ball_extent dw 02h
    ball_vx dw 05h
    ball_vy dw 02h

    paddle_left_x dw 0ah
    paddle_left_y dw 0fh

    paddle_left_vy dw 05h
    paddle_right_vy dw 05h

    paddle_right_x dw 136h
    paddle_right_y dw 0fh

    paddle_extent_x dw 04h
    paddle_extent_y dw 0ah

data ends
;========= END DATA ========;

code segment para 'code'
    main proc far
    assume cs:code,ds:data,ss:stack
    mov ax,data
    mov ds,ax

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
        CALL_MOVE_PADDLE paddle_left_y, paddle_left_vy
        CALL_MOVE_PADDLE paddle_right_y, paddle_right_vy
        ;end game logic

        ;draw
        CALL_DRAW_RECT ball_x,ball_y,ball_extent,ball_extent
        CALL_DRAW_RECT paddle_left_x,paddle_left_y,paddle_extent_x,paddle_extent_y
        CALL_DRAW_RECT paddle_right_x,paddle_right_y,paddle_extent_x,paddle_extent_y
        ;end draw

        jmp check_time

        ret
    main endp

;========= BALL CODE ========;
    move_ball proc near
        ;move ball horizontally
        mov ax,ball_vx
        add ball_x,ax

        ;horizontal collision check
        mov ax,window_bounds
        cmp ball_x,ax
        jl label_reset_ball

        mov ax,window_width
        sub ax,ball_extent
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
        sub ax, ball_extent
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
;========= END BALL CODE ========;

;========= PADDLE CODE ========;

    move_paddle proc near
        mov bp, sp
        mov di,[bp+2];paddle_y*
        mov si,[bp+4];paddle_vy*
        mov ax, [di]
        add ax, [si]

        ;check bounds down
        ; y + height/2 + bounds >= window_height?
        mov bx, ax
        add bx, paddle_extent_y
        add bx, window_bounds
        cmp bx, window_height
        jge hit_bounds_down

        ;check bounds up
        ; y - height/2 - bounds < 0?
        mov bx, ax
        sub bx, paddle_extent_y
        sub bx, window_bounds
        cmp bx, 00h
        jl hit_bounds_up

        jmp commit_move_paddle

        hit_bounds_down:
        ; y = window_height - size/2 - window_bounds
        mov ax, window_height
        sub ax, window_bounds
        sub ax, paddle_extent_y

        ;temp
        mov bx, [si]
        neg bx
        mov [si], bx
        jmp commit_move_paddle

        hit_bounds_up:
        ; y = 0 + size/2 + window bounds
        mov ax, 0
        add ax, window_bounds
        add ax, paddle_extent_y

        ;temp
        mov bx, [si]
        neg bx
        mov [si], bx
        jmp commit_move_paddle

        commit_move_paddle:
        mov [di], ax
        ret

    move_paddle endp
;========= END PADDLE CODE ========;


;========= COLLISION CODE ========;
    ;==== check_rectancle_collision between two rectangles A and B, returns x,y delta overlap between A and B
    ;receives (x_a, y_a, extent_x_a, extent_y_a, x_b, y_b, extent_x_b, extent_x_b)
    ;use CALL_CHECK_RECTANGLE_COLLISION for safe calling this function
    check_rectancle_collision proc near
        mov bp,sp
        ;if x_a + width_a
        ret
    check_rectancle_collision endp

;========= END COLLISION CODE ========;

;========= GRAPHICS ========;
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

    ;====== draw_rect(x,y,extent_x,extent_y) draws a rectangle with a size (extent_x,extent_yy) and position (x,y)
    ;CALL_DRAW_RECT macro to safely call this function
    draw_rect proc near
        mov bp, sp

        mov ax,[bp+6];extent_x
        sub [bp+2],ax;x - extent_x

        mov ax,[bp+8];extent_y
        sub [bp+4],ax;y-extent_y

        mov cx, [bp+2];x
        mov dx, [bp+4];y

        draw_rect_horizontal:
            ;draw a pixel
            mov ah, 0ch;configuration to write pixel
            mov al, WHITE
            mov bh, 00h;page number
            int 10h

            ;inc cx, loop back if cx - x <= extent_x
            inc cx
            mov ax,cx
            sub ax,[bp+2];x
            mov bx,[bp+6];extent_x
            shl bx, 1
            cmp ax,bx;extent_x*2
            jng draw_rect_horizontal

            ;jump a line and car another line
            mov cx, [bp+2];x
            inc dx
            mov ax,dx
            sub ax,[bp+4];y
            mov bx,[bp+8];extent_y
            shl bx,1
            cmp ax,bx;extent_y*2
            jng draw_rect_horizontal

        ret
    draw_rect endp
;========= END GRAPHICS ========;
code ends

end