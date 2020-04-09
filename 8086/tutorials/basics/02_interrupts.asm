; list of supported interrupts: http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/Interrupts%20currently%20supported%20by%20emulator.htm

mov ah, 0eh; sub function for print

mov al, 'h'; char to print

int 10h; interrupt to print

ret