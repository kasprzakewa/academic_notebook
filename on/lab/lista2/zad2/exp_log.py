# Ewa Kasprzak
# 272356
# zadanie 2 - python

import numpy as np
import matplotlib.pyplot as plt
import sympy as sp

# Definicja funkcji f(x)
def f(x):
    return np.exp(x) * np.log(1 + np.exp(-x))

# Definicja zmiennej x
x = sp.symbols('x')
f_sym = sp.exp(x) * sp.log(1 + sp.exp(-x))
limit_result = sp.limit(f_sym, x, sp.oo)
print(f'lim x->inf f(x) = {limit_result}')

# Przedział, na którym chcemy wyświetlić wykres, np. od -10 do 10
a, b = -6, 66
x_values = np.linspace(a, b, 1000)  # Generowanie 1000 punktów na przedziale [a, b]

# Obliczenie wartości funkcji dla każdego x w przedziale
y_values = f(x_values)

# Rysowanie wykresu
plt.plot(x_values, y_values, label=r"$f(x) = e^x \cdot \ln(1 + e^{-x})$")
plt.xlabel("x")
plt.ylabel("f(x)")
plt.title("Wykres funkcji $f(x) = e^x \cdot \ln(1 + e^{-x})$")
plt.legend()
plt.grid()
plt.show()
