# BIM303 Microcomputers - Lab Experiment #1

## 📚 Table of Contents
1. [Objective](#objective)
2. [Lab Task](#lab-task)
3. [Background Information](#background-information)
4. [Step-by-Step Guide](#step-by-step-guide)
5. [Expected Results](#expected-results)
6. [Evaluation Criteria](#evaluation-criteria)
7. [Submission Requirements](#submission-requirements)

---

## 🎯 Objective

Become familiar with:
- **Addressing modes** in 8086 assembly
- **Memory operations** using Register Indirect Addressing
- Working with the 8086 emulator software
- Understanding how to write data to specific memory locations

---

## 📋 Lab Task

Write a program that stores the first **8 Fibonacci numbers** (`0, 1, 1, 2, 3, 5, 8, 13`) to memory using **Register Indirect Addressing**.

### Requirements:
- Store the numbers at memory addresses from `DS:2600h` to `DS:2607h`
- Use **Register Indirect Addressing** mode (e.g., `[BX]`, `[SI]`, `[DI]`)
- Your program must generate the Fibonacci sequence and write it to memory

---

## 📖 Background Information

### What is Register Indirect Addressing?

Register Indirect Addressing uses a register as a pointer to memory. Instead of using immediate offsets, you use the value in a register as the memory address.

**Supported registers for indirect addressing:**
- `[BX]` - Base Register
- `[SI]` - Source Index Register
- `[DI]` - Destination Index Register
- `[BP]` - Base Pointer

**Example:**
```asm
MOV BX, 2600h     ; Load offset into BX register
MOV AL, [BX]      ; Load byte from address DS:BX into AL
```

### Fibonacci Sequence

The Fibonacci sequence is defined as:
- F(0) = 0
- F(1) = 1
- F(n) = F(n-1) + F(n-2) for n > 1

**First 8 numbers:** 0, 1, 1, 2, 3, 5, 8, 13

### Memory Layout

The program needs to write to sequential memory locations:

| Address | Value | Description |
|---------|-------|-------------|
| DS:2600h | 00h   | F(0) = 0    |
| DS:2601h | 01h   | F(1) = 1    |
| DS:2602h | 01h   | F(2) = 1    |
| DS:2603h | 02h   | F(3) = 2    |
| DS:2604h | 03h   | F(4) = 3    |
| DS:2605h | 05h   | F(5) = 5    |
| DS:2606h | 08h   | F(6) = 8    |
| DS:2607h | 0Dh   | F(7) = 13   |

---

## 🔧 Step-by-Step Guide

### Step 1: Plan Your Algorithm

1. Initialize first two Fibonacci numbers (0 and 1)
2. Store them in memory at DS:2600h and DS:2601h
3. Calculate subsequent numbers by adding the previous two
4. Store each new number in memory
5. Repeat until you have 8 numbers

### Step 2: Choose Registers

Recommended register usage:
- **BX** or **SI** or **DI** - Memory pointer (register indirect addressing)
- **AX** - Current Fibonacci number
- **CX** - Loop counter
- **DX** - Previous Fibonacci number (for calculation)

### Step 3: Initialize Variables

```asm
ORG 100h

MOV AX, 0          ; First Fibonacci: F(0) = 0
MOV DX, 1          ; Second Fibonacci: F(1) = 1
MOV BX, 2600h      ; Memory pointer (Register Indirect)
MOV CX, 8          ; Loop counter
```

### Step 4: Store Initial Values

```asm
MOV [BX], AL       ; Store 0 at DS:2600h (using Register Indirect)
INC BX             ; Move pointer to next location
MOV [BX], DL       ; Store 1 at DS:2601h
INC BX             ; Move pointer to next location
```

### Step 5: Generate and Store Remaining Numbers

Loop to generate the remaining 6 Fibonacci numbers:

```asm
GEN_LOOP:
    MOV AL, DL      ; Copy previous number
    ADD AL, AH      ; Add to current (AH contains value before)
    
    MOV [BX], AL    ; Store new Fibonacci number
    
    MOV AH, DL      ; Update for next iteration
    MOV DL, AL
    
    INC BX          ; Move to next memory location
    LOOP GEN_LOOP   ; Decrement CX and loop if not zero
```

### Step 6: End Program

```asm
RET                ; Return to operating system
```

### Complete Program Structure

```asm
ORG 100h

MOV AX, 0
MOV DX, 1
MOV BX, 2600h
MOV CX, 8

MOV [BX], AL
INC BX
MOV [BX], DL
INC BX

GEN_LOOP:
    MOV AL, DL
    ADD AL, AH
    MOV [BX], AL
    MOV AH, DL
    MOV DL, AL
    INC BX
    LOOP GEN_LOOP

RET
```

---

## ✅ Expected Results

After running your program, inspect memory at location `DS:2600h` through `DS:2607h`. The memory should contain:

```
Address    Byte (Hex)    Byte (Dec)    Fibonacci Number
-------    ----------    ----------    -----------------
DS:2600h       00             0         F(0)
DS:2601h       01             1         F(1)
DS:2602h       01             1         F(2)
DS:2603h       02             2         F(3)
DS:2604h       03             3         F(4)
DS:2605h       05             5         F(5)
DS:2606h       08             8         F(6)
DS:2607h       0D            13         F(7)
```

### How to Verify

1. **Run your program** in the emulator
2. **Open the memory window** (View → Memory)
3. **Navigate to DS segment, offset 2600h**
4. **Verify** the values match the expected results above

---

## 📝 Evaluation Criteria

### Evaluation Checklist:

- [ ] Program uses **Register Indirect Addressing** (e.g., `[BX]`, `[SI]`, `[DI]`)
- [ ] Program generates all 8 Fibonacci numbers correctly
- [ ] Data is stored at correct memory addresses (DS:2600h to DS:2607h)
- [ ] Code has **NO comments** (as per requirement)
- [ ] Program compiles without errors
- [ ] Program executes successfully
- [ ] Memory verification confirms correct values

### Grading Rubric:

| Criteria | Points | Description |
|----------|--------|-------------|
| Register Indirect Addressing | 30 | Proper use of indirect addressing mode |
| Correct Fibonacci Generation | 30 | All 8 numbers calculated correctly |
| Memory Location | 20 | Data stored at correct addresses |
| Code Structure | 10 | Clean, organized code |
| No Comments | 10 | No comment lines in code |
| **Total** | **100** | |

---

## 📤 Submission Requirements

### Important Notes:

1. ⏰ **Deadline**: You must complete your work **during the lab session**
2. 📋 **Evaluation**: You will be evaluated during the lab hour
3. 🚫 **No Comments**: Your code should **NOT contain any comment lines**
4. 📝 **Submission Platform**: All assignments must be submitted through the **ESTUOYS system**
5. ⚠️ **Warning**: Students who do not submit through ESTUOYS will receive **0 (zero) points**
6. ⏰ **Late Policy**: Late submissions will **NOT be accepted**

### What to Submit:

1. Your assembly source file (`.asm`)
2. Compiled executable (`.com` or `.exe`)
3. Screenshot of memory window showing the results

### Submission Steps:

1. Compile your program in the emulator
2. Run the program
3. Take a screenshot of the memory window showing the results
4. Save your source code file
5. Submit both files through ESTUOYS before the end of the lab session

---

## 💡 Tips and Hints

### Tip 1: Setting Initial Values
Make sure to initialize your pointer register before using it:
```asm
MOV BX, 2600h      ; Point to first memory location
```

### Tip 2: Loop Counter
Use `LOOP` instruction with CX register for efficient looping:
```asm
MOV CX, 8          ; Set loop counter
LOOP label         ; Decrements CX and jumps if not zero
```

### Tip 3: Memory Access Verification
Use Register Indirect Addressing like this:
```asm
MOV [BX], AL       ; Store byte from AL to address in BX
```

### Tip 4: Pointer Management
Don't forget to increment your pointer:
```asm
INC BX             ; Move to next byte
```

### Tip 5: Testing
Test with smaller numbers first. Try generating only 4 Fibonacci numbers, verify they're correct, then expand to 8.

---

## 🔍 Common Mistakes to Avoid

1. ❌ **Not using Register Indirect Addressing** - Must use `[BX]`, `[SI]`, `[DI]`, or `[BP]`
2. ❌ **Incorrect memory address** - Must use addresses from DS:2600h to DS:2607h
3. ❌ **Adding comments** - Your code must have NO comments
4. ❌ **Wrong Fibonacci sequence** - Must be: 0, 1, 1, 2, 3, 5, 8, 13
5. ❌ **Not incrementing the pointer** - Must move to next memory location
6. ❌ **Forgetting to loop** - Must generate all 8 numbers

---

## 📚 Additional Resources

### Relevant Documentation Sections:

From the emulator tutorial, review these sections:

1. **Registers** (lines 37-104)
   - AX, BX, CX, DX registers
   - Understanding register operations

2. **Memory Access** (lines 107-206)
   - Addressing modes
   - Register Indirect Addressing

3. **MOV Instruction** (lines 209-250)
   - How to move data to memory
   - Register indirect operations

4. **Variables** (lines 285-392)
   - Memory organization
   - Data storage

### Key Instructions You'll Need:

- `MOV` - Move data
- `ADD` - Add numbers
- `INC` - Increment
- `LOOP` - Loop with counter
- `RET` - Return

---

## 📞 Need Help?

If you're stuck, consider:

1. Review the emulator tutorial sections on:
   - Addressing Modes (Section: Memory Access)
   - MOV Instruction
   - Loops and Control Flow

2. Start with a simple version that stores hardcoded values first, then make it dynamic

3. Use the emulator's debug features to step through your program

---

## 🎓 Learning Outcomes

After completing this lab, you should be able to:

✅ Understand Register Indirect Addressing mode  
✅ Write data to specific memory locations  
✅ Generate a sequence using loops  
✅ Debug assembly programs in the emulator  
✅ Verify memory contents after program execution  

---

**Good luck with your lab! 🚀**

