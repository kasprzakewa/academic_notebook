# Ewa Kasprzak 272356

using JuMP, GLPK, Plots

# Funkcja do rozwiązania problemu dla dowolnego k
function rozmieszczenie_kamer(m, n, kontenery, k)
    # Inicjalizacja modelu
    model = Model(GLPK.Optimizer)
    
    # Tworzenie zmiennych decyzyjnych x[i, j] dla każdej pozycji (i, j)
    @variable(model, x[1:m, 1:n], Bin)
    
    # Zakaz umieszczania kamer na kontenerach
    for (i, j) in kontenery
        @constraint(model, x[i, j] == 0)
    end

    # Ograniczenie widoczności: każda pozycja z kontenerem musi być monitorowana
    for (i, j) in kontenery
        visible_positions = []
        
        # Sprawdzamy każdy z czterech kierunków: góra, dół, lewo, prawo
        for di in [-1, 1]  # góra/dół
            blocked = false
            for step in 1:k
                ni = i + step * di
                if 1 <= ni <= m
                    if (ni, j) in kontenery
                        blocked = true
                    end
                    if !blocked && (ni, j) ∉ kontenery
                        push!(visible_positions, (ni, j))
                    end
                end
            end
        end
        
        for dj in [-1, 1]  # lewo/prawo
            blocked = false
            for step in 1:k
                nj = j + step * dj
                if 1 <= nj <= n
                    if (i, nj) in kontenery
                        blocked = true
                    end
                    if !blocked && (i, nj) ∉ kontenery
                        push!(visible_positions, (i, nj))
                    end
                end
            end
        end
        
        # Wymagamy, aby przynajmniej jedna z pozycji w visible_positions miała kamerę
        @constraint(model, sum(x[ni, nj] for (ni, nj) in visible_positions) >= 1)
    end

    # Funkcja celu: minimalizacja liczby kamer
    @objective(model, Min, sum(x[i, j] for i in 1:m, j in 1:n))

    # Rozwiązanie modelu
    optimize!(model)

    # Pobranie rozwiązania
    kamery = [(i, j) for i in 1:m, j in 1:n if value(x[i, j]) > 0.5]
    return kamery, objective_value(model)
end

function wizualizacja(m, n, k, kontenery, kamery)
    grid = fill(3.0, m, n)
    for (i, j) in kontenery
        grid[i, j] = 0.5
    end
    for (i, j) in kamery
        grid[i, j] = 1.5
    end
    heatmap(grid, c=:grays, title="Rozmieszczenie kamer i kontenerów", xlabel="N", ylabel="M", colorbar=false)
    savefig("kamery_kontenery_ext_$m=m_$n=n_$k=k.png")
end

# Przykładowe dane wejściowe
m, n = 6, 7
kontenery = [(1, 2), (1,3), (1,4), (1,5), (1, 6), (1, 7)]  # przykładowe pozycje kontenerów

# Testowanie dla dwóch różnych wartości k
k1 = 6
kamery_k1, liczba_kamer_k1 = rozmieszczenie_kamer(m, n, kontenery, k1)

println("Dla k = $k1: Kamery umieszczone na pozycjach $kamery_k1, liczba kamer = $liczba_kamer_k1")

# Wizualizacja
wizualizacja(m, n, k1, kontenery, kamery_k1)
