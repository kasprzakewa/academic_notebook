%{
    #include <stdio.h>
    int doxygen = 0;
%}

without_star                                    [^*]
star                                            \*
without_star_and_slash                          [^*/]
slash                                           \/
without_newline                                 [^\n]
without_newline_and_quotation                   [^\n\"]
newline                                         \n
quotation_mark                                  \"

include                         ^#include.*{newline}?
string                          {quotation_mark}({without_newline_and_quotation}*(\\{newline})*)*{quotation_mark}{newline}?
inline_comment                  "/*"({without_star}*|{without_star}({without_star}*{star}+{without_star_and_slash}+{slash}*)?{star}*)"*/"{newline}?
inline_doc_star                 "/**"({without_star}*|({without_star}*{star}+{without_star_and_slash}+{slash}*)?{star}*)"*/"{newline}?
inline_doc_exlamation_mark      "/*!"({without_star}*|({without_star}*{star}+{without_star_and_slash}+{slash}*)?{star}*)"*/"{newline}?
oneline_doc_slash               {slash}{3}({without_newline}*(\\{newline})*)*{newline}?
oneline_doc_exclamation_mark    {slash}{2}!({without_newline}*(\\{newline})*)*{newline}?
oneline_comment                 {slash}{2}({without_newline}*(\\{newline})*)*{newline}?

%%

{include}                       { printf("%s", yytext); }

{string}                        { printf("%s", yytext); }

{inline_doc_star}               {
                                    if (doxygen) {
                                        printf("%s", yytext);
                                    } else {
                                        putchar(' ');
                                    }
                                }
                                
{inline_doc_exlamation_mark}    {
                                    if (doxygen) {
                                        printf("%s", yytext);
                                    } else {
                                        putchar(' ');
                                    }
                                }

{inline_comment}                { putchar(' '); }

{oneline_doc_slash}             {
                                    if (doxygen) {
                                        printf("%s", yytext);
                                    }
                                }

{oneline_doc_exclamation_mark}  {
                                    if (doxygen) {
                                        printf("%s", yytext);
                                    }
                                }

{oneline_comment}

%%


int yywrap() {
    return 1; 
}

int main(int argc, char** argv) {
    if (argc > 1 && strcmp(argv[1], "-d") == 0) {
        doxygen = 1;
    }
    yylex();
    return 0;
}