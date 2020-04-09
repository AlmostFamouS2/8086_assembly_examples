mov al, var1; check the value of var1
lea bx, var1; move the effective address of var 1 into bx
mov byte ptr[bx], 44h; essencially mov var1, 44h
mov al, var1; check the written value
           
; example with offset instead
mov var1, 22h
mov al, var1; check the value of var1
mov bx, offset var1; move the offset of var1 to bx
mov byte ptr[bx], 44h; essencially mov var1, 44h
mov al, var1; check the written value

ret
var1 db 22h