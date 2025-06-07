# minOS

**Made for [minatomuh/cpu-sim](https://github.com/minatomuh/cpu-sim)**

## Overview

minOS is a simple non-preemptive operating system designed for the custom C312 CPU architecture. Capable of multitasking using a round-robin scheduler to manage up to 10 concurrent threads. The OS demonstrates fundamental OS concepts including process management, context switching, and system calls.

## Features

- **Cooperative Multitasking**: Non-preemptive scheduling where threads voluntarily yield control
- **Round-Robin Scheduler**: Sequential thread scheduling
- **Complete Context Switching**: Full CPU state preservation during thread switches
- **System Call Interface**: Support for printing, thread termination, and CPU yielding
- **Thread Management**: Support for up to 10 user threads

## System Architecture

### Memory Layout
- **Registers (0-20)**: Memory mapped CPU registers
- **OS Data (21-999)**: Reserved to OS
- **Thread Table (100-375)**: Process control blocks for up to 11 threads (including OS)
- **Thread Data Sections (1000+)**: Individual data and instruction spaces for each thread

## Instruction Set

| Instruction | Semantic | Description |
|-------------|----------|-------------|
| `SET B A` | `mem[A] = B` | Sets number B to memory address A |
| `CPY A1 A2` | `mem[A2] = mem[A1]` | Copy the value in memory address A1 to memory address A2 |
| `CPYI A1 A2` | `mem[A2] = mem[mem[A1]]` | Copy the memory address indexed by A1 to memory address A2 |
| `CPYI2 A1 A2` | `mem[mem[A2]] = mem[mem[A1]]` | Copy the memory address indexed by A1 to memory address indexed by A2 |
| `ADD A B` | `mem[A] = mem[A] + B` | Adds number B to memory address A |
| `ADDI A1 A2` | `mem[A1] = mem[A1] + mem[A2]` | Adds the value in memory address A2 to memory address A1 |
| `SUBI A1 A2` | `mem[A2] = mem[A1] - mem[A2]` | Subtracts the value in memory address A2 from memory address A1 |
| `JIF A C` | `PC = if mem[A] <= 0 then C else PC+1` | Jump if the value in memory address A is less than or equal to 0 |
| `PUSH A` | `mem[SP] = mem[A]; SP = SP - 1` | Pushes the value in memory address A to the stack |
| `POP A` | `mem[A] = mem[SP]; SP = SP + 1` | Pops the value from the stack to memory address A |
| `CALL C` | `PC = C; PUSH PC` | Calls the subroutine at address C and pushes the current PC to the stack |
| `RET` | `POP SP` | Returns from subroutine |
| `HLT` | Halts CPU | Halt CPU execution |
| `USER A` | | Switches to user mode and jumps to address A |
| `SYSCALL PRN A` | | Prints mem[A] |
| `SYSCALL HLT` | | Halts the thread |
| `SYSCALL YIELD` | | Thread yields the CPU |
