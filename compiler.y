%{
#include <stdio.h>
#include "asm_output.h"

int yylex(void);
void yyerror(char *);
%}

%token tMAIN tOPEN_BRACKET tCLOSE_BRACKET tCONST tINT tPLUS tMINUS tMUL tDIV
%token tEQUAL tOPEN_PARENTHESIS tCLOSE_PARENTHESIS tNEW_LINE tEND_LINE tPRINTF
%token tINTEGER tVARIABLE_NAME tDELIMITER tWHILE tFOR tCOMMA

%right tEQUAL
%left  tPLUS tMINUS
%left  tMUL  tDIV

%%
main: tMAIN tOPEN_PARENTHESIS tCLOSE_PARENTHESIS bloc
    {
        printf("coucou");
        printf("%d\n", $1);
    };
bloc: tOPEN_BRACKET code tCLOSE_BRACKET
    {
    };
code: statement
    | code statement
    {
    };
statement: printf_call  tEND_LINE
         | expr         tEND_LINE
         | declarations tEND_LINE
    {
    };
printf_call: tPRINTF tOPEN_PARENTHESIS seq_of_vars tCLOSE_PARENTHESIS
    {
    };
declarations: tINT seq_of_vars
    {
    };
seq_of_vars: tVARIABLE_NAME
    | seq_of_vars tCOMMA tVARIABLE_NAME
    {
    };
expr: expr tEQUAL  expr
    | expr tPLUS  expr
    | expr tMINUS expr
    | expr tMUL   expr
    | expr tDIV   expr
    | tOPEN_PARENTHESIS expr tCLOSE_PARENTHESIS
    | tVARIABLE_NAME
    | tINTEGER
    {
        printf("Some code...");
    };
%%
int main() {
    asm_output_init(NULL);
    yyparse();
    asm_output_close();
}
