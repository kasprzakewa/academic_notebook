# Ewa Kasprzak
# 272356
# interpolacja funkcji

module Interpolation

export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx, rysujNat

using Plots

# Funkcja oblicza ilorazy różnicowe dla zadanych punktów
# x - wektor punktów węzłów, gdzie będzie obliczane przybliżenie
# f - wektor wartości funkcji w tych punktach
# Zwraca wektor obliczonych ilorazów różnicowych
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    n = length(x) - 1  # n to liczba węzłów - 1
    fx = copy(f)  # Kopia wartości funkcji f

    # Obliczanie ilorazów różnicowych w pętli
    for j in 2:n+1
        for i in n+1:-1:j
            # Obliczanie ilorazu różnicowego
            fx[i] = (fx[i] - fx[i-1]) / (x[i] - x[i-j+1])
        end
    end

    return fx  # Zwracamy obliczone ilorazy
end

# Funkcja oblicza wartość wielomianu Newtona w punkcie t
# x - wektor punktów węzłów
# fx - wektor ilorazów różnicowych
# t - punkt, w którym chcemy obliczyć wartość wielomianu Newtona
# Zwraca wartość interpolacji w punkcie t
function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    n = length(x)  # Liczba punktów węzłów
    nt = fx[n]  # Zaczynamy od ostatniego ilorazu różnicowego

    # Pętla odwrotna do obliczeń wartości interpolacji
    for i in (n-1):-1:1
        nt = fx[i] + (t - x[i]) * nt  # Rekurencyjne obliczenie wartości wielomianu
    end
    return nt  # Zwracamy wartość interpolacji
end

# Funkcja oblicza współczynniki wielomianu interpolacyjnego w formie naturalnej
# x - wektor punktów węzłów
# fx - wektor wartości funkcji w tych punktach
# Zwraca wektor współczynników wielomianu interpolacyjnego w postaci naturalnej
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    n = length(x)  # Liczba punktów węzłów
    a = copy(fx)  # Kopia wartości funkcji f

    for i in n-1:-1:1 
        for j in i:(n-1)
            a[j] = a[j] - x[i] * a[j+1]  # Aktualizacja współczynnika
        end
    end

    return a  # Zwracamy obliczone współczynniki
end

# Funkcja rysuje wykres dla wielomianu interpolacyjnego Newtona
# f - funkcja, która jest interpolowana
# a - początek przedziału
# b - koniec przedziału
# n - liczba węzłów, które będą użyte do interpolacji
# filename - nazwa pliku, do którego zostanie zapisany wykres
function rysujNnfx(f, a::Float64, b::Float64, n::Int, filename)
    h = (b - a) / n  # Obliczenie kroku (odległości między punktami węzłami)
    x = [a + k * h for k in 0:n]  # Węzły interpolacji (punktów x)
    y = [f(xk) for xk in x]  # Wartości funkcji w punktach x

    # Obliczanie ilorazów różnicowych
    fx = ilorazyRoznicowe(x, y)

    # Tworzymy wektor punktów do rysowania wykresu
    xs = range(a, b, length=500)  
    ys_interp = [warNewton(x, fx, t) for t in xs]  # Interpolacja Newtona
    ys_original = [f(t) for t in xs]  # Wartości oryginalnej funkcji

    # find max error for which x is the max error
    max_error = 0
    x_max_error = 0
    for i in 1:length(xs)
        error = abs(ys_interp[i] - ys_original[i])
        if error > max_error
            max_error = error
            x_max_error = xs[i]
        end
    end
    println("Max error: ", max_error, " for x = ", x_max_error)

    # Tworzymy wykres
    p = plot(xs, ys_interp, label="Wielomian interpolacyjny", lw=1, color=:blue)
    plot!(p, xs, ys_original, label="Funkcja interpolowana", lw=1, color=:green)
    scatter!(p, x, y, label="Węzły interpolacji")

    savefig(p, filename)  # Zapisanie wykresu do pliku
end

end
