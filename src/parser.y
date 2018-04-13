%{
#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"
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

%token tMAIN tOPEN_BRACKET tCLOSE_BRACKET tCONST tINT tADD tSUB tMUL tDIV
%token tEQUAL tOPEN_PARENTHESIS tCLOSE_PARENTHESIS tNEW_LINE tEND_LINE tPRINTF
%token tINTEGER tVARIABLE_NAME tDELIMITER tWHILE tFOR tCOMMA tFLOAT tAMPERSAND
%token tIF tELSE tRETURN tCOLON tSWITCH tCASE

%right tEQUAL
%left  tADD tSUB
%left  tMUL tDIV

%type <str> tINT tVARIABLE_NAME
%type <nb>  tINTEGER expr_statement 

%nonassoc tNO_ELSE
%nonassoc tELSE
%%

main: tMAIN tOPEN_PARENTHESIS tCLOSE_PARENTHESIS compound_statement
    ;

type: tINT
    | tFLOAT
    {};

expr_statement: expr_statement tADD expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_ADD (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | expr_statement tSUB expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_SUB (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | expr_statement tMUL expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_MUL (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | expr_statement tDIV expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output_append_LOAD(R1,  $1);
        asm_output_append_LOAD(R2,  $3);
        asm_output_append_DIV (R0,  R1, R2);
        asm_output_append_STR (tmp, R0);
        $$ = tmp;
    }
              | tOPEN_PARENTHESIS expr_statement tCLOSE_PARENTHESIS
    {
        $$ = $2;
    }
              | tVARIABLE_NAME
    {
        addr_t addr = st_search($1);
        if(addr != INCORRECT_ADDRESS) {
            $$ = addr;
        } else {
            log_error("Variable %s non définie", $1);
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
assignment_statement: tVARIABLE_NAME tEQUAL expr_statement
    {
        addr_t addr = st_search($1);
        if(addr != INCORRECT_ADDRESS) {
            asm_output_append_LOAD(R0,   $3);
            asm_output_append_STR (addr, R0);
        } else {
            log_error("Variable %s non définie", $1);
        }
    };
selection_statement_base: tIF tOPEN_PARENTHESIS expr_statement tCLOSE_PARENTHESIS
    {
        asm_output_append_jmpc_placeholder();
    } statement
    {
        asm_output_resolve_last_jmpc();
    }
    ;
selection_statement: selection_statement_base %prec tNO_ELSE
                   | selection_statement_base tELSE statement
    ;

scope_begin: tOPEN_BRACKET
    {
        st_enter_scope();
    };
scope_end: tCLOSE_BRACKET
    {
        st_leave_scope();
    };
compound_statement: scope_begin declarations statements scope_end
    ;

statement: expr_statement         tEND_LINE
         | assignment_statement   tEND_LINE
         | compound_statement
         | selection_statement
         | tEND_LINE
    ;
statements:
          | statements statement
    ;

declaration: type initializers   tEND_LINE
    ;
declarations:
            | declarations declaration
    ;

initializer: tVARIABLE_NAME
    {
        st_push($1);
    }
    ;
initializers: initializer tCOMMA initializers
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

void yyerror(char *p) {}

void yywrap() {}
