# 8086 Assembly - Lab 1 Guide

## 📋 Lab Requirements
Generate 8 Fibonacci numbers (0, 1, 1, 2, 3, 5, 8, 13) and store them at memory addresses DS:2600h to DS:2607h using Register Indirect Addressing.

## 🚀 How to Run with emu8086

### Step 1: Install emu8086
Download from: https://emu8086.com/

### Step 2: Open Your Code
1. Open emu8086
2. File → New → Empty File
3. Copy contents of `lab1.asm`

### Step 3: Compile & Run
1. Click **Compile and Emulate** (or press F5)
2. Click **Single Step** (F8) to execute step-by-step
3. Open **View → Memory** to see results

### Step 4: Verify Results
- Navigate to DS segment
- Check offset 2600h
- You should see: 00, 01, 01, 02, 03, 05, 08, 0D

## 📁 Files
- `lab1.asm` - Fibonacci sequence program
- `labs/lab1_structured.md` - Detailed lab guide with explanations

## ✅ Expected Memory Layout

| Address | Hex Value | Decimal | Fibonacci |
|---------|-----------|---------|-----------|
| DS:2600h | 00h       | 0       | F(0)      |
| DS:2601h | 01h       | 1       | F(1)      |
| DS:2602h | 01h       | 1       | F(2)      |
| DS:2603h | 02h       | 2       | F(3)      |
| DS:2604h | 03h       | 3       | F(4)      |
| DS:2605h | 05h       | 5       | F(5)      |
| DS:2606h | 08h       | 8       | F(6)      |
| DS:2607h | 0Dh       | 13      | F(7)      |

## 🔍 What the Code Does

```asm
ORG 100h                    ; Set starting offset for .com file

MOV AX, 0                   ; AX = F(0) = 0
MOV DX, 1                   ; DX = F(1) = 1
MOV BX, 2600h               ; Point to first memory location (Register Indirect)
MOV CX, 6                   ; Loop counter (need 6 more numbers)

MOV [BX], AL                ; Store F(0) = 0 at DS:2600h
INC BX                      ; Move to DS:2601h
MOV [BX], DL                ; Store F(1) = 1 at DS:2601h
INC BX                      ; Move to DS:2602h

GEN_LOOP:                   ; Generate remaining numbers
    MOV AL, DL              ; Copy previous number
    ADD AL, AH              ; Add to get next Fibonacci
    MOV [BX], AL            ; Store at current address
    MOV AH, DL              ; Update registers for next iteration
    MOV DL, AL
    INC BX                  ; Move to next memory location
    LOOP GEN_LOOP           ; Repeat 6 times

RET                         ; Return to OS
```

## 📚 Resources
- See `labs/lab1_structured.md` for detailed explanations
- See `SuggestiveRead_LabEmulator.md` for complete emu8086 tutorial

