JMP 0x4
AFC R0, 0x6
STR 0xd, R0
AFC R0, 0x8
STR 0xc, R0
LOAD r1, 0xd
LOAD r2, 0xc
ADD R0, R1, R2
STR 0xb, R0
AFC R0, 0x3
STR 0xa, R0
LOAD r1, 0xb
LOAD r2, 0xa
MUL R0, R1, R2
STR 0x9, R0
LOAD r0, 0x9
STR 0xe, R0