#Ewa Kasprzak
#272356
#zadanie 7

using PrettyTables

# Funkcja obliczająca pochodną funkcji f w punkcie x przy kroku h
function derivative(f, x, h)
    return (f(x + h) - f(x)) / h
end

# Definicja funkcji f
f(x) = sin(x) + cos(3 * x)

# Definicja analitycznej pochodnej funkcji f
df(x) = cos(x) - 3 * sin(3 * x)

x = 1.0  # Punkt, w którym obliczamy pochodną

# Funkcja tworząca tabelę z wynikami dla różnych wartości h
function create_table()
    data = []  # Inicjalizacja pustej tablicy na dane

    for i in 0:54
        x = 1.0
        h = 2.0^(-i)  # Obliczanie wartości h
        f_x = derivative(f, x, h)  # Obliczanie pochodnej numerycznej
        f_x_df_x = abs(f_x - df(x))  # Obliczanie błędu bezwzględnego
        h_1 = 1.0 + h  # Obliczanie wartości 1 + h
        
        if (data == [])
            data = ["$i" "$h" "$h_1" "$f_x" "$f_x_df_x"]  # Dodanie pierwszego wiersza danych
        else
            new_row = ["$i" "$h" "$h_1" "$f_x" "$f_x_df_x"]  # Tworzenie nowego wiersza danych
            data = vcat(data, new_row)  # Dodanie nowego wiersza do tablicy danych
        end
    end

    return data  # Zwrócenie tablicy danych
end

results = create_table()  # Wywołanie funkcji tworzącej tabelę

# Wyświetlenie tabeli z wynikami
pretty_table(results, header=["i", "h", "1+h", "f'(x)", "|f'(x) - f'_tilde_x|"], alignment=:l, header_crayon = crayon"green")