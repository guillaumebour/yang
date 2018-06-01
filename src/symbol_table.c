#include "symbol_table.h"

#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#define RAM_SIZE              0xFFFF
#define STACK_SIZE            0x00F0

#define SYMB_TAB_SIZE         256

struct stack_elem {
    identifier_t identifier;
    unsigned int scope_depth;
    addr_t       address;
    bool         temporary;
    vartype_t    type;
};

struct stack {
    struct stack_elem stack_array[SYMB_TAB_SIZE];
    unsigned int position;
    unsigned int current_scope_depth;
};

static struct stack symbol_table;

void st_init()
{
    symbol_table.current_scope_depth = 0;
    symbol_table.position = 0;
}

addr_t st_push(identifier_t name, vartype_t type)
{
    struct stack_elem new_elem;
    unsigned int name_length;

    name_length = strlen(name);

    new_elem.identifier = malloc(name_length * sizeof(char));
    strncpy(new_elem.identifier, name, name_length);
    new_elem.scope_depth = symbol_table.current_scope_depth;
    new_elem.address = RAM_SIZE - STACK_SIZE - symbol_table.position;
    new_elem.temporary = false;
    new_elem.type = type;

    symbol_table.stack_array[symbol_table.position] = new_elem;
    symbol_table.position ++;

    return new_elem.address;
}

addr_t st_peak(unsigned int index)
{
    if(symbol_table.position <= 0)
        return INCORRECT_ADDRESS;

    return symbol_table.stack_array[symbol_table.position-index].address;
}

addr_t st_pop()
{
    struct stack_elem top_elem;

    if(symbol_table.position <= 0)
        return INCORRECT_ADDRESS;

    top_elem = symbol_table.stack_array[symbol_table.position];

    addr_t ret = top_elem.address;
    free(top_elem.identifier);

    symbol_table.position --;

    return ret;
}

addr_t st_new_tmp()
{
    struct stack_elem new_elem;

    new_elem.identifier = "";
    new_elem.scope_depth = symbol_table.current_scope_depth;
    new_elem.address = RAM_SIZE - STACK_SIZE - symbol_table.position;
    new_elem.temporary = true;

    symbol_table.stack_array[symbol_table.position] = new_elem;
    symbol_table.position ++;

    return new_elem.address;
}

addr_t st_search(identifier_t name, vartype_t expected_type)
{
    int i = symbol_table.position-1;

    while(i >= 0) {
        struct stack_elem curr_elem;

        curr_elem = symbol_table.stack_array[i];

        if(strcmp(name, curr_elem.identifier) == 0 && curr_elem.type == expected_type)
            return curr_elem.address;

        i--;
    }

    return INCORRECT_ADDRESS;
}

void st_enter_scope()
{
    symbol_table.current_scope_depth++;
}

void st_leave_scope()
{
    while(symbol_table.position < SYMB_TAB_SIZE) {
        struct stack_elem top_elem = symbol_table.stack_array[symbol_table.position];

        if(top_elem.scope_depth == symbol_table.current_scope_depth)
            st_pop();
        else
            break;
    }

    symbol_table.current_scope_depth--;
}
