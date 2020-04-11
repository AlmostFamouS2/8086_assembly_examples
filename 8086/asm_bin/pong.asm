;========= CONSTANTS ========;
BLACK equ 0h
WHITE equ 0fh
MASK_INPUT_UP equ 80h
MASK_INPUT_DOWN equ 40h
P1_UP_KEY equ 'w'
P1_DOWN_KEY equ 's'
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

CALL_CHECK_OVERLAP_AXIS MACRO a, extent_a, b, extent_b
    push extent_b
    push b
    push extent_a
    push a
    call check_overlap_axis
    add sp, 8
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

    paddle_left_vy dw 0h
    paddle_right_vy dw 05h

    paddle_vy_max dw 05h

    paddle_right_x dw 136h
    paddle_right_y dw 0fh

    paddle_extent_x dw 04h
    paddle_extent_y dw 0ch

    overlap_skin_width dw 2h

    ; up, down
    input_p1 db 0h
    input_p2 db 0h

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
        ;process input
        call read_input
        call process_input

        call ai_control_paddle

        CALL_MOVE_PADDLE paddle_left_y, paddle_left_vy
        CALL_MOVE_PADDLE paddle_right_y, paddle_right_vy

        call move_ball
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

        ;mov ball vertically
        mov ax,ball_vy
        add ball_y,ax

        call check_ball_paddle_collision
        call check_ball_window_bounds_collision

        ret
    move_ball endp

    check_ball_window_bounds_collision proc near
        ;left bounds collision
        mov ax,window_bounds
        add ax, ball_extent
        cmp ball_x,ax
        jle bounds_label_reset_ball

        ;right bounds collision
        mov ax,window_width
        sub ax,ball_extent
        sub ax, window_bounds
        cmp ball_x, ax
        jge bounds_label_reset_ball

        ;up bounds collision check
        mov ax, window_bounds
        add ax, ball_extent
        cmp ball_y, ax
        jle bounds_neg_velocity_y

        ;down bounds collision check
        mov ax, window_height
        sub ax, ball_extent
        sub ax, window_bounds
        cmp ball_y, ax
        jge bounds_neg_velocity_y

        ret

        bounds_label_reset_ball:
        ; neg ball_vx
        call reset_ball
        ret

        bounds_neg_velocity_y:
        neg ball_vy
        ret
    check_ball_window_bounds_collision endp

    check_ball_paddle_collision proc near
        ;left_paddle collision check
        CALL_CHECK_OVERLAP_AXIS ball_x, ball_extent, paddle_left_x, paddle_extent_x
        push ax
        CALL_CHECK_OVERLAP_AXIS ball_y, ball_extent, paddle_left_y, paddle_extent_y
        pop bx
        and ax, bx
        cmp ax, 0
        jg adjust_x_and_neg_vx

        ;right_paddle collision check
        CALL_CHECK_OVERLAP_AXIS ball_x, ball_extent, paddle_right_x, paddle_extent_x
        push ax
        CALL_CHECK_OVERLAP_AXIS ball_y, ball_extent, paddle_right_y, paddle_extent_y
        pop bx
        and ax, bx
        cmp ax, 0
        jg adjust_x_and_neg_vx

        ret

        adjust_x_and_neg_vx:
        mov ax, ball_vx
        neg ball_vx
        test ax, ax
        jns adjust_pos_negative

        add ball_x, bx
        ret

        adjust_pos_negative:
        sub ball_x, bx
        ret
    check_ball_paddle_collision endp

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

        ;paddle_y + paddle_vy
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
        jmp .block_paddle

        hit_bounds_up:
        ; y = 0 + size/2 + window bounds
        mov ax, 0
        add ax, window_bounds
        add ax, paddle_extent_y
        jmp .block_paddle

        .block_paddle:
        mov bx, 0h
        mov [si], bx
        jmp commit_move_paddle

        commit_move_paddle:
        mov [di], ax
        ret

    move_paddle endp
;========= END PADDLE CODE ========;


;========= COLLISION CODE ========;
    ;==== check_overlap between two rectangles A and B in one axis (x or y)
    ; params: (x, extent_x, y, extent_y)
    ; ax = abs(delta) if there is an overlap, 0 otherside
    ;use CALL_CHECK_OVERLAP_AXIS for safe calling this function
    check_overlap_axis proc near
        mov bp,sp

        ;abs(a-b)
        mov ax, [bp+2];a
        sub ax, [bp+6];b
        jns do_check_overlap
        ;result was negative, negate a
        neg ax

        do_check_overlap:
        ;extent_a + extent_b
        mov bx, [bp+4]
        add bx, [bp+8]
        add bx, overlap_skin_width;some extra width to the collision

        ;check intersect: abs(a-b) < extent_a + extent_b
        sub ax, bx
        js handle_intersecting

        mov ax, 0
        ret

        handle_intersecting:
        neg ax
        ret
    check_overlap_axis endp

;========= END COLLISION CODE ========;


;========= INPUT ========;

    read_input proc near
        mov input_p1, 0h
        .read_input_non_block:
        mov ah, 01h
        int 16h
        jnz .maybe_move_to_input_buffer

        ret

        .maybe_move_to_input_buffer:
        mov ah, 00h
        int 16h
        cmp al, P1_UP_KEY
        je up_pressed

        cmp al, P1_DOWN_KEY
        je down_pressed

        jmp .read_input_non_block

        up_pressed:
        mov al, input_p1
        or al, MASK_INPUT_UP
        mov input_p1, al

        jmp .read_input_non_block

        down_pressed:
        mov al, input_p1
        or al, MASK_INPUT_DOWN
        mov input_p1, al

        jmp .read_input_non_block
    read_input endp

    process_input proc near
        mov paddle_left_vy, 0h
        test input_p1, MASK_INPUT_UP
        jnz .up_pressed

        test input_p1, MASK_INPUT_DOWN
        jnz .down_pressed

        ret

        .up_pressed:
        mov bx, paddle_vy_max
        mov paddle_left_vy, bx
        neg paddle_left_vy
        ret
        .down_pressed:
        mov bx, paddle_vy_max
        mov paddle_left_vy, bx
        ret
    process_input endp
;========= END INPUT ========;


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

;========= AI ========;
    ai_control_paddle proc near
        mov ax, ball_y
        sub ax, paddle_right_y

        cmp ax, 0h
        jg .set_velocity_up

        mov bx, paddle_vy_max
        mov paddle_right_vy, bx
        neg paddle_right_vy
        ret

        .set_velocity_up:
        mov bx, paddle_vy_max
        mov paddle_right_vy, bx
        ret
    ai_control_paddle endp
;========= END AI ========;
code ends

end