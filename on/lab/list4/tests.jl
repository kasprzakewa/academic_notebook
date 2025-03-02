# Ewa Kasprzak
# 272356
# Interpolacja funkcji - testowanie

include("Interpolation.jl")
using .Interpolation

# Definicja funkcji do testowania:
f1(x) = exp(x)
f2(x) = x^2 * sin(x)
f3(x) = abs(x)
f4(x) = 1 / (1 + x^2)
f5(x) = sin(2x) + cos(2x - 1)
f6(x) = cos(x)

# Testowe przypadki, zawierające funkcję, przedział oraz liczbę punktów węzłowych:
# Każdy przypadek to krotka zawierająca funkcję, początkowy i końcowy punkt przedziału oraz listę liczb punktów węzłowych

test_cases = [
    # (f1, 0.0, 1.0, [5, 10, 15]),   # zad. 5 (a): Funkcja wykładnicza na przedziale [0.0, 1.0] z 5, 10, 15 punktami węzłowymi
    # (f2, -1.0, 1.0, [5, 10, 15]),  # zad. 5 (b): Funkcja x^2 * sin(x) na przedziale [-1.0, 1.0] z 5, 10, 15 punktami węzłowymi
    # (f3, -1.0, 1.0, [5, 10, 15]),  # zad. 6 (a): Funkcja wartości bezwzględnej na przedziale [-1.0, 1.0] z 5, 10, 15 punktami węzłowymi
    # (f4, -5.0, 5.0, [5, 10, 15])   # zad. 6 (b): Funkcja 1/(1+x^2) na przedziale [-5.0, 5.0] z 5, 10, 15 punktami węzłowymi
    (f6, 0.0, 1.0, [10])
]

# Funkcja uruchamiająca testy:
# `test_cases` - lista krotek, gdzie każda zawiera funkcję, przedział oraz liczbę punktów węzłowych.

function run_tests(test_cases)
    i = 1  # Licznik do numerowania plików wynikowych
    for (f, a, b, ns) in test_cases
        for n in ns
            rysujNnfx(f, a, b, n, "$i.png")
            i += 1  # Inkrementacja numeru pliku
        end
    end
end

# Uruchomienie testów na podstawie zdefiniowanych przypadków testowych
run_tests(test_cases)

