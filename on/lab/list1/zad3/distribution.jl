# Ewa Kasprzak
# 272356
# zadanie 3

using Distributions
using PrettyTables

# Funkcja sprawdzająca rozmieszczenie liczb na przedziale [start, stop] z krokiem delta
function check_distribution(start, stop, delta)
    # Inicjalizacja liczników sukcesów i błędów
    success = 0
    error = 0

    # Pętla wykonująca 100000 iteracji
    for i in 1:100000
        # Generowanie losowej liczby z rozkładu jednostajnego
        x = rand(Uniform(start, stop))
        # Konwersja liczby na ciąg bitów
        bitstring_x = bitstring(x)
        # Pobranie ostatnich 52 bitów
        last_52_digits = bitstring_x[end-51:end]
        # Konwersja ciągu bitów na wartość całkowitą
        integer_value = parse(Int, last_52_digits; base=2)
        # Przeliczenie wartości x na podstawie integer_value i delta
        x_recounted = start + integer_value * delta
    
        # Sprawdzenie, czy przeliczona wartość jest równa oryginalnej
        if (x != x_recounted)
            error += 1  # Inkrementacja licznika błędów
        else
            success += 1  # Inkrementacja licznika sukcesów
        end
    end

    # Zwrócenie liczników sukcesów i błędów
    return success, error
end

# Wywołanie funkcji check_distribution z parametrami start, stop i delta
success, error = check_distribution(1, 2, 2^(-52))

# Przygotowanie danych do wyświetlenia w tabeli
data = ["1" "2" "2^(-52)" "$success" "$error"]

# Wyświetlenie tabeli z wynikami
pretty_table(data, header=["Start", "Stop", "Delta", "Success", "Error"], alignment=:l, header_crayon = crayon"green")