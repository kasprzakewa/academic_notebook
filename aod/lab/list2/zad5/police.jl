# Ewa Kasprzak 272356

using JuMP
using GLPK

# Definicja danych
min_cars = [
    [2, 4, 3],  # Minimalna liczba radiowozów dla każdej zmiany w p1
    [3, 6, 5],  # Minimalna liczba radiowozów dla każdej zmiany w p2
    [5, 7, 6]   # Minimalna liczba radiowozów dla każdej zmiany w p3
]

max_cars = [
    [3, 7, 5],  # Maksymalna liczba radiowozów dla każdej zmiany w p1
    [5, 7, 10], # Maksymalna liczba radiowozów dla każdej zmiany w p2
    [8, 12, 10] # Maksymalna liczba radiowozów dla każdej zmiany w p3
]

# Minimalne wymagania na liczby radiowozów dla każdej zmiany
shift_requirements = [10, 20, 18]

# Minimalne wymagania na liczby radiowozów dla każdej dzielnicy
district_requirements = [10, 14, 13]

# Tworzenie modelu optymalizacji
model = Model(GLPK.Optimizer)

# Zmienna decyzyjna: liczba radiowozów przydzielonych do każdej dzielnicy i zmiany
@variable(model, x[i=1:3, j=1:3], Int)

# Ustawienie ograniczeń dla zmiennych decyzyjnych
for i in 1:3, j in 1:3
    set_lower_bound(x[i, j], min_cars[i][j])
    set_upper_bound(x[i, j], max_cars[i][j])
end

# Funkcja celu: minimalizacja całkowitej liczby radiowozów
@objective(model, Min, sum(x[i, j] for i in 1:3, j in 1:3))

# Ograniczenia dla każdej zmiany: minimalna liczba radiowozów
for j in 1:3
    @constraint(model, sum(x[i, j] for i in 1:3) >= shift_requirements[j])
end

# Ograniczenia dla każdej dzielnicy: minimalna liczba radiowozów
for i in 1:3
    @constraint(model, sum(x[i, j] for j in 1:3) >= district_requirements[i])
end

# Rozwiązanie modelu
optimize!(model)

# Wyświetlenie wyników
if termination_status(model) == MOI.OPTIMAL
    println("Optymalny przydział radiowozów:")
    local total_cars = 0
    for i in 1:3, j in 1:3
        println("Dzielnica p$i, zmiana $j: ", value(x[i, j]))
        total_cars += value(x[i, j])
    end
    println("Całkowita liczba radiowozów: $total_cars")
else
    println("Nie znaleziono optymalnego rozwiązania.")
end