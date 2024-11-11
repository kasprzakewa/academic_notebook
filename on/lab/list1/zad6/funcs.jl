#Ewa Kasprzak
#272356
#zadanie 6

using PrettyTables

f(x) = sqrt(x^2 + 1.0) - 1.0
g(x) = x^2 / (sqrt(x^2 + 1.0) + 1.0)

# Funkcja tworząca tabelę z wynikami dla funkcji f i g
function create_table()
    data = []  # Inicjalizacja pustej tablicy na dane

    for i in 1:13
        x = 8.0^(-i)  # Obliczanie wartości x
        f_x = f(x)  # Obliczanie wartości f(x)
        g_x = g(x)  # Obliczanie wartości g(x)
        x_sqrt = sqrt(x^2 + 1.0)  # Obliczanie wartości sqrt(x^2 + 1.0)
        
        if (data == [])
            data = ["$i" "$x" "$x_sqrt" "$f_x" "$g_x"]  # Dodanie pierwszego wiersza danych
        else
            new_row = ["$i" "$x" "$x_sqrt" "$f_x" "$g_x"]  # Tworzenie nowego wiersza danych
            data = vcat(data, new_row)  # Dodanie nowego wiersza do tablicy danych
        end
    end

    return data  # Zwrócenie tablicy danych
end

results = create_table()  # Wywołanie funkcji tworzącej tabelę

# Wyświetlenie tabeli z wynikami
pretty_table(results, header=["i", "x", "sqrt(x**2 + 1)", "f(x)", "g(x)"], alignment=:l, header_crayon = crayon"green")