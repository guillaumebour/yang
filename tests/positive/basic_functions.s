JMP 0x18
AFC R0, 0x1
STR 0xd, R0
LOAD r0, 0xd
STR 0xe, R0
POP 0xf
AFC R0, 0x2
STR 0xa, R0
LOAD r0, 0xa
STR 0xb, R0
COP R0, R15
AFC R1, 0x10
ADD R0, R0, R1
PUSH 0x0
JMP 0x4
