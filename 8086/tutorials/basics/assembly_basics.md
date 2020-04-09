http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/8086%20Assembler%20Tutorial%20for%20Beginners%20(Part%201).htm

## Registers

### General Purpose registers
- AX, BX, CX, DX (16 bit)
    - Some of them have special use
- SI, DI, BP, SP (8 bit)

### Segment registers
- CS: Points to the segment containing the current program
- DS: Points to a segment where variables are defined
- ES: Extra segment (free for use)
- SS: Points to the segment containing the stack

You can point to an address by using *one segment register + one general purpose register (offset)*. 8086 processor has 1mb memory, addressable via 20bit addresses. The CPU calculates effective addresses by *multiplying the segment register by 10h and adding the general purpose register*.

- BX, SI, DI work with DS segment register
- BP and SP work with SS stack register

### Special purpose registers
- IP: Instruction pointer
- Flags Register: All the flags that determines the state of the processor

Cannot be acessed directly (though operations can move flag values to general purpose registers)

## Addressing Memory

- BX | SI | + disp
- BP | DI | + disp

- disp: d8 or d16 (bit displacement)
- Example:
    - [BX + SI] + d8
    - [2h]
    - [8h] + d16

- **You cannot move an immediate value to a segment register (move it to a general purpose register first)**

## Variables

- {name} DB/DW {value}
    - {name}: Any name
    - DB: Defined Byte, DW: Defined Word
    - {value}: any immediate value or ?

### Arrays

- a DB "Hello World$"
- a[1] = 'e'

### Getting addresses

- LEA (load effective address) or OFFSET can be used to ask the Assembler to calculate the effective address or offset of a variable
    - `lea x, var` is equal to `mov x, offset var`
- Use:
    - byte ptr[x] or b.[x]: for byte pointer
    - word ptr[x]: for word pointer
    - Only acceptable pointer registers are: BX, SI, DI, BP

### Constants

- {name} equ {expression}

## Interrupts

Can be seen as functions you can call from your program (software interruptions) or that the hardware can throw (hardware interruptions).

### Software Interruptions

- int VALUE
- A interrupt can vae 256 functions (1 byte number), and 256 sub functions (value set in ah before calling interrupt)
- Other registers can be used to pass parameters to this functions
- List of interrupts: http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/Interrupts%20currently%20supported%20by%20emulator.htm

## Operands
- http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/8086%20Assembler%20Tutorial%20for%20Beginners%20(Part%206).htm
- 8086 full instruction set: http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/8086%20instructions.htm

## Flow Control
- http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/8086%20Assembler%20Tutorial%20for%20Beginners%20(Part%207).htm

 - Conditional jumps can only jump 127 bytes forward, and 128 bytes backwards

 ## Procedures
 - http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/8086%20Assembler%20Tutorial%20for%20Beginners%20(Part%208).htm
 - You can pass parameters to procedures using registers

## Stack
- You know what it is
- Last in, first out
- You must leave the number of push and pops equal, otherwise the stack may be corrupted
- It's a good way to safe register values when calling procedures:
    - Safe whatever registers in the stack using push
    - Call the procedure
    - The procedure can do whatever
    - Restore the values using pop

## Macros
- http://ce.kashanu.ac.ir/sabaghian/assembly/8086%20tutorial/8086%20Assembler%20Tutorial%20for%20Beginners%20(Part%2010).htm
- for variable local labels

