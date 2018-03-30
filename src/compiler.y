%{
#include <stdio.h>
#include "symbol_table.h"
#include "logs.h"
#include "asm_output.h"

int yylex(void);
void yyerror(char *);
%}

%union {
    int nb;
    char *str;
}

%token tMAIN tOPEN_BRACKET tCLOSE_BRACKET tCONST tINT tADD tSUB tMUL tDIV
%token tEQUAL tOPEN_PARENTHESIS tCLOSE_PARENTHESIS tNEW_LINE tEND_LINE tPRINTF
%token tINTEGER tVARIABLE_NAME tDELIMITER tWHILE tFOR tCOMMA tFLOAT

%right tEQUAL
%left  tADD tSUB
%left  tMUL tDIV

%type <str> tINT tVARIABLE_NAME
%type <nb>  tINTEGER expr_statement 
%%

main: tMAIN tOPEN_PARENTHESIS tCLOSE_PARENTHESIS compound_statement
    ;

type: tINT
    | tFLOAT
    {};

expr_statement: expr_statement tADD expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output("load r1, 0x%x\n", $1);                  
        asm_output("load r2, 0x%x\n", $3);
        asm_output("add r0, r1, r2\n");
        asm_output("str 0x%x, r0\n", tmp);
        $$ = tmp;                
    }
              | expr_statement tSUB expr_statement
    {
        addr_t tmp = st_new_tmp();
        asm_output("load r1, 0x%x\n", $1);                  
        asm_output("load r2, 0x%x\n", $3);
        asm_output("sub r0, r1, r2\n");
        asm_output("str 0x%x, r0\n", tmp);
        $$ = tmp;                
    }
              | expr_statement tMUL expr_statement
              | expr_statement tDIV expr_statement
              | tOPEN_PARENTHESIS expr_statement tCLOSE_PARENTHESIS
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
        asm_output("afc r0, #%d\n", val);
        asm_output("str 0x%x, r0\n", addr);
        $$ = addr;
    }
    ;
assignment_statement: tVARIABLE_NAME tEQUAL expr_statement
    {
        addr_t addr = st_search($1);
        if(addr != INCORRECT_ADDRESS) {
            asm_output("load r0, 0x%x\n", $3);
            asm_output("str 0x%x, r0\n", addr);
        } else {
            log_error("Variable %s non définie", $1);
        }
    };
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
         | assignment_statement tEND_LINE
         | compound_statement     tEND_LINE
         | tEND_LINE
    ;
statements:
          | statement
          | statements statement
    ;

declaration: type initializer_list   tEND_LINE
    ;
declarations:
            | declaration
            | declarations declaration
    ;

initializer_list: initializer_list tCOMMA initializer_list
                | tVARIABLE_NAME
    {
        st_push($1);
    }
    ;
%%
int main() {
    st_init();
    asm_output_init(NULL);
    yyparse();
    asm_output_close();
}
