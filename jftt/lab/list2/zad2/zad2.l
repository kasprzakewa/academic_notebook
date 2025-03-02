%{
#include <stdio.h>
#include <stdbool.h>
%}

%%
\"([^\"]*)*\"           { printf("%s", yytext); }
"--".*         
%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
    return 0;
}
