Ying Instruction Set Architecture
=================================

This document describes the ISA of Ying CPUs. Yang compiles programs for this
architecture.

Ying is an 8-bits architecture:
- Addresses are 8-bits long
- Registers are 8-bits long
- Opcodes   are 8-bits long

There are 16 registers named:
- R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14 and PC

| Operation  | Opcode | Format          | Description                            |
|------------|:------:|-----------------|----------------------------------------|
| Addition   | 0x1    | ADD  Ri, Rj, Rk | [Ri] <- [Rj] + [Rk]                    |
| Multiply   | 0x2    | MUL  Ri, Rj, Rk | [Ri] <- [Rj] * [Rk]                    |
| Substract  | 0x3    | SUB  Ri, Rj, Rk | [Ri] <- [Rj] - [Rk]                    |
| Divide     | 0x4    | DIV  Ri, Rj, Rk | [Ri] <- [Rj] / [Rk]                    |
| Copy       | 0x5    | COP  Ri, Rj     | [Ri] <- [Rj]                           |
| Affect     | 0x6    | AFC  Ri, j      | [Ri] <- j                              |
| Load       | 0x7    | LOAD Ri, @j     | [Ri] <- [@j]                           |
| Save       | 0x8    | STR  @i, Rj     | [@i] <- [Rj]                           |
| Equal      | 0x9    | EQU  Ri, Rj, Rk | [Ri] <- 1 if [Rj] =  [Rk], else 0      |
| Inferior   | 0xA    | INF  Ri, Rj, Rk | [Ri] <- 1 if [Rj] <  [Rk], else 0      |
| Inf or equ | 0xB    | INFE Ri, Rj, Rk | [Ri] <- 1 if [Rj] <= [Rk], else 0      |
| Superior   | 0xC    | SUP  Ri, Rj, Rk | [Ri] <- 1 if [Rj] >  [Rk], else 0      |
| Sup or equ | 0xD    | SUPE Ri, Rj, Rk | [Ri] <- 1 if [Rj] >= [Rk], else 0      |
| Jump       | 0xE    | JMP  @i         | Jump to the address @i                 |
| Cond. Jump | 0xF    | JMPC @i, Rj     | Jump to the address @i if Ri = 0       |
