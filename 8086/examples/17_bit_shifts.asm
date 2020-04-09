.model small

org 100h

.data

.code

main proc

    mov ax, 3h                 
    
    ; << = *2^n. Expected 0x0Ch
    shl ax, 2
    
    ; >> = /2^n. Expected 0x06
    shr ax, 1
    
    ;lost bit is moved to CF
    shr ax, 2;expect CF 1, ax = 1
    
    ;sal, sar (same for 16 bits?)
    
    

    ret
endp

end main