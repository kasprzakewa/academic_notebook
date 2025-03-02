# Ewa Kasprzak
# 272356
# moduł numeryczny

module NumericalMethods

export mbisekcji, mstycznych, msiecznych

"""
    mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)

Rozwiązuje równanie f(x) = 0 metodą bisekcji.

# Argumenty
- `f`: funkcja f(x) zadana jako anonimowa funkcja,
- `a`, `b`: końce przedziału początkowego,
- `delta`: dokładność dla zmiany argumentu,
- `epsilon`: dokładność dla wartości funkcji.

# Wyniki
Zwraca krotkę (r, v, it, err):
- `r`: przybliżenie pierwiastka,
- `v`: wartość f(r),
- `it`: liczba wykonanych iteracji,
- `err`: kod błędu (0 - brak błędu, 1 - funkcja nie zmienia znaku w przedziale).
"""
function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    # Sprawdzenie, czy funkcja zmienia znak w przedziale [a, b]
    fa, fb = f(a), f(b)
    if fa * fb > 0
        return (NaN, NaN, 0, 1)  # Kod błędu 1: funkcja nie zmienia znaku
    end

    it = 0
    while abs(b - a) > delta
        it += 1
        c = (a + b) / 2
        fc = f(c)

        # Sprawdzenie kryterium zakończenia
        if abs(fc) < epsilon
            return (c, fc, it, 0)  # Kod błędu 0: brak błędu
        end

        # Zawężanie przedziału
        if fa * fc < 0
            b, fb = c, fc
        else
            a, fa = c, fc
        end
    end

    # Zwrot przybliżonego wyniku
    c = (a + b) / 2
    return (c, f(c), it, 0)  # Kod błędu 0: brak błędu
end


"""
    mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)

Rozwiązuje równanie f(x) = 0 metodą Newtona (stycznych).

# Argumenty
- `f`: funkcja f(x) zadana jako anonimowa funkcja,
- `pf`: pochodna funkcji f(x) zadana jako anonimowa funkcja,
- `x0`: przybliżenie początkowe,
- `delta`: dokładność dla zmiany argumentu,
- `epsilon`: dokładność dla wartości funkcji,
- `maxit`: maksymalna dopuszczalna liczba iteracji.

# Wyniki
Zwraca krotkę (r, v, it, err):
- `r`: przybliżenie pierwiastka,
- `v`: wartość f(r),
- `it`: liczba wykonanych iteracji,
- `err`: kod błędu (0 - metoda zbieżna, 1 - przekroczono maxit iteracji, 2 - pochodna bliska zeru).
"""
function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    # Inicjalizacja zmiennych
    x = x0
    it = 0

    for i in 1:maxit
        it = i
        fx = f(x)
        pfx = pf(x)

        # Sprawdzenie, czy pochodna jest bliska zeru
        if abs(pfx) < epsilon
            return (NaN, NaN, it, 2)  # Kod błędu 2: pochodna bliska zeru
        end

        # Obliczenie nowego przybliżenia
        x_new = x - fx / pfx

        # Sprawdzenie kryteriów zakończenia
        if abs(x_new - x) < delta || abs(fx) < epsilon
            return (x_new, f(x_new), it, 0)  # Kod błędu 0: metoda zbieżna
        end

        # Aktualizacja przybliżenia
        x = x_new
    end

    # Jeśli przekroczono maksymalną liczbę iteracji
    return (x, f(x), it, 1)  # Kod błędu 1: nie osiągnięto wymaganej dokładności
end

"""
    msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)

Rozwiązuje równanie f(x) = 0 metodą siecznych.

# Argumenty
- `f`: funkcja f(x) zadana jako anonimowa funkcja,
- `x0`, `x1`: dwa początkowe przybliżenia,
- `delta`: dokładność dla zmiany argumentu,
- `epsilon`: dokładność dla wartości funkcji,
- `maxit`: maksymalna dopuszczalna liczba iteracji.

# Wyniki
Zwraca krotkę (r, v, it, err):
- `r`: przybliżenie pierwiastka,
- `v`: wartość f(r),
- `it`: liczba wykonanych iteracji,
- `err`: kod błędu (0 - metoda zbieżna, 1 - przekroczono maxit iteracji).
"""
function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    # Inicjalizacja zmiennych
    it = 0
    f_x0 = f(x0)
    f_x1 = f(x1)

    for i in 1:maxit
        it = i

        # Sprawdzenie, czy różnica w wartościach x jest zbyt mała
        if abs(x1 - x0) < delta
            return (x1, f_x1, it, 0)  # Metoda zbieżna
        end

        # Sprawdzenie kryteriów zakończenia
        if abs(f_x1) < epsilon
            return (x1, f_x1, it, 0)  # Metoda zbieżna
        end

        # Obliczenie nowego przybliżenia (metoda siecznych)
        denominator = f_x1 - f_x0
        if abs(denominator) < delta
            return (NaN, NaN, it, 1)  # Kod błędu 1: brak zbieżności
        end

        x_new = x1 - f_x1 * (x1 - x0) / denominator

        # Aktualizacja wartości
        x0, f_x0 = x1, f_x1
        x1, f_x1 = x_new, f(x_new)
    end

    # Jeśli przekroczono maksymalną liczbę iteracji
    return (x1, f_x1, it, 1)  # Kod błędu 1: nie osiągnięto wymaganej dokładności
end

end # module NumericalMethods

using .NumericalMethods