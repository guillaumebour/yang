JMP 0x4
AFC R0, 0x8
STR 0xd, R0
LOAD r0, 0xd
STR 0xe, R0
AFC R0, 0x8
STR 0xc, R0
LOAD r1, 0xe
LOAD r2, 0xc
SUB R0, R1, R2
STR 0xb, R0
JMPC 0x54, R0
AFC R0, 0x1
STR 0xa, R0
LOAD r1, 0xe
LOAD r2, 0xa
SUB R0, R1, R2
STR 0x9, R0
LOAD r0, 0x9
STR 0xe, R0
JMP 0xb
