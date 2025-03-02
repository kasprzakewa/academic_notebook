# Ewa Kasprzak 272356

using JuMP
using GLPK  # Solver do problemów programowania liniowego

# Pojemności paliwowe każdej firmy
fuel_supply = [275000, 550000, 660000]

# Zapotrzebowanie na paliwo na każdym lotnisku
fuel_demand = [110000, 220000, 330000, 440000]

# Macierz kosztów w dolarach za galon dla każdej firmy do każdego lotniska
cost_matrix = [
    [10, 7, 8],   # Lotnisko 1
    [10, 11, 14], # Lotnisko 2
    [9, 12, 4],   # Lotnisko 3
    [11, 13, 9]   # Lotnisko 4
]

# Inicjalizuj model
model = Model(GLPK.Optimizer)

# Zdefiniuj zmienne decyzyjne x[i, j] (ilość paliwa dostarczonego przez firmę i do lotniska j)
@variable(model, x[1:3, 1:4] >= 0)

# Funkcja celu: Minimalizacja całkowitego kosztu dostawy
@objective(model, Min, sum(cost_matrix[j][i] * x[i, j] for i in 1:3, j in 1:4))

# Ograniczenia podaży: Każda firma ma maksymalną ilość paliwa, którą może dostarczyć
for i in 1:3
    @constraint(model, sum(x[i, j] for j in 1:4) <= fuel_supply[i])
end

# Ograniczenia popytu: Każde lotnisko wymaga określonej ilości paliwa
for j in 1:4
    @constraint(model, sum(x[i, j] for i in 1:3) == fuel_demand[j])
end

# Rozwiąż model
optimize!(model)

# Sprawdź, czy model został rozwiązany do optymalności
if termination_status(model) == MOI.OPTIMAL
    # Pobierz optymalne rozwiązanie
    total_cost = objective_value(model)
    fuel_plan = [value(x[i, j]) for i in 1:3, j in 1:4]

    # Odpowiedz na konkretne pytania
    # (a) Minimalny całkowity koszt
    println("Minimalny całkowity koszt dostawy paliwa: \$", total_cost)

    # (b) Sprawdź, czy wszystkie firmy dostarczają paliwo
    all_companies_used = [any(value(x[i, j]) > 0 for j in 1:4) for i in 1:3]
    println("Wszystkie firmy dostarczają paliwo:", all(all_companies_used))

    # (c) Sprawdź, czy pojemność dostaw każdej firmy jest wyczerpana
    supply_exhausted = [sum(value(x[i, j]) for j in 1:4) == fuel_supply[i] for i in 1:3]
    println("Wszystkie firmy wyczerpały swoją pojemność dostaw:", all(supply_exhausted))
    println("Status dostaw poszczególnych firm:", supply_exhausted)

    # Wyświetl optymalny plan dostawy paliwa
    println("Optymalny plan dostawy paliwa (w galonach):")
    for i in 1:3
        for j in 1:4
            println("Firma ", i, " do Lotniska ", j, ": ", value(x[i, j]), " galonów")
        end
    end
else
    println("Model nie został rozwiązany do optymalności.")
end