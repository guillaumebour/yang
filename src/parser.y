%{
#include <stdio.h>
#include <stdlib.h>
#include "logs.h"
#include "asm_output.h"
#include "logs.h"
#include "options.h"

int yylex(void);
void yyerror(char *);
%}

%union {
    int nb;
    char *str;
}

%token tIDENTIFIER '{' '}' tCONST tINT '+' '-' '*' '/'
%token '=' '(' ')' tNEW_LINE ';' tPRINTF
%token tINTEGER tDELIMITER tWHILE tFOR ',' tFLOAT '&'
%token tIF tELSE tRETURN ':' tSWITCH tCASE

%right '='
%left  '+' '-'
%left  '*' '/'

%type <str> tINT tIDENTIFIER
%type <nb>  tINTEGER expr_statement selection_statement_base

%nonassoc tNO_ELSE
%nonassoc tELSE
%%

external_declaration: declarations function_definitions

function_definition: tIDENTIFIER '(' ')'
    {
        st_push($1, FUNCTION);
        add_function_entry($1);
    } compound_statement;
function_definitions:
    | function_definitions function_definition
    ;

type: tINT
    | tFLOAT
    {};

expr_statement: expr_statement '+' expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_ADD (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | expr_statement '-' expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_SUB (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | expr_statement '*' expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_MUL (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | expr_statement '/' expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_DIV (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | '(' expr_statement ')'
    {
        $$ = $2;
    }
              | tIDENTIFIER
    {
        addr_t addr = st_search($1, INTEGER);
        if(addr != INCORRECT_ADDRESS) {
            $$ = addr;
        } else {
            log_error("Variable %s non définie", $1);
        }
    }
              | '&' tIDENTIFIER
    {
        addr_t addr_addr = st_search($2, INTEGER);
        if(addr_addr != INCORRECT_ADDRESS) {
            addr_t addr = st_new_tmp();
            asm_output_append_AFC(R0,        addr_addr);
            asm_output_append_STR(addr,      R0);
            $$ = addr;
        } else {
            log_error("Variable %s non définie", $2);
        }
    }
              | tINTEGER
    {
        int val = $1;
        addr_t addr = st_new_tmp();
        asm_output_append_AFC(R0,   val);
        asm_output_append_STR(addr, R0);
        $$ = addr;
    }
    ;
assignment_statement: tIDENTIFIER '=' expr_statement
    {
        addr_t addr = st_search($1, INTEGER);
        if(addr != INCORRECT_ADDRESS) {
            asm_output_append_LOAD(R0,   $3);
            asm_output_append_STR (addr, R0);
        } else {
            log_error("Variable %s non définie", $1);
        }
    };
selection_statement_base: tIF '(' expr_statement ')'
    {
        $<nb>$ = asm_output_append_PLCHLDR();
    } statement
    { $$ = $<nb>5; }
    ;
selection_statement: selection_statement_base %prec tNO_ELSE
    {
        asm_output_replace($1, JMPC, asm_output_next_addr(), 0, IGN);
    }
                   | selection_statement_base tELSE
    {
        $<nb>$ = asm_output_append_PLCHLDR();
        asm_output_replace($1, JMPC, asm_output_next_addr(), 0, IGN);
    } statement
    {
        asm_output_replace($<nb>3, JMP, asm_output_next_addr(), IGN, IGN);
    }
    ;
iteration_statement: tWHILE '(' expr_statement ')'
    {
        $<nb>$ = asm_output_append_PLCHLDR();
    } statement
    {
        asm_output_append_JMP($<nb>5);
        asm_output_replace($<nb>5, JMPC, asm_output_next_addr(), 0, IGN);
    }
    ;

scope_begin: '{'
    {
        st_enter_scope();
    };
scope_end: '}'
    {
        st_leave_scope();
    };
compound_statement: scope_begin declarations statements scope_end
    ;
return_statement: tRETURN expr_statement ';'
    {
        asm_output_append_POP(PC);
    }
call_statement: tIDENTIFIER '(' ')'
    {
        instr_index_t addr = search_function($1);

        if(addr != INCORRECT_ADDRESS) {
            asm_output_append_PUSH(PC);
            asm_output_append_JMP(addr);
        } else {
            log_error("Incorrect address for function '%s'", $1);
        }
    }


statement: expr_statement         ';'
         | assignment_statement   ';'
         | compound_statement
         | selection_statement
         | iteration_statement
         | return_statement
         | call_statement         ';'
         | ';'
    ;
statements:
          | statements statement
    ;

declaration: type initializers   ';'
    ;
declarations:
            | declarations declaration
    ;

initializer: tIDENTIFIER
    {
        st_push($1, INTEGER);
    }
    ;
initializers: initializer ',' initializers
            | initializer
    ;
%%
int main(int argc, char *argv[]) {
    st_init();
    asm_output_init();
    if(handle_args(argc, argv)) {
       return EXIT_FAILURE;
    }
    yyparse();
    asm_output_dump();
    asm_output_close();

    return EXIT_SUCCESS;
}

void yyerror(char *p) { log_error("%s", p); }

void yywrap() {}
