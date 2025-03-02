%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define P 1234577

int yywrap() { return 1; }
int yylex();
void yyerror(const char *s);

int cut_to_p(int a);

int add_p(int a, int b);
int sub_p(int a, int b);
int mul_p(int a, int b);
int div_p(int a, int b);
int pow_p(int a, int b);
int opp_p(int a);
int inv_p(int a);

int ext_euclides(int a, int b);

char polish_exp[1000] = "";

void add_to_pl(char* token) {
    strcat(polish_exp, token);
    strcat(polish_exp, " ");
}

void add_to_pl_num(int num) {
    char temp[50];
    sprintf(temp, "%d", num);
    strcat(polish_exp, temp);
    strcat(polish_exp, " ");
}
%}

%define parse.error verbose

%token NUMBER
%token PLUS MINUS MUL DIV POW
%token OPBRA CLBRA
%left PLUS MINUS
%left MUL DIV
%left POW
%right UMINUS
%start input  

%%

input: 
    %empty
    | input line
    ;

line:
    '\n'                              
    | expression '\n'                  { printf("%s\n", polish_exp); printf("Wynik: %d\n", $1); memset(polish_exp, 0, sizeof(polish_exp));}
    | error '\n'                        {memset(polish_exp, 0, sizeof(polish_exp));}
    ;

expression:
    number                            {  $$ = $1;  add_to_pl_num($$);}
    | expression PLUS expression       { $$ = add_p($1, $3); sprintf(polish_exp + strlen(polish_exp), "+ "); }
    | expression MINUS expression       { $$ = sub_p($1, $3); sprintf(polish_exp + strlen(polish_exp), "- "); }
    | expression MUL expression       { $$ = mul_p($1, $3); sprintf(polish_exp + strlen(polish_exp), "* "); }
    | expression DIV expression       { $$ = div_p($1, $3); sprintf(polish_exp + strlen(polish_exp), "/ ");}
    | expression POW pow_number       { $$ = pow_p($1, $3); sprintf(polish_exp + strlen(polish_exp), "^ "); }
    | OPBRA expression CLBRA              { $$ = $2; }
    ;

pow_number:
    NUMBER                            { $$ = cut_to_p($1); add_to_pl_num($$); }
    | MINUS NUMBER %prec UMINUS         { $$ = opp_p(1) - $2; add_to_pl_num($$); }
    ;

number:
    NUMBER                            { 
        $$ = cut_to_p($1);
    }
    | MINUS NUMBER %prec UMINUS     {
        $$ = opp_p($2);
    }
    ;


%%

int cut_to_p(int a) {
    return (a%P + P) % P;
}

int add_p(int a, int b) { 
    return cut_to_p(cut_to_p(a) + cut_to_p(b)); 
}

int sub_p(int a, int b) { 
    return cut_to_p(cut_to_p(a) + opp_p(b)); 
}

int mul_p(int a, int b) {
    long long res = (long long) a*b;
    return (res+P) % P;
}

int ext_euclides(int a, int b) {
    int old_r = a, r = b;
    int old_s = 1, s = 0;
    int old_t = 0, t = 1;

    while (r != 0) {
        int quotient = old_r / r;

        int temp = r;
        r = old_r - quotient * r;
        old_r = temp;

        temp = s;
        s = old_s - quotient * s;
        old_s = temp;

        temp = t;
        t = old_t - quotient * t;
        old_t = temp;
    }

    if (old_s < 0) {
        old_s += P;
    }

    return old_s;
}

int inv_p(int a) {
    int x = ext_euclides(a, P);
    return (x%P + P) % P;
}

int div_p(int a, int b) { 
    if (a == 0) {
        return 0;
    }

    int inv_b = inv_p(b);

    if(a == 1) {
        return inv_b;
    }
    return mul_p(a, inv_b); 
}

int pow_p(int a, int pow) {
    
    if (pow == 0){
        return 1;
    }

    if (pow == 1) {
        return a;
    }

    int result = 1;
    int base = cut_to_p(a);

    while (pow > 0) {
        if (pow % 2 == 1) {
            result = mul_p(result, base);
        }

        base = mul_p(base, base);
        pow /= 2;
    }

    return result;
}

int opp_p(int a) {
    return P - (cut_to_p(a));
}

void yyerror(const char *s) {
    fprintf(stderr, "ERROR!!!!!!!: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
