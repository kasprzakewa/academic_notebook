%{
#include "parser.h"

extern int yylex();
%}

%%

"#"([^\\\n]*(\\\n)?)*\n
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[ \t]       ; 
\n          { return '\n'; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"^"         { return POW; }
"("         { return OPBRA; }
")"         { return CLBRA; }
.           { printf("Nieznany znak: %s\n", yytext); }
%%