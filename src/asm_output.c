#include "asm_output.h"

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include "logs.h"

#define MAX_INSTR_NB 2048
#define FUNCTION_TABLE_SIZE 256

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

struct function_entry {
    identifier_t identifier;
    instr_index_t address_index;
};

static unsigned int function_table_index = 0;
static struct function_entry function_table[FUNCTION_TABLE_SIZE];


void asm_output_init()
{
    next_instr_index = 1;
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

void add_function_entry(identifier_t name)
{
    struct function_entry new_function;
    unsigned int name_length;

    name_length = strlen(name);

    new_function.identifier = malloc(name_length * sizeof(char));
    strncpy(new_function.identifier, name, name_length);
    new_function.address_index = next_instr_index;

    function_table[function_table_index] = new_function;
    function_table_index ++;
}

instr_index_t search_function(identifier_t name)
{
    int i;

    for(i = 0; i < function_table_index; i++) {
        struct function_entry function = function_table[i];

        if(strcmp(function.identifier, name) == 0) {
            return function.address_index;
        }
    }

    return INCORRECT_ADDRESS;
}

void asm_output_replace(instr_index_t index, opcode_t opcode, operand_t ope1, operand_t ope2, operand_t ope3)
{
    struct instr_t inst;
    inst.opcode = opcode;
    inst.ope1   = ope1;
    inst.ope2   = ope2;
    inst.ope3   = ope3;

    instrs_buf[index] = inst;
}

instr_index_t asm_output_append(opcode_t opcode, operand_t ope1, operand_t ope2, operand_t ope3)
{
    asm_output_replace(next_instr_index, opcode, ope1, ope2, ope3);

    next_instr_index ++;

    return next_instr_index-1;
}

instr_index_t asm_output_next_addr()
{
    return next_instr_index;
}

void asm_output_dump()
{
    identifier_t main_name = "main";
    instr_index_t main_addr = search_function(main_name);

    if(main_addr != INCORRECT_ADDRESS) {
        struct instr_t inst;
        inst.opcode = JMP;
        inst.ope1   = main_addr;

        instrs_buf[0] = inst;
    } else {
        log_error("No main method found.");
        exit(EXIT_FAILURE);
    }

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
            case POP:
                fprintf(output, "POP 0x%x\n", inst.ope1);
                break;
            case PUSH:
                fprintf(output, "PUSH 0x%x\n", inst.ope1);
                break;
            case JMPC:
                fprintf(output, "JMPC 0x%x, R%d\n", inst.ope1, inst.ope2);
                break;
            default:
                log_warning(1, "Unexpected generated instruction. Ignoring.");
            }
            i ++;
        }
    } else
        fwrite(instrs_buf, sizeof(struct instr_t), next_instr_index, output);
}

void asm_output_close()
{
    if(output != stdout)
        fclose(output);
}
