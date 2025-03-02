# Ewa Kasprzak 272356

using JuMP
using GLPK

# Definiowanie modelu optymalizacji
model = Model(GLPK.Optimizer)

# Deklaracja zmiennych decyzyjnych (kg produktów)
@variable(model, x[1:4] >= 0)

# Definicja funkcji celu: maksymalizacja zysku
@objective(model, Max, 
    (9 * x[1] + 7 * x[2] + 6 * x[3] + 5 * x[4]) -  # Przychód
    (2 * ((5 * x[1] + 3 * x[2] + 4 * x[3] + 4 * x[4]) / 60) +   # Koszt pracy na M1
     2 * ((10 * x[1] + 6 * x[2] + 5 * x[3] + 2 * x[4]) / 60) +  # Koszt pracy na M2
     3 * ((6 * x[1] + 4 * x[2] + 3 * x[3] + 1 * x[4]) / 60)) -  # Koszt pracy na M3
    (4 * x[1] + 1 * x[2] + 1 * x[3] + 1 * x[4])                 # Koszt materiałów
)

# Ograniczenia czasowe dla maszyn
@constraint(model, 5 * x[1] + 3 * x[2] + 4 * x[3] + 4 * x[4] <= 3600)  # M1
@constraint(model, 10 * x[1] + 6 * x[2] + 5 * x[3] + 2 * x[4] <= 3600) # M2
@constraint(model, 6 * x[1] + 4 * x[2] + 3 * x[3] + 1 * x[4] <= 3600)  # M3

# Ograniczenia popytu
@constraint(model, x[1] <= 400)
@constraint(model, x[2] <= 100)
@constraint(model, x[3] <= 150)
@constraint(model, x[4] <= 500)

# Rozwiąż model
optimize!(model)

# Wyświetl wyniki
println("Optymalny plan produkcji:")
for i in 1:4
    println("x[$i] = ", value(x[i]), " kg")
end
println("Maksymalny zysk: ", objective_value(model), " dolarów")
