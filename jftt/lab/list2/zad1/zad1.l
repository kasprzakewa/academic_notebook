%{
#include <stdio.h>

int line_count = 0;
int word_count = 0;
%}

%%
^[ \t]*$             
^[ \t]+               
[ \t]+                  { putchar(' '); } 
[^ \t\n]+               {
                            word_count++; 
                            printf("%s", yytext); 
                        }
\n                      {
                            putchar('\n'); 
                            line_count++;
                        }

%%

int yywrap() { return 1; }

int main(int argc, char **argv)
{

    yylex();
    printf("\nLines: %d\n", line_count);
    printf("Words: %d\n", word_count);

    return 0;
}
