# x64 Assembly Language Reference (macOS)

## 🚀 Quick Start - How to Run

### Option 1: Using Make (Recommended)
```bash
make all source=test
./test
```

### Option 2: Manual Build
```bash
# Step 1: Assemble (ASM → Object file)
nasm -f macho64 test.asm -DDARWIN

# Step 2: Link (Object file → Executable)
ld test.o -o test -demangle -dynamic -macos_version_min 11.0 \
   -L/usr/local/lib -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
   -lSystem -no_pie

# Step 3: Run
./test
```

### One-Liner (Build & Run)
```bash
make all source=test && ./test
```

---

## Table of Contents
1. [Basic Program Structure](#basic-program-structure)
2. [Registers](#registers)
3. [Instructions](#instructions)
4. [Data Types & Sections](#data-types--sections)
5. [Syscalls (macOS)](#syscalls-macos)
6. [Addressing Modes](#addressing-modes)
7. [Control Flow](#control-flow)
8. [Stack Operations](#stack-operations)
9. [Examples](#examples)
10. [Build & Run Details](#build--run-macos)

---

## Basic Program Structure

```asm
bits 64                         ; Specify 64-bit mode

section .data                   ; Data section (initialized data)
    ; Define variables here

section .bss                    ; BSS section (uninitialized data)
    ; Reserve space for variables

section .text                   ; Code section
    global _main                ; Entry point (macOS uses _main)
_main:
    ; Your code here
    
    ; Exit syscall
    mov rax, 0x2000001         ; exit syscall
    mov rdi, 0                 ; return code
    syscall
```

---

## Registers

### General Purpose Registers (64-bit)
| Register | 64-bit | 32-bit | 16-bit | 8-bit (low) | Purpose |
|----------|--------|--------|--------|-------------|---------|
| RAX | rax | eax | ax | al | Accumulator, syscall number, return value |
| RBX | rbx | ebx | bx | bl | Base register |
| RCX | rcx | ecx | cx | cl | Counter (loops) |
| RDX | rdx | edx | dx | dl | Data register |
| RSI | rsi | esi | si | sil | Source index (string ops) |
| RDI | rdi | edi | di | dil | Destination index (string ops) |
| RBP | rbp | ebp | bp | bpl | Base pointer (stack frame) |
| RSP | rsp | esp | sp | spl | Stack pointer |
| R8-R15 | r8-r15 | r8d-r15d | r8w-r15w | r8b-r15b | Additional registers |

### Special Registers
- **RIP**: Instruction pointer
- **RFLAGS**: Status flags (zero, carry, sign, overflow, etc.)

### Register Usage in Function Calls (System V AMD64 ABI)
- **Arguments**: RDI, RSI, RDX, RCX, R8, R9 (then stack)
- **Return value**: RAX
- **Caller-saved**: RAX, RCX, RDX, RSI, RDI, R8-R11
- **Callee-saved**: RBX, RSP, RBP, R12-R15

---

## Instructions

### Data Movement
```asm
mov dest, src              ; Move data from src to dest
movzx dest, src            ; Move with zero extension
movsx dest, src            ; Move with sign extension
lea dest, [address]        ; Load effective address
xchg op1, op2             ; Exchange two operands
```

### Arithmetic
```asm
add dest, src              ; dest = dest + src
sub dest, src              ; dest = dest - src
mul src                    ; RAX = RAX * src (unsigned)
imul src                   ; RAX = RAX * src (signed)
div src                    ; RAX = RAX / src, RDX = remainder (unsigned)
idiv src                   ; Signed division
inc dest                   ; dest = dest + 1
dec dest                   ; dest = dest - 1
neg dest                   ; dest = -dest
```

### Logical & Bitwise
```asm
and dest, src              ; Bitwise AND
or dest, src               ; Bitwise OR
xor dest, src              ; Bitwise XOR
not dest                   ; Bitwise NOT
shl dest, count            ; Shift left
shr dest, count            ; Shift right (logical)
sar dest, count            ; Shift right (arithmetic)
rol dest, count            ; Rotate left
ror dest, count            ; Rotate right
```

### Comparison
```asm
cmp op1, op2              ; Compare (sets flags)
test op1, op2             ; Bitwise test (sets flags)
```

### String Operations
```asm
movsb/movsw/movsd/movsq   ; Move string (byte/word/dword/qword)
lodsb/lodsw/lodsd/lodsq   ; Load string
stosb/stosw/stosd/stosq   ; Store string
scasb/scasw/scasd/scasq   ; Scan string
cmpsb/cmpsw/cmpsd/cmpsq   ; Compare strings
rep                        ; Repeat prefix
```

---

## Data Types & Sections

### Section Directives
```asm
section .data              ; Initialized data
section .bss               ; Uninitialized data (reserves space)
section .text              ; Code
section .rodata            ; Read-only data
```

### Data Definition
```asm
; In .data section:
db  10, 20, 30            ; Define bytes
dw  1000, 2000            ; Define words (16-bit)
dd  100000                ; Define doubleword (32-bit)
dq  1000000000            ; Define quadword (64-bit)
dt  1234567890            ; Define ten bytes

; Strings
msg db "Hello", 0         ; Null-terminated string
msg db "Hello", 10        ; String with newline

; Constants
equ NAME value            ; Define constant
len equ $ - msg           ; Calculate length ($ = current address)

; In .bss section (uninitialized):
resb  100                 ; Reserve 100 bytes
resw  50                  ; Reserve 50 words
resd  25                  ; Reserve 25 doublewords
resq  10                  ; Reserve 10 quadwords
```

---

## Syscalls (macOS)

### macOS Syscall Convention
- Syscall numbers start at `0x2000000`
- Arguments: **RDI, RSI, RDX, R10, R8, R9**
- Return value: **RAX**
- Invoke with: `syscall` instruction

### Common Syscalls
```asm
; Exit
mov rax, 0x2000001        ; syscall: exit
mov rdi, 0                ; arg1: exit code
syscall

; Write (print to stdout)
mov rax, 0x2000004        ; syscall: write
mov rdi, 1                ; arg1: file descriptor (1 = stdout)
mov rsi, buffer           ; arg2: buffer address
mov rdx, length           ; arg3: number of bytes
syscall

; Read (from stdin)
mov rax, 0x2000003        ; syscall: read
mov rdi, 0                ; arg1: file descriptor (0 = stdin)
mov rsi, buffer           ; arg2: buffer address
mov rdx, length           ; arg3: max bytes to read
syscall

; Open file
mov rax, 0x2000005        ; syscall: open
mov rdi, filename         ; arg1: path
mov rsi, flags            ; arg2: flags (0=read, 1=write, 2=read/write)
mov rdx, mode             ; arg3: permissions (e.g., 0644)
syscall

; Close file
mov rax, 0x2000006        ; syscall: close
mov rdi, fd               ; arg1: file descriptor
syscall
```

### Syscall Numbers Reference
| Number | Name | Description |
|--------|------|-------------|
| 0x2000001 | exit | Terminate process |
| 0x2000003 | read | Read from file descriptor |
| 0x2000004 | write | Write to file descriptor |
| 0x2000005 | open | Open file |
| 0x2000006 | close | Close file descriptor |
| 0x200000C | chdir | Change directory |
| 0x2000014 | getpid | Get process ID |
| 0x200002E | gettimeofday | Get time |

---

## Addressing Modes

```asm
; Immediate
mov rax, 42               ; RAX = 42

; Register
mov rax, rbx              ; RAX = RBX

; Direct memory
mov rax, [address]        ; RAX = *address

; Register indirect
mov rax, [rbx]            ; RAX = *RBX

; Register + displacement
mov rax, [rbx + 8]        ; RAX = *(RBX + 8)

; Base + index
mov rax, [rbx + rcx]      ; RAX = *(RBX + RCX)

; Base + index + displacement
mov rax, [rbx + rcx + 8]  ; RAX = *(RBX + RCX + 8)

; Base + index*scale + displacement
mov rax, [rbx + rcx*4 + 8] ; RAX = *(RBX + RCX*4 + 8)
                          ; scale can be 1, 2, 4, or 8

; RIP-relative (position-independent code)
mov rax, [rel label]      ; RAX = *label (relative to RIP)
```

---

## Control Flow

### Unconditional Jumps
```asm
jmp label                 ; Jump to label
call function             ; Call function (pushes return address)
ret                       ; Return from function (pops return address)
```

### Conditional Jumps (after cmp or test)
```asm
je/jz label               ; Jump if equal/zero (ZF=1)
jne/jnz label             ; Jump if not equal/not zero (ZF=0)
jg/jnle label             ; Jump if greater (signed)
jge/jnl label             ; Jump if greater or equal (signed)
jl/jnge label             ; Jump if less (signed)
jle/jng label             ; Jump if less or equal (signed)
ja/jnbe label             ; Jump if above (unsigned)
jae/jnb label             ; Jump if above or equal (unsigned)
jb/jnae label             ; Jump if below (unsigned)
jbe/jna label             ; Jump if below or equal (unsigned)
js label                  ; Jump if sign (SF=1)
jns label                 ; Jump if not sign (SF=0)
jo label                  ; Jump if overflow (OF=1)
jno label                 ; Jump if not overflow (OF=0)
jc label                  ; Jump if carry (CF=1)
jnc label                 ; Jump if not carry (CF=0)
```

### Loop Instructions
```asm
loop label                ; Decrement RCX, jump if RCX != 0
loope/loopz label         ; Loop while equal/zero
loopne/loopnz label       ; Loop while not equal/not zero
```

---

## Stack Operations

### Stack Instructions
```asm
push src                  ; Push onto stack (RSP -= 8, then store)
pop dest                  ; Pop from stack (load, then RSP += 8)
pushf                     ; Push flags register
popf                      ; Pop flags register
```

### Stack Frame Setup
```asm
; Function prologue
push rbp                  ; Save old base pointer
mov rbp, rsp              ; Set new base pointer
sub rsp, 32               ; Allocate local variables

; Function epilogue
mov rsp, rbp              ; Restore stack pointer
pop rbp                   ; Restore base pointer
ret                       ; Return
```

---

## Examples

### Example 1: Hello World
```asm
bits 64

section .data
    msg db "Hello, World!", 10
    len equ $ - msg

section .text
    global _main
_main:
    ; Write syscall
    mov rax, 0x2000004        ; syscall: write
    mov rdi, 1                ; stdout
    mov rsi, msg              ; message buffer
    mov rdx, len              ; message length
    syscall
    
    ; Exit syscall
    mov rax, 0x2000001        ; syscall: exit
    mov rdi, 0                ; exit code 0
    syscall
```

### Example 2: Simple Loop (print numbers 1-10)
```asm
bits 64

section .data
    digit db "0", 10          ; Digit + newline
    
section .text
    global _main
_main:
    mov rcx, 1                ; Counter = 1
    
loop_start:
    ; Convert counter to ASCII
    mov rax, rcx
    add rax, 48               ; Convert to ASCII ('0' = 48)
    mov [digit], al           ; Store digit
    
    ; Print digit
    mov rax, 0x2000004        ; syscall: write
    mov rdi, 1                ; stdout
    mov rsi, digit            ; buffer
    mov rdx, 2                ; length (digit + newline)
    syscall
    
    ; Increment and check
    inc rcx
    cmp rcx, 11               ; Check if counter > 10
    jl loop_start             ; Jump if less
    
    ; Exit
    mov rax, 0x2000001
    mov rdi, 0
    syscall
```

### Example 3: Function Call
```asm
bits 64

section .text
    global _main

; Function: add two numbers
; Args: rdi = a, rsi = b
; Returns: rax = a + b
add_numbers:
    mov rax, rdi              ; RAX = first argument
    add rax, rsi              ; RAX += second argument
    ret                       ; Return

_main:
    ; Call add_numbers(5, 7)
    mov rdi, 5                ; First argument
    mov rsi, 7                ; Second argument
    call add_numbers          ; Call function (result in RAX)
    
    ; Exit with result as exit code
    mov rdi, rax              ; Move result to exit code
    mov rax, 0x2000001        ; syscall: exit
    syscall
```

### Example 4: String Length Calculator
```asm
bits 64

section .data
    str db "Hello", 0         ; Null-terminated string

section .bss
    len resq 1                ; Reserve space for length

section .text
    global _main

; Calculate string length
; Args: rdi = string pointer
; Returns: rax = length
strlen:
    xor rax, rax              ; RAX = 0 (counter)
.loop:
    cmp byte [rdi + rax], 0   ; Check for null terminator
    je .done                  ; If null, we're done
    inc rax                   ; Increment counter
    jmp .loop                 ; Continue loop
.done:
    ret

_main:
    ; Calculate length of str
    mov rdi, str              ; Load string address
    call strlen               ; Call strlen
    mov [len], rax            ; Store result
    
    ; Exit
    mov rdi, rax              ; Exit with length as code
    mov rax, 0x2000001
    syscall
```

### Example 5: Array Sum
```asm
bits 64

section .data
    array dq 10, 20, 30, 40, 50  ; Array of 5 quadwords
    count equ 5

section .text
    global _main

_main:
    xor rax, rax              ; Sum = 0
    xor rcx, rcx              ; Index = 0
    
sum_loop:
    add rax, [array + rcx*8]  ; Add array[index] to sum
    inc rcx                   ; index++
    cmp rcx, count            ; Check if done
    jl sum_loop               ; Continue if index < count
    
    ; Exit with sum as exit code
    mov rdi, rax
    mov rax, 0x2000001
    syscall
```

---

## Build & Run (macOS)

### Using NASM and ld
```bash
# Assemble
nasm -f macho64 program.asm -DDARWIN

# Link
ld program.o -o program -demangle -dynamic -macos_version_min 11.0 \
   -L/usr/local/lib -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
   -lSystem -no_pie

# Run
./program
```

### Using Makefile
```makefile
all:
	nasm -f macho64 $(source).asm -DDARWIN
	ld $(source).o -o $(source) -demangle -dynamic -macos_version_min 11.0 \
	   -L/usr/local/lib -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk \
	   -lSystem -no_pie
	rm $(source).o
```

Build with: `make all source=program`

---

## Tips & Best Practices

1. **Comments**: Add comments explaining what each instruction does
2. **Alignment**: Use `align 16` for performance-critical code
3. **Register preservation**: Save and restore registers in functions
4. **Error checking**: Check RAX after syscalls (negative = error)
5. **Debugging**: Use `lldb` to step through assembly code
6. **Clear registers**: Use `xor rax, rax` instead of `mov rax, 0` (smaller encoding)
7. **Size matters**: Use appropriate instruction sizes (byte/word/dword/qword)
8. **Stack alignment**: Keep RSP aligned to 16 bytes before `call`

---

## Resources

- **Intel Manual**: Intel 64 and IA-32 Architectures Software Developer's Manual
- **System V ABI**: AMD64 calling convention specification
- **macOS syscalls**: `/usr/include/sys/syscall.h`
- **NASM Documentation**: https://nasm.us/doc/

---

*Happy coding in assembly! 🚀*

