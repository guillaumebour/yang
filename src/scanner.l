%{
#include "parser.h"
%}

%option yylineno
D                       [0-9]
E                       [Ee][-+]?{D}+
%x COMMENT
%%
[{]                     return '{';
[}]                     return '}';
const                   return tCONST;
int                     return tINT;
float                   return tFLOAT;
for                     return tFOR;
while                   return tWHILE;
if                      return tIF;
else                    return tELSE;
[&]                     return '&';
return                  return tRETURN;
switch                  return tSWITCH;
case                    return tCASE;
[:]                     return ':';
,                       return ',';
[+]                     return '+';
[-]                     return '-';
[*]                     return '*';
[/]                     return '/';
[=]                     return '=';
[(]                     return '(';
[)]                     return ')';
[;]                     return ';';
printf                  return tPRINTF;
{D}+                    |
{D}+{E}                 {
                            yylval.nb = atoi(yytext);
                            return tINTEGER;
                        }
[a-zA-Z_][a-zA-Z0-9_]*  {
                            yylval.str = strdup(yytext);
                            return tIDENTIFIER;
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

