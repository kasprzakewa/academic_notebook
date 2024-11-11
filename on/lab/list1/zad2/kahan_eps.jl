#Ewa Kasprzak
#272356
#zadanie 2

using PrettyTables

# Funkcja obliczająca epsilon Kahna dla danego typu
function kahan_eps(type)
    return type(3)*(type(4)/type(3) - type(1)) - type(1)  # Obliczanie epsilon Kahna
end

# Obliczanie epsilon Kahna dla różnych typów
kahan_eps_16 = kahan_eps(Float16)
kahan_eps_32 = kahan_eps(Float32)
kahan_eps_64 = kahan_eps(Float64)

# Przygotowanie danych do wyświetlenia w tabeli
data = ["Float16" "$kahan_eps_16" "$(abs(kahan_eps_16))" "$(eps(Float16))";
        "Float32" "$kahan_eps_32" "$(abs(kahan_eps_32))" "$(eps(Float32))";
        "Float64" "$kahan_eps_64" "$(abs(kahan_eps_64))" "$(eps(Float64))"]

# Wyświetlenie tabeli z wynikami
pretty_table(data, header=["Type", "Kahan's epsilon", "Kahan's epsilon (abs)", "Machine epsilon"], alignment=:l, header_crayon = crayon"green")