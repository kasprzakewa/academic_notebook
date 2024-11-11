# Ewa Kasprzak
# 272356
# zadanie 5

# Funkcja rekurencyjna modelu logistycznego
function rec(x, r, type)
    return type(x) + type(type(r) * type(x) * (type(1.0) - type(x)))
end

# Funkcja obcinająca wynik do n miejsc po przecinku
function truncate(x, n)
    return floor(x * 10^n) / 10^n
end

# Eksperyment 1: Porównanie wyników z obcięciem
function test1(p, r)
    x = Float32(p)  # Inicjalizacja wartości w Float32
    y = Float32(p)  # Inicjalizacja wartości w Float32
    println("\\begin{table}[H]")
    println("\\centering")
    println("\\begin{tabular}{|c|c|c|}")
    println("\\hline")
    println("Iteracja & Wynik bez obcięcia (Float32) & Wynik z obcięciem (Float32) \\\\")
    println("\\hline")
    for i in 1:40
        x = rec(x, r, Float32)  # Obliczenia w arytmetyce Float32
        y = rec(y, r, Float32)  # Obliczenia w arytmetyce Float32
    
        if i == 10  # Zastosowanie obcięcia po 10. iteracji
            x = truncate(x, 3)
        end
        println("$i & $x & $y \\\\")
        println("\\hline")
    end
    println("\\end{tabular}")
    println("\\caption{Porównanie wyników z obcięciem po 10 iteracjach w arytmetyce Float32}")
    println("\\label{tab:test1}")
    println("\\end{table}")
end

# Eksperyment 2: Porównanie wyników dla Float32 i Float64
function test2(p, r)
    x = Float32(p)  # Inicjalizacja w Float32
    y = Float64(p)  # Inicjalizacja w Float64
    println("\\begin{table}[H]")
    println("\\centering")
    println("\\begin{tabular}{|c|c|c|}")
    println("\\hline")
    println("Iteracja & Wynik w Float32 & Wynik w Float64 \\\\")
    println("\\hline")
    for i in 1:40
        x = rec(x, r, Float32)  # Obliczenia w arytmetyce Float32
        y = rec(y, r, Float64)  # Obliczenia w arytmetyce Float64
        println("$i & $x & $y \\\\")
        println("\\hline")
    end
    println("\\end{tabular}")
    println("\\caption{Porównanie wyników dla Float32 i Float64}")
    println("\\label{tab:test2}")
    println("\\end{table}")
end

# Parametry
p = 0.01  # Początkowa wielkość populacji
r = 3     # Współczynnik wzrostu

# Uruchomienie eksperymentów
println("Test 1: Porównanie z obcięciem")
test1(p, r)

println("\nTest 2: Porównanie wyników Float32 vs Float64")
test2(p, r)
