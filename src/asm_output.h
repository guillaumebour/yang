#include <stdbool.h>
#include <stdint.h>
#include "symbol_table.h"

enum opcode_t {
    ADD = 0x1,
    MUL = 0x2,
    SUB = 0x3,
    DIV = 0x4,
    COP = 0x5,
    AFC = 0x6,
    LOAD = 0x7,
    STR = 0x8,
    EQU = 0x9,
    INF = 0xA,
    INFE = 0xB,
    SUP = 0xC,
    SUPE = 0xD,
    JMP = 0xE,
    JMPC = 0xF,
    POP = 0x10,
    PUSH = 0x11
};
typedef uint16_t opcode_t;
typedef uint16_t operand_t;
typedef unsigned int instr_index_t;

#define R0  0
#define R1  1
#define R2  2
#define R3  3
#define R4  4
#define R5  5
#define R6  6
#define R7  7
#define R8  8
#define R9  9
#define R10 10
#define R11 11
#define R12 12
#define R13 13
#define R14 14
#define PC  15

#define IGN          0xFFFF

void asm_output_init();
void set_asm_output(char * filename);
void set_asm_output_type(bool assembly_code);
instr_index_t asm_output_append(opcode_t inst, operand_t ope1, operand_t ope2, operand_t ope3);
instr_index_t asm_output_next_addr();
void asm_output_replace(instr_index_t index, opcode_t inst, operand_t ope1, operand_t ope2, operand_t ope3);
void add_function_entry(identifier_t name);
instr_index_t search_function(identifier_t name);
void asm_output_dump();
void asm_output_close();

#define asm_output_append_ADD( o1, o2, o3) asm_output_append(ADD,  o1, o2, o3)
#define asm_output_append_MUL( o1, o2, o3) asm_output_append(MUL,  o1, o2, o3)
#define asm_output_append_SUB( o1, o2, o3) asm_output_append(SUB,  o1, o2, o3)
#define asm_output_append_DIV( o1, o2, o3) asm_output_append(DIV,  o1, o2, o3)
#define asm_output_append_COP( o1, o2)     asm_output_append(COP,  o1, o2, IGN)
#define asm_output_append_AFC( o1, o2)     asm_output_append(AFC,  o1, o2, IGN)
#define asm_output_append_LOAD(o1, o2)     asm_output_append(LOAD, o1, o2, IGN)
#define asm_output_append_STR( o1, o2)     asm_output_append(STR,  o1, o2, IGN)
#define asm_output_append_EQU( o1, o2, o3) asm_output_append(EQU,  o1, o2, o3)
#define asm_output_append_INF( o1, o2, o3) asm_output_append(INF,  o1, o2, o3)
#define asm_output_append_INFE(o1, o2, o3) asm_output_append(INFE, o1, o2, o3)
#define asm_output_append_SUP( o1, o2, o3) asm_output_append(SUP,  o1, o2, o3)
#define asm_output_append_SUPE(o1, o2, o3) asm_output_append(SUPE, o1, o2, o3)
#define asm_output_append_JMP( o1)         asm_output_append(JMP,  o1, IGN, IGN)
#define asm_output_append_JMPC(o1, o2)     asm_output_append(JMPC, o1, o2, IGN)
#define asm_output_append_POP(o1)          asm_output_append(POP,  o1, IGN, IGN)
#define asm_output_append_PUSH(o1)         asm_output_append(PUSH, o1, IGN, IGN)
#define asm_output_append_PLCHLDR()        asm_output_append_JMP(0)
