import sympy as sp
import numpy as np

def nth_derivative(function, variable, n):
    derivative = sp.diff(function, variable, n)
    return derivative

# Przykład użycia:
if __name__ == "__main__":
    x = sp.symbols('x')
    f = x**2 * sp.sin(x)
    a = nth_derivative(f, x, 16)
    print(a)
