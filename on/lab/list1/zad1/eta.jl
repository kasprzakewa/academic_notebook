#Ewa Kasprzak
#272356
#zadanie 1
#eta

using PrettyTables

# Funkcja obliczająca eta dla danego typu
function compute_eta(type)
    eta = type(1)  # Inicjalizacja eta jako 1
    # Pętla zmniejszająca eta, aż iloczyn eta i 0.5 będzie równy 0
    while type(eta * type(0.5)) > type(0)
        eta *= type(0.5)  # Zmniejszanie eta o połowę
    end
    return eta  # Zwrócenie wartości eta
end

# Obliczanie eta dla różnych typów
eta_16 = compute_eta(Float16)
eta_32 = compute_eta(Float32)
eta_64 = compute_eta(Float64)

# Przygotowanie danych do wyświetlenia w tabeli
data = ["Float16" "$eta_16" "$(nextfloat(Float16(0)))"; 
        "Float32" "$eta_32" "$(nextfloat(Float32(0)))"; 
        "Float64" "$eta_64" "$(nextfloat(Float64(0)))"]

# Wyświetlenie tabeli z wynikami
pretty_table(data, header=["Type", "Eta", "Next float"], alignment=:l, header_crayon = crayon"green")