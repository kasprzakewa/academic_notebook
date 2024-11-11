#Ewa Kasprzak
#272356
#zadanie 1
#max

using PrettyTables

# Funkcja obliczająca maksymalną wartość dla danego typu
function compute_max(type)
    max = prevfloat(type(1))  # Inicjalizacja maksymalnej wartości jako poprzednia liczba przed 1
    while !isinf(type(2) * max)  # Pętla dopóki podwojona wartość max nie jest nieskończonością
        max *= type(2)  # Podwajanie wartości max
    end
    return max  # Zwrócenie maksymalnej wartości
end

# Obliczanie maksymalnej wartości dla różnych typów
max_16 = compute_max(Float16)
max_32 = compute_max(Float32)
max_64 = compute_max(Float64)

# Przygotowanie danych do wyświetlenia w tabeli
data = ["Float16" "$max_16" "$(floatmax(Float16))" "-";
        "Float32" "$max_32" "$(floatmax(Float32))" "3.4028235e38";
        "Float64" "$max_64" "$(floatmax(Float64))" "1.7976931348623157e308"]

# Wyświetlenie tabeli z wynikami
pretty_table(data, header=["Type", "Max", "Float max (Julia)", "Float max (C)"], alignment=:l, header_crayon = crayon"green")