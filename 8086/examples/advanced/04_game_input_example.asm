.model small

org 100h

MASK_INPUT_UP equ 80h
MASK_INPUT_DOWN equ 40h
P1_UP_KEY equ 'w'
P1_DOWN_KEY equ 's'

.data

    input_p1 db 0h

.code

main proc near
    start:
    call read_input
    
    mov al, input_p1
    test al, MASK_INPUT_UP
    jnz w_pressed:
    
    check_s_pressed:
    
    mov al, input_p1
    test al, MASK_INPUT_DOWN
    jnz s_pressed:
    
    jmp start
    
    w_pressed:    
    mov dl, 'w'
    mov ah,2h; code for write character (in dl)
    int 21h     
    
    jmp check_s_pressed                        
    
    s_pressed:    
    mov dl, 's'
    mov ah,2h; code for write character (in dl)
    int 21h            
    
    jmp start
    
    ret
main endp

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