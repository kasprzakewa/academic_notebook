# Ewa Kasprzak 272356

using JuMP
using GLPK

# Funkcja znajdująca wartość t. że x * (1.0 / x) != 1.0
function find_weird_nmb()
    nmb = 3.0  # Inicjalizacja liczby jako 3.0
    # Pętla, która znajduje liczbę, dla której nmb * (1.0 / nmb) nie jest równe 1.0
    while nmb * (1.0 / nmb) == 1.0
        nmb = prevfloat(nmb)  # Przejście do poprzedniej liczby zmiennoprzecinkowej
    end
    
    return nmb  # Zwrócenie znalezionej liczby
end

function optimize_path(N, A, c, t, i_start, j_end, T, x_value)
    model = Model(GLPK.Optimizer)

    if x_value == 1.0
        @variable(model, x[i in N, j in N], Bin)
    else
        # Zmienna ciągła x[i, j], która przyjmuje wartości od 0 do x_value
        @variable(model, 0 <= x[i in N, j in N] <= x_value)

        # Zmienna pomocnicza y[i, j] - zmienna binarna, która będzie służyć do wymuszenia wartości 0 lub x_value
        @variable(model, y[i in N, j in N], Bin)

        # Ograniczenie, które wymusza, że x[i,j] = 0 lub x[i,j] = x_value
        @constraint(model, [i in N, j in N], x[i, j] <= x_value * y[i, j])
    end    

    @objective(model, Min, sum((1.0 / x_value) * x[i, j] * c[i, j] for (i, j) in A))

    for j in N
        if j != i_start && j != j_end
            @constraint(model, sum(x[i, j] for i in N if (i, j) in A) == sum(x[j, k] for k in N if (j, k) in A))
        end
    end

    @constraint(model, (sum(x[i_start, j] for j in N if (i_start, j) in A) - sum(x[j, i_start] for j in N if (j, i_start) in A)) == x_value)

    @constraint(model, (sum(x[i, j_end] for i in N if (i, j_end) in A) - sum(x[j_end, i] for i in N if (j_end, i) in A)) == x_value)

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        println("Minimalny koszt przejazdu: ", objective_value(model))
        println("Wybrane połączenia:")
        for (i, j) in A
            if value(x[i, j]) > x_value / 2
                println("Miasto $i -> Miasto $j: koszt = $(c[(i, j)]), czas = $(t[(i, j)])")
            end
        end
    else
        println("Nie znaleziono optymalnego rozwiązania.")
    end
end

N = 1:10
A = [
    (1, 2), (1, 3), (1, 4), (1, 5), (2, 3), (3, 4), (3, 5), (3, 10),
    (4, 5), (4, 7), (5, 6), (5, 7), (5, 10), (6, 1), (6, 7), (6, 10),
    (7, 3), (7, 8), (7, 9), (8, 9), (9, 10)
]

c = Dict(
    (1, 2) => 3, (1, 3) => 4, (1, 4) => 7, (1, 5) => 8, (2, 3) => 2,
    (3, 4) => 4, (3, 5) => 2, (3, 10) => 6, (4, 5) => 1, (4, 7) => 3,
    (5, 6) => 5, (5, 7) => 3, (5, 10) => 5, (6, 1) => 5, (6, 7) => 2,
    (6, 10) => 7, (7, 3) => 4, (7, 8) => 3, (7, 9) => 1, (8, 9) => 1,
    (9, 10) => 2
)

t = Dict(
    (1, 2) => 4, (1, 3) => 9, (1, 4) => 10, (1, 5) => 12, (2, 3) => 3,
    (3, 4) => 6, (3, 5) => 2, (3, 10) => 11, (4, 5) => 1, (4, 7) => 5,
    (5, 6) => 6, (5, 7) => 3, (5, 10) => 8, (6, 1) => 8, (6, 7) => 2,
    (6, 10) => 11, (7, 3) => 6, (7, 8) => 5, (7, 9) => 1, (8, 9) => 2,
    (9, 10) => 2
)

T = 15
i_start = 1
j_end = 10

println("x = 1.0 -> poprawne rozwiązanie")
optimize_path(N, A, c, t, i_start, j_end, T, 1.0)

println("x = 0.5")
optimize_path(N, A, c, t, i_start, j_end, T, 0.5)

x = find_weird_nmb()
println("x = ", x)
optimize_path(N, A, c, t, i_start, j_end, T, x)