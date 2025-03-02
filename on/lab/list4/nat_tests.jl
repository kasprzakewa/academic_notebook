# Ewa Ksprzak
# 272356
# interpolacja funkcji - testowanie funkcji naturalna

include("Interpolation.jl")
using .Interpolation
using Polynomials
using Plots

# Lista liczby punktów węzłowych do testowania
n = [5, 10, 15]

# Definicja funkcji, którą będziemy interpolować
f1 = x -> sin(x)

# Przedział, na którym będziemy rysować wykresy
a = -5.0
b = 5.0

# Iteracja po liczbach punktów węzłowych (5, 10, 15)
for i in n
    local x1 = collect(range(a, b, length=i))  # Węzły interpolacji
    # Obliczanie wartości funkcji w punktach x1
    local y1 = f1.(x1)

    # Obliczanie ilorazów różnicowych na podstawie punktów x1 i y1
    local fx = Interpolation.ilorazyRoznicowe(x1, y1)
    # Obliczanie współczynników wielomianu naturalnego na podstawie ilorazów różnicowych
    local a_n = Interpolation.naturalna(x1, fx)
    
    # Tworzenie funkcji na podstawie współczynników wielomianu naturalnego
    f(x) = sum(c * x^(j-1) for (j, c) in enumerate(a_n))

    # Tworzenie gęstej siatki punktów x do rysowania wykresu
    local x = collect(range(a + (a / 50.0), b + (b / 50.0), length = 1000))

    # Obliczanie wartości wielomianu interpolacyjnego w punktach x
    y_values = [f(xi) for xi in x]
    
    # Tworzenie wykresu dla wielomianu interpolacyjnego
    local p = plot(x, y_values, label="Wielomian interpolacyjny", lw=1, color=:blue)
    plot!(p, x, f1.(x), label="Interpolowana funkcja", lw=1, color=:green)
    scatter!(p, x1, y1, label="Węzły interpolacji")

    # Zapisanie wykresu do pliku
    savefig("nat_$i.png")
end
