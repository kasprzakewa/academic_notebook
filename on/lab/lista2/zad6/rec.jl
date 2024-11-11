# Ewa Kasprzak
# 272356
# zadanie 6

using Plots

# Funkcja rekurencyjna
function rec(x, c, type)
    return type(x)^2 + type(c)
end

# Funkcja testująca
function test(x0, c, type, n_iter)
    x_values = Float64[]  # Lista do przechowywania wartości ciągu

    println("\\begin{table}[H]")
    println("\\centering")
    println("\\begin{tabular}{|c|c|}")
    println("\\hline")
    println("Iteracja & x \\\\")
    println("\\hline")
    

    x = x0  # Inicjalizacja zmiennej x
    for i in 1:n_iter
        
        x = rec(x, c, type)  # Obliczenie kolejnej wartości
        push!(x_values, x)  # Dodanie aktualnej wartości do listy
        println("$i & $x \\\\")
        println("\\hline")
    end

    println("\\end{tabular}")
    println("\\caption{Wartości ciągu dla c = $c, x0 = $x0}")
    println("\\label{tab:test_$c,$x0}")
    println("\\end{table}")

    
end

# Wykonanie eksperymentów z różnymi parametrami
println("Test 1")
println("c = -2, x0 = 1")
println("-----")
println()
test(1, -2, Float64, 40)  # c = -2, x0 = 1
println()
println("Test 2")
println("c = -2, x0 = 2")
println("-----")
println()
test(2, -2, Float64, 40)  # c = -2, x0 = 2
println()
println("Test 3")
println("c = -2, x0 = 1.99999999999999")
println("-----")
println()
test(1.99999999999999, -2, Float64, 40)  # c = -2, x0 = 1.99999999999999
println()
println("Test 4")
println("c = -1, x0 = 1")
println("-----")
println()
test(1, -1, Float64, 40)  # c = -1, x0 = 1
println()
println("Test 5")
println("c = -1, x0 = -1")
println("-----")
println()
test(-1, -1, Float64, 40)  # c = -1, x0 = -1
println()
println("Test 6")
println("c = -1, x0 = 0.75")
println("-----")
println()
test(0.75, -1, Float64, 40)  # c = -1, x0 = 0.75
println()
println("Test 7")
println("c = -1, x0 = 0.25")
println("-----")
println()
test(0.25, -1, Float64, 40)  # c = -1, x0 = 0.25
