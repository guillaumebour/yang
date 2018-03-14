%{
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
for                     return tFOR;
while                   return tWHILE;
,                       return tCOMMA;
[+]                     return tPLUS;
[-]                     return tMINUS;
[*]                     return tMUL;
[/]                     return tDIV;
[=]                     return tEQUAL;
[(]                     return tOPEN_PARENTHESIS;
[)]                     return tCLOSE_PARENTHESIS;
[;]                     return tEND_LINE;
printf                  return tPRINTF;
{D}+                    |
{D}+{E}                 return tINTEGER;
[a-zA-Z_][a-zA-Z0-9_]*  return tVARIABLE_NAME;
[ \n\t]                 ;
