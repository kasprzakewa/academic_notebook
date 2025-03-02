# Ewa Kasprzak 272356

using JuMP
using GLPK

function optimize_path(N, A, c, t, i_start, j_end, T)
    # Model optymalizacyjny
    model = Model(GLPK.Optimizer)

    # Definiowanie zmiennych decyzyjnych x[i, j] ∈ {0, 1}
    @variable(model, x[i in N, j in N], Bin)


    # Funkcja celu: minimalizacja całkowitego kosztu przejazdu
    @objective(model, Min, sum(c[(i, j)] * x[i, j] for (i, j) in A))

    # Ograniczenie na czas przejazdu
    @constraint(model, sum(t[(i, j)] * x[i, j] for (i, j) in A) <= T)

    # Ograniczenia przepływu:
    # Dla każdego miasta j ≠ i_start i j_end, liczba krawędzi wchodzących powinna być równa liczbie wychodzących
    for j in N
        if j != i_start && j != j_end
            @constraint(model, sum(x[i, j] for i in N if (i, j) in A) == sum(x[j, k] for k in N if (j, k) in A))
        end
    end

    # Dla miasta początkowego liczba krawędzi wychodzących powinna być o 1 większa niż liczba wchodzących
    @constraint(model, (sum(x[i_start, j] for j in N if (i_start, j) in A) - sum(x[j, i_start] for j in N if (j, i_start) in A)) == 1)

    # Dla miasta końcowego liczba krawędzi wchodzących powinna być o 1 większa niż liczba wychodzących
    @constraint(model, (sum(x[i, j_end] for i in N if (i, j_end) in A) - sum(x[j_end, i] for i in N if (j_end, i) in A)) == 1)

    # Rozwiązanie problemu
    optimize!(model)

    # Wyświetlenie wyniku
    if termination_status(model) == MOI.OPTIMAL
        println("Minimalny koszt przejazdu: ", objective_value(model))
        println("Wybrane połączenia:")
        for (i, j) in A
            if value(x[i, j]) > 0.5
                println("Miasto $i -> Miasto $j: koszt = $(c[(i, j)]), czas = $(t[(i, j)])")
            end
        end
    else
        println("Nie znaleziono optymalnego rozwiązania.")
    end
end



# Dane problemu
N = 1:10  # Zbiór miast {1, ..., 10}
A = [
    (1, 2), (1, 3), (1, 4), (1, 5), (2, 3), (3, 4), (3, 5), (3, 10),
    (4, 5), (4, 7), (5, 6), (5, 7), (5, 10), (6, 1), (6, 7), (6, 10),
    (7, 3), (7, 8), (7, 9), (8, 9), (9, 10)
]

# Koszty przejazdu c[i, j] dla każdej krawędzi (i, j)
c = Dict(
    (1, 2) => 3, (1, 3) => 4, (1, 4) => 7, (1, 5) => 8, (2, 3) => 2,
    (3, 4) => 4, (3, 5) => 2, (3, 10) => 6, (4, 5) => 1, (4, 7) => 3,
    (5, 6) => 5, (5, 7) => 3, (5, 10) => 5, (6, 1) => 5, (6, 7) => 2,
    (6, 10) => 7, (7, 3) => 4, (7, 8) => 3, (7, 9) => 1, (8, 9) => 1,
    (9, 10) => 2
)

# Czas przejazdu t[i, j] dla każdej krawędzi (i, j)
t = Dict(
    (1, 2) => 4, (1, 3) => 9, (1, 4) => 10, (1, 5) => 12, (2, 3) => 3,
    (3, 4) => 6, (3, 5) => 2, (3, 10) => 11, (4, 5) => 1, (4, 7) => 5,
    (5, 6) => 6, (5, 7) => 3, (5, 10) => 8, (6, 1) => 8, (6, 7) => 2,
    (6, 10) => 11, (7, 3) => 6, (7, 8) => 5, (7, 9) => 1, (8, 9) => 2,
    (9, 10) => 2
)

T = 15  # Maksymalny czas przejazdu

# Miasta początkowe i końcowe
i_start = 1
j_end = 10

# Rozwiązanie problemu
# optimize_path(N, A, c, t, i_start, j_end, T)


A_prim = [
    (1, 7), (1, 6), (1, 2), (2, 8), (2, 5), 
    (3, 10), (3, 8), (4, 6), (5, 3), (6, 3), 
    (6, 10), (7, 4), (8, 9), (9, 10), (10, 1)
]

c_prim = Dict((1, 7) => 2, (1, 6) => 1, (1, 2) => 5, 
            (2, 8) => 5, (2, 5) => 10, (3, 10) => 2, 
            (3, 8) => 10, (4, 6) => 2, (5, 3) => 10, 
            (6, 3) => 2, (6, 10) => 1, (7, 4) => 2, 
            (8, 9) => 5, (9, 10) => 5, (10, 1) => 5)

t_prim = Dict((1, 7) => 1, (1, 6) => 20, (1, 2) => 1, 
            (2, 8) => 1, (2, 5) => 10, (3, 10) => 1, 
            (3, 8) => 20, (4, 6) => 1, (5, 3) => 10, 
            (6, 3) => 1, (6, 10) => 10, (7, 4) => 1, 
            (8, 9) => 1, (9, 10) => 1, (10, 1) => 8)

optimize_path(N, A_prim, c_prim, t_prim, i_start, j_end, T)