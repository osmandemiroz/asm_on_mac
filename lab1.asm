section .bss
    fib_array: resb 8       ; Reserve 8 bytes for the Fibonacci sequence array in uninitialized data section

section .text               ; Begin the code section
global _main                ; Make _main global, entry point for linker/loader

_main:
    ; =====================================================================
    ; _main: Entry point for Fibonacci calculation and storage routine
    ; This program computes the first 8 values of the Fibonacci sequence
    ; and stores them sequentially in fib_array, then exits.
    ; =====================================================================

    XOR RAX, RAX            ; Clear RAX (AL = 0): fib[0] = 0
    MOV RDX, 1              ; Set RDX (DL = 1): fib[1] = 1 (the next fib value)
    LEA RDI, [rel fib_array]; RDI points to start of fib_array for storage
    MOV RCX, 6              ; We will generate 6 more (already have 0, 1)

    ; --- Store the first two Fibonacci values ---
    MOV byte [RDI], AL      ; Store fib[0] = 0 at fib_array[0]
    INC RDI                 ; Move RDI to fib_array[1]
    MOV byte [RDI], DL      ; Store fib[1] = 1 at fib_array[1]
    INC RDI                 ; Move to next free slot

    ; --- Main Loop: Generate the next 6 Fibonacci values ---
GEN_LOOP:
    MOV AL, DL              ; AL = previous value (fib[n-1])
    ADD AL, AH              ; AL = fib[n-1] + fib[n-2] (use previously-saved AH)
    MOV byte [RDI], AL      ; Store result at current address
    MOV AH, DL              ; Save old fib[n-1] in AH (for future step)
    MOV DL, AL              ; Update fib[n-1] = fib[n] for next iteration
    INC RDI                 ; Advance pointer to next array element
    LOOP GEN_LOOP           ; Repeat (RCX--), until 0 more to do

    ; --- Exit ---
    MOV RAX, 0x2000001      ; macOS/Linux syscall for exit() (sys_exit)
    MOV RDI, 0              ; exit code 0 (clean exit)
    syscall                 ; trigger system call
