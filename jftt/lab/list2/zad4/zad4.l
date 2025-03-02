%{
    #include <iostream>
    #include <vector>
    #include <cmath>

    std::vector<int> numbers;
    int top = -1;
    bool error = false;
%}

%%
-?[0-9]+    {
                numbers.push_back(atoi(yytext)); 
                top += 1;
            }
"+"         {
                if (top < 1) {
                    fprintf(stderr, "Błąd: za mała liczba argumentów\n");
                    return 1;
                }

                int a = numbers[top];
                numbers.pop_back();
                int b = numbers[top - 1];
                numbers.pop_back();
                numbers.push_back(a + b);
                top -= 1;
            }
"-"         {
                if (top < 1) {
                    fprintf(stderr, "Błąd: za mała liczba argumentów\n");
                    return 1;
                }
                int a = numbers[top];
                numbers.pop_back();
                int b = numbers[top - 1];
                numbers.pop_back();
                numbers.push_back(b - a);
                top -= 1;
            }
"*"         {
                if (top < 1) {
                    fprintf(stderr, "Błąd: za mała liczba argumentów\n");
                    return 1;
                }
                int a = numbers[top];
                numbers.pop_back();
                int b = numbers[top - 1];
                numbers.pop_back();
                numbers.push_back(a * b);
                top -= 1;
            }
"/"         {
                if (top < 1) {
                    fprintf(stderr, "Błąd: za mała liczba argumentów\n");
                    return 1;
                }
                int a = numbers[top];
                numbers.pop_back();
                int b = numbers[top - 1];
                numbers.pop_back();
                numbers.push_back(b / a);
                top -= 1;
            }
"%"         {
                if (top < 1) {
                    fprintf(stderr, "Błąd: za mała liczba argumentów\n");
                    return 1;
                }
                int a = numbers[top];
                numbers.pop_back();
                int b = numbers[top - 1];
                numbers.pop_back();
                numbers.push_back(b % a);
                top -= 1;
            }
"^"         {
                if (top < 1) {
                    fprintf(stderr, "Błąd: za mała liczba argumentów\n");
                    return 1;
                }
                int a = numbers[top];
                numbers.pop_back();
                int b = numbers[top - 1];
                numbers.pop_back();
                numbers.push_back(pow(b, a));
                top -= 1;
            }
[ \t]+
\n          {
                for (int i = top; i >= 0; i--) {
                    std::cout << numbers[i] << std::endl;
                    numbers.pop_back();
                }
                top = 0;
}
.           {
                fprintf(stderr, "Błąd: zły symbol \"%s\"\n", yytext);
                return 1;
            }

%%
int yywrap() { 
    if (top != 0) {
        fprintf(stderr, "Błąd: za mała liczba operatorów\n");
        return 1;
    }
    for (int i = top; i >= 0; i--) {
        std::cout << numbers[i] << std::endl;

    }
    return 1; 
}

int main()
{
    yylex();
    return 0;
}