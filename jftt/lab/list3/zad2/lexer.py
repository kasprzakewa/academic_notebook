import ply.lex as lex
import ply.yacc as yacc

tokens = (
    'NUMBER',
    'PLUS', 'MINUS', 'MUL', 'DIV', 'POW',
    'OPBRA', 'CLBRA'
)

t_PLUS = r'\+'
t_MINUS = r'-'
t_MUL = r'\*'
t_DIV = r'/'
t_POW = r'\^'
t_OPBRA = r'\('
t_CLBRA = r'\)'

polish_exp = []

def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

t_ignore = ' \t'

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_comment(t):
    r'\#.*'
    pass

def t_error(t):
    global polish_exp
    print(f"Nieznany znak: {t.value[0]}")
    polish_exp.clear()
    t.lexer.skip(1)

lexer = lex.lex()

P = 1234577

def cut_to_p(a):
    return (a % P + P) % P

def add_p(a, b):
    return cut_to_p(cut_to_p(a) + cut_to_p(b))

def sub_p(a, b):
    return cut_to_p(cut_to_p(a) + opp_p(b))

def mul_p(a, b):
    res = (a * b) % P
    return res

def inv_p(a):
    return ext_euclides(a, P)

def ext_euclides(a, b):
    old_r, r = a, b
    old_s, s = 1, 0
    old_t, t = 0, 1

    while r != 0:
        quotient = old_r // r
        old_r, r = r, old_r - quotient * r
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t

    if old_s < 0:
        old_s += P
    return old_s

def div_p(a, b):
    inv_b = inv_p(b)
    return mul_p(a, inv_b)

def pow_p(a, pow):
    if pow == 0:
        return 1
    if pow == 1:
        return a

    result = 1
    base = cut_to_p(a)

    while pow > 0:
        if pow % 2 == 1:
            result = mul_p(result, base)
        base = mul_p(base, base)
        pow //= 2

    return result

def opp_p(a):
    return P - (cut_to_p(a))

precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'MUL', 'DIV'),
    ('left', 'POW'),
    ('right', 'UMINUS')
)

def p_input(p):
    '''input : input line
             | '''
    pass

def p_line(p):
    'line : expression'
    global polish_exp
    print(f"{''.join(polish_exp).strip()}")
    print(f"Wynik: {p[1]}")
    polish_exp.clear()

def p_expression_binop(p):
    '''expression : expression PLUS expression
                  | expression MINUS expression
                  | expression MUL expression
                  | expression DIV expression
                  | expression POW pow_expression'''
    global polish_exp
    if p[2] == '+':
        p[0] = add_p(p[1], p[3])
        polish_exp.append(f"+ ")
    elif p[2] == '-':
        p[0] = sub_p(p[1], p[3])
        polish_exp.append(f"- ")
    elif p[2] == '*':
        p[0] = mul_p(p[1], p[3])
        polish_exp.append(f"* ")
    elif p[2] == '/':
        p[0] = div_p(p[1], p[3])
        polish_exp.append(f"/ ")
    elif p[2] == '^':
        p[0] = pow_p(p[1], p[3])
        polish_exp.append(f"^ ")

def p_expression_number(p):
    '''expression : NUMBER
                    | MINUS NUMBER %prec UMINUS'''
    global polish_exp
    if len(p) == 2:
        p[0] = cut_to_p(p[1])
        polish_exp.append(f"{p[0]} ")
    else:
        p[0] = opp_p(p[2])
        polish_exp.append(f"{p[0]} ")

def p_pow_expression_minus(p):
    '''pow_expression : MINUS NUMBER %prec UMINUS'''
    global polish_exp
    p[0] = opp_p(1) - p[2]
    polish_exp.append(f"{p[0]} ")

def p_pow_expression_number(p):
    'pow_expression : NUMBER'
    global polish_exp
    p[0] = p[1]
    polish_exp.append(f"{p[0]} ")

def p_expression_group(p):
    'expression : OPBRA expression CLBRA'
    p[0] = p[2]

def p_error(p):
    global polish_exp
    print("Błąd składniowy!")
    polish_exp.clear()

parser = yacc.yacc()

def parse_input(data):
    lexer.input(data)
    parser.parse(data)

if __name__ == "__main__":
    while True:
        try:
            data = input()
            if data == "exit":
                break
            parse_input(data)
        except EOFError:
            break
