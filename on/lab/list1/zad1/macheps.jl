#Ewa Kasprzak
#272356
#zadanie 1
#epsilon maszynowy

using PrettyTables

# Funkcja obliczająca maszynowy epsilon dla danego typu
function compute_macheps(type)
    macheps = type(1)
    # Pętla zmniejszająca macheps, aż suma 1 i macheps/2 będzie równa 1
    while type(1) + type(macheps * type(0.5)) != type(1)
        macheps *= type(0.5)
    end
    return macheps
end

# Obliczanie maszynowego epsilon dla różnych typów
macheps_float16 = compute_macheps(Float16)
macheps_float32 = compute_macheps(Float32)
macheps_float64 = compute_macheps(Float64)

# Przygotowanie danych do wyświetlenia w tabeli
data = ["Float16" "$macheps_float16" "$(eps(Float16))" "-"; 
        "Float32" "$macheps_float32" "$(eps(Float32))" "1.192093e-07"; 
        "Float64" "$macheps_float64" "$(eps(Float64))" "2.220446049250313e-16"]
        
# Wyświetlenie tabeli z wynikami
pretty_table(data, header=["Type", "Machine epsilon", "Machine epsilon (Julia)", "Machine epsilon(C)"], 
            alignment=:l, header_crayon = crayon"green")