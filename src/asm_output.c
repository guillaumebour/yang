#include "asm_output.h"

#include <stdio.h>
#include <stdarg.h>

#define MAX_INSTR_NB 2048

static FILE *output;
static bool assembly_output;

struct instr_t {
    opcode_t  opcode;
    operand_t ope1;
    operand_t ope2;
    operand_t ope3;
};

static instr_index_t next_instr_index;
static struct instr_t instrs_buf[MAX_INSTR_NB];

void asm_output_init()
{
    next_instr_index = 0;
    assembly_output = true;
}

void set_asm_output(char * filename)
{
    if(filename)
        output = fopen(filename, "w");
    else
        output = stdout;
}

void set_asm_output_type(bool assembly_code)
{
    assembly_output = assembly_code;
}

void asm_output_append(opcode_t opcode, operand_t ope1, operand_t ope2, operand_t ope3)
{
    struct instr_t inst;
    inst.opcode = opcode;
    inst.ope1   = ope1;
    inst.ope2   = ope2;
    inst.ope3   = ope3;

    instrs_buf[next_instr_index] = inst;

    next_instr_index ++;
}

void asm_output_append_jmpc_placeholder()
{
    asm_output_append(JMPC_PLCHLDR, IGN, IGN, IGN);
}

void asm_output_resolve_last_jmpc()
{
    instr_index_t i = next_instr_index;

    while(i) {
        if (instrs_buf[i].opcode == JMPC_PLCHLDR) {
            instrs_buf[i].opcode = JMPC;
            instrs_buf[i].ope1 = next_instr_index;
            instrs_buf[i].ope2 = 0;
            break;
        }

        i--;
    }
}

void asm_output_dump()
{
    if(assembly_output) {
        instr_index_t i = 0;

        while(i < next_instr_index) {
            struct instr_t inst = instrs_buf[i];

            switch (inst.opcode) {
            case ADD:
                fprintf(output, "ADD R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case MUL:
                fprintf(output, "MUL R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case SUB:
                fprintf(output, "SUB R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case DIV:
                fprintf(output, "DIV R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case COP:
                fprintf(output, "COP R%d, R%d\n", inst.ope1, inst.ope2);
                break;
            case AFC:
                fprintf(output, "AFC R%d, 0x%x\n", inst.ope1, inst.ope2);
                break;
            case LOAD:
                fprintf(output, "LOAD r%d, 0x%x\n", inst.ope1, inst.ope2);
                break;
            case STR:
                fprintf(output, "STR 0x%x, R%d\n", inst.ope1, inst.ope2);
                break;
            case EQU:
                fprintf(output, "EQU R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case INF:
                fprintf(output, "INF R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case INFE:
                fprintf(output, "INFE R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case SUP:
                fprintf(output, "SUP R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case SUPE:
                fprintf(output, "SUPE R%d, R%d, R%d\n", inst.ope1, inst.ope2, inst.ope3);
                break;
            case JMP:
                fprintf(output, "JMP 0x%x\n", inst.ope1);
                break;
            case JMPC:
                fprintf(output, "JMPC 0x%x, R%d\n", inst.ope1, inst.ope2);
                break;
            case JMPC_PLCHLDR:
                fprintf(stderr, "Unexpected undefined branching. Ignoring.\n");
                break;
            default:
                fprintf(stderr, "Unexpected generated instruction. Ignoring.\n");
            }
            i ++;
        }
    } else
        fwrite(instrs_buf, sizeof(struct instr_t), next_instr_index, output);
}

void asm_output_close()
{
    fclose(output);
}
