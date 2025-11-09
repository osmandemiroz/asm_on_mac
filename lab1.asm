section .bss
    fib_array: resb 8

section .text
global _main

_main:

    XOR RAX, RAX
    MOV RDX, 1
    LEA RDI, [rel fib_array]
    MOV RCX, 6

    MOV byte [RDI], AL
    INC RDI
    MOV byte [RDI], DL
    INC RDI

    GEN_LOOP:
    MOV AL, DL
    ADD AL, AH
    MOV byte [RDI], AL
    MOV AH, DL
    MOV DL, AL
    INC RDI
    LOOP GEN_LOOP

    MOV RAX, 0x2000001
    MOV RDI, 0
    syscall
