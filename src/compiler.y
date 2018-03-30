%{
#include <stdio.h>
#include "symbol_table.h"
#include "logs.h"
#include "asm_output.h"
#include "parsing_common.h"

int yylex(void);
void yyerror(char *);
%}

%token tMAIN tOPEN_BRACKET tCLOSE_BRACKET tCONST tINT tADD tSUB tMUL tDIV
%token tEQUAL tOPEN_PARENTHESIS tCLOSE_PARENTHESIS tNEW_LINE tEND_LINE tPRINTF
%token tINTEGER tVARIABLE_NAME tDELIMITER tWHILE tFOR tCOMMA tFLOAT

%right tEQUAL
%left  tADD tSUB
%left  tMUL tDIV

%%
main: tMAIN tOPEN_PARENTHESIS tCLOSE_PARENTHESIS compound_statement
    ;

type: tINT
    | tFLOAT
    {};

expr_statement: expr_statement tADD expr_statement
              | expr_statement tSUB expr_statement
              | expr_statement tMUL expr_statement
              | expr_statement tDIV expr_statement
              | tOPEN_PARENTHESIS expr_statement tCLOSE_PARENTHESIS
              | tVARIABLE_NAME
              | tINTEGER
    ;
assignment_statement: tVARIABLE_NAME tEQUAL expr_statement
    {
    };
compound_statement: tOPEN_BRACKET declarations statements tCLOSE_BRACKET
    {
        st_enter_scope();

        st_leave_scope();
    };

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

initializer_list: tVARIABLE_NAME
                | initializer_list tCOMMA tVARIABLE_NAME
    ;
%%
int main() {
    st_init();
    asm_output_init(NULL);
    yyparse();
    asm_output_close();
}
