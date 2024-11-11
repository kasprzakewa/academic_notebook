#Ewa Kasprzak
#272356
#zadanie 5

using PrettyTables

# Funkcja obliczająca sumę iloczynów elementów wektorów a i b w kolejności od początku do końca
function scalar_forward(a, b, type)
    sum = type(0)
    for i in 1:length(a)
        sum += type(type(a[i]) * type(b[i]))
    end

    return sum
end

# Funkcja obliczająca sumę iloczynów elementów wektorów a i b w kolejności od końca do początku
function scalar_backwards(a, b, type)
    sum = type(0)
    for i in length(a):-1:1
        sum += type(type(a[i]) * type(b[i]))
    end

    return sum
end

# Funkcja obliczająca sumę iloczynów elementów wektorów a i b, najpierw sumując dodatnie wartości od największej do najmniejszej, a potem ujemne na odwrót
function scalar_max_min(a, b, type)
    pos = []
    neg = []
    for i in 1:length(a)
        c = type(type(a[i]) * type(b[i]))

        if c > 0
            push!(pos, c)
        else
            push!(neg, c)
        end
    end

    pos = sort(pos, rev=true)  # Sortowanie dodatnich wartości malejąco
    neg = sort(neg)  # Sortowanie ujemnych wartości rosnąco

    sum_pos = type(0)
    for i in 1:length(pos)
        sum_pos += type(pos[i])
    end

    sum_neg = type(0)
    for i in 1:length(neg)
        sum_neg += type(neg[i])
    end
    
    return type(type(sum_pos) + type(sum_neg))
end

# Funkcja obliczająca sumę iloczynów elementów wektorów a i b, najpierw sumując dodatnie wartości od najmniejszej do największej, a potem ujemne na odwrót
function scalar_min_max(a, b, type)
    pos = []
    neg = []
    for i in 1:length(a)
        c = type(type(a[i]) * type(b[i]))

        if c > 0
            push!(pos, c)
        else
            push!(neg, c)
        end
    end

    pos = sort(pos)  # Sortowanie dodatnich wartości rosnąco
    neg = sort(neg, rev=true)  # Sortowanie ujemnych wartości malejąco

    sum_pos = type(0)
    for i in 1:length(pos)
        sum_pos += type(pos[i])
    end

    sum_neg = type(0)
    for i in 1:length(neg)
        sum_neg += type(neg[i])
    end
    
    return type(type(sum_pos) + type(sum_neg))
end

# Przykładowe wektory a i b
a = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
b =  [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]
real = -1.00657107000000 * 10^(-11)  # Rzeczywista wartość sumy iloczynów

# Przygotowanie danych do wyświetlenia w tabeli
data = ["Float32" "$(scalar_forward(a, b, Float32))" "$(scalar_backwards(a, b, Float32))" "$(scalar_max_min(a, b, Float32))" "$(scalar_min_max(a, b, Float32))";
        "Float64" "$(scalar_forward(a, b, Float64))" "$(scalar_backwards(a, b, Float64))" "$(scalar_max_min(a, b, Float64))" "$(scalar_min_max(a, b, Float64))";
        "Float64 (real)" "$real" "$real" "$real" "$real"]

# Wyświetlenie tabeli z wynikami
pretty_table(data, header=["Type", "Forward", "Backward", "Max -> Min", "Min -> Max"], alignment=:l, header_crayon = crayon"green")