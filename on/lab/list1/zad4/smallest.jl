#Ewa Kasprzak
#272356
#zadanie 4

# Funkcja znajdująca najmniejszą wartość t. że x * (1.0 / x) != 1.0
function find_smallest_weird_nmb()
    nmb = 1.0  # Inicjalizacja liczby jako 1.0
    # Pętla, która znajduje najmniejszą liczbę, dla której nmb * (1.0 / nmb) nie jest równe 1.0
    while nmb * (1.0 / nmb) == 1.0
        nmb = nextfloat(nmb)  # Przejście do następnej liczby zmiennoprzecinkowej
    end
    
    return nmb  # Zwrócenie znalezionej liczby
end

using PrettyTables

val = find_smallest_weird_nmb()  # Wywołanie funkcji i przypisanie wyniku do zmiennej val

# Przygotowanie danych do wyświetlenia w tabeli
data = ["x" "$val" "$(bitstring(val))";
        "1/x" "$(1 / val)" "$(bitstring((1 / val)))";
        "x * 1/x" "$(val * (1 / val))" "$(bitstring(val * (1 / val)))"]

# Wyświetlenie tabeli z wynikami
pretty_table(data, header=["Description", "Value", "Bitstring"], alignment=:l, header_crayon = crayon"green")