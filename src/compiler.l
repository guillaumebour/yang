%{
#include "y.tab.h"
%}

D                       [0-9]
E                       [Ee][-+]?{D}+
%x COMMENT
%%
main                    return tMAIN;
[{]                     return tOPEN_BRACKET;
[}]                     return tCLOSE_BRACKET;
const                   return tCONST;
int                     return tINT;
float                   return tFLOAT;
for                     return tFOR;
while                   return tWHILE;
if                      return tIF;
else                    return tELSE;
[&]                     return tAMPERSAND;
return                  return tRETURN;
switch                  return tSWITCH;
case                    return tCASE;
[:]                     return tCOLON;
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
{D}+{E}                 {
                            yylval.nb = atoi(yytext);
                            return tINTEGER;
                        }
[a-zA-Z_][a-zA-Z0-9_]*  {
                            yylval.str = strdup(yytext);
                            return tVARIABLE_NAME;
                        }
[ \n\t]                 ;
\/\/.*$                 ;
<INITIAL>{
"/*"                   BEGIN(COMMENT);
}
<COMMENT>{
"*/"      BEGIN(INITIAL);
[^*\n]+
"*"
\n        yylineno++;
}

