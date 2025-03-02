# Ewa Kasprzak 272356

using JuMP, GLPK

# Dane z tabeli
K = 4  # liczba okresów
c = [6000, 4000, 8000, 9000]  # koszt normalnej produkcji na jednostkę
a = [60, 65, 70, 60]          # maksymalna nadprodukcja
o = [8000, 6000, 10000, 11000]  # koszt nadprodukcji na jednostkę
d = [130, 80, 125, 195]       # zapotrzebowanie na towar w każdym okresie
storage_cost = 1500           # koszt magazynowania na jednostkę

# Początkowy stan magazynowy
initial_storage = 15

# Model optymalizacyjny
model = Model(GLPK.Optimizer)

# Zmienne decyzyjne
@variable(model, 0 <= x[1:K] <= 100)         # produkcja normalna
@variable(model, 0 <= y[i=1:K] <= a[i])           # produkcja ponadwymiarowa
@variable(model, 0 <= s[1:K] <= 70)          # stan magazynu na koniec okresu

# Ograniczenia zapotrzebowania
# Dla okresu 1, z uwzględnieniem początkowego stanu magazynowego
@constraint(model, x[1] + y[1] + initial_storage == d[1] + s[1])

# Dla kolejnych okresów
for j in 2:K
    @constraint(model, x[j] + y[j] + s[j-1] == d[j] + s[j])
end

# Funkcja celu - minimalizacja kosztów
@objective(model, Min, sum(c[j] * x[j] + o[j] * y[j] + storage_cost * s[j] for j in 1:K))

# Rozwiązanie modelu
optimize!(model)

# Wyniki
total_cost = objective_value(model)
production_normal = value.(x)
production_over = value.(y)
storage_end = value.(s)

println("Minimalny łączny koszt: $total_cost")
println("Produkcja normalna w kolejnych okresach: $production_normal")
println("Produkcja ponadwymiarowa w kolejnych okresach: $production_over")
println("Stan magazynowy na koniec każdego okresu: $storage_end")

# Odpowiedzi na pytania:
# (a) Minimalny łączny koszt produkcji i magazynowania towaru
println("Minimalny łączny koszt produkcji i magazynowania towaru: $total_cost")

# (b) Okresy, w których firma musi zaplanować produkcję ponadwymiarową
for j in 1:K
    if production_over[j] > 0
        println("Produkcja ponadwymiarowa jest zaplanowana w okresie: $j")
    end
end

# (c) Okresy, w których możliwości magazynowania towaru są wyczerpane
for j in 1:K
    if storage_end[j] == 70
        println("Magazynowanie jest wyczerpane w okresie: $j")
    end
end
