%{
#include "parsing_common.h"
#include "y.tab.h"
%}

D                       [0-9]
E                       [Ee][-+]?{D}+
%%
main                    return tMAIN;
[{]                     return tOPEN_BRACKET;
[}]                     return tCLOSE_BRACKET;
const                   return tCONST;
int                     return tINT;
float                   return tFLOAT;
for                     return tFOR;
while                   return tWHILE;
,                       return tCOMMA;
[+]                     return tADD;
[-]                     return tSUB;
[*]                     return tMUL;
[/]                     return tDIV;
[=]                     return tEQUAL;
[(]                     return tOPEN_PARENTHESIS;
[)]                     return tCLOSE_PARENTHESIS;
[;]                     return tEND_LINE;
printf                  return tPRINTF;
{D}+                    |
{D}+{E}                 return tINTEGER;
[a-zA-Z_][a-zA-Z0-9_]*  {
                            yylval=strdup(yytext);
                            return tVARIABLE_NAME;
                        }
[ \n\t]                 ;
