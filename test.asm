


bits 64                         ; x64 mode

section .data                   ; data section
    msg db "Hello, World!", 10  ; message with newline
    len equ $ - msg             ; length of message

section	.text                   ; section type
   global _main                 ; default entry point
_main:                          ; label name
        ; write syscall (print message)
        mov rax, 0x2000004      ; syscall 4: write (
        mov rdi, 1              ;    fd = stdout
        mov rsi, msg            ;    buffer
        mov rdx, len            ;    length
        syscall                 ; )
        
        ; exit syscall
        mov rax, 0x2000001      ; syscall 1: exit (
        mov rdi, 0              ;    retcode
        syscall                 ; )