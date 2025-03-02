# Ewa Kasprzak 272356
# plik testowy

module blocksys
using Printf

export  A_matrix, 
        read_matrix_from_file, display_matrix, 
        gauss_basic, gauss_with_pivot, 
        lu_decomposition_basic, lu_decomposition_with_pivot, 
        solve_down, solve_up,
        A_mul_x

mutable struct A_block
    repr::Matrix{Float64}
end

mutable struct B_block
    repr::Dict{Tuple{Int, Int}, Float64}
end

mutable struct C_block
    repr::Dict{Tuple{Int, Int}, Float64}
end

mutable struct A_matrix
    A_blocks::Vector{A_block}
    B_blocks::Vector{B_block}
    C_blocks::Vector{C_block}
    l::Int
    n::Int
end

function Base.deepcopy(block::A_block)
    return A_block(deepcopy(block.repr))
end

function Base.deepcopy(block::B_block)
    return B_block(deepcopy(block.repr))
end

function Base.deepcopy(block::C_block)
    return C_block(deepcopy(block.repr))
end

function Base.deepcopy(A::A_matrix)
    copied_A_blocks = [deepcopy(block) for block in A.A_blocks]
    copied_B_blocks = [deepcopy(block) for block in A.B_blocks]
    copied_C_blocks = [deepcopy(block) for block in A.C_blocks]
    return A_matrix(copied_A_blocks, copied_B_blocks, copied_C_blocks, A.l, A.n)
end

"""
    read_matrix_from_file(filename::String)

    Czyta macierz z pliku w formacie:
    n l
    x y value
    ...
    gdzie n to rozmiar macierzy, l to rozmiar bloku, a row, col, value to współrzędne i wartość elementu macierzy.

    Funkcja zwraca obiekt typu A_matrix.

    Funkcja implementuje automat z 3 stanami:
    1. Wczytywanie bloków A
    2. Wczytywanie bloków C
    3. Wczytywanie bloków B

    Stanem początkowym jest stan 1.

    Wczytywanie bloków A:
    - Wczytywane są bloki A o rozmiarze lxl

    Wczytywanie bloków C:
    - Wczytywane są bloki C o rozmiarze l

    Wczytywanie bloków B:
    - Wczytywane są bloki B o rozmiarze 2l
"""
function read_matrix_from_file(filename::String)
    open(filename, "r") do file
        n, l = parse.(Int, split(readline(file)))

        matrix = A_matrix([], [], [], l, n)
        state = 1
        count = 0
        first = true
        k = 1
        A_blocks = []
        B_blocks = []
        C_blocks = []
        a_block = A_block(zeros(Float64, l, l))
        b_block = B_block(Dict{Tuple{Int, Int}, Float64}())
        c_block = C_block(Dict{Tuple{Int, Int}, Float64}())
        temp = 0.0

        for line in eachline(file)
            row, col, value = parse.(Float64, split(line))

            if state == 1
                if count == 0
                    a_block = A_block(zeros(Float64, l, l))
                end
                row = floor(Int, count / l) + 1
                col = count % l + 1
                a_block.repr[row, col] = value

                count += 1

                if count == l^2
                    push!(A_blocks, a_block)
                    count = 0

                    if n / l == k
                        state = 3
                    else
                        state = 2
                    end
                end


            elseif state == 2
                if count == 0
                    c_block = C_block(Dict{Tuple{Int, Int}, Float64}())
                end
                c_block.repr[(row, col)] = value
                count += 1

                if count == l
                    push!(C_blocks, c_block)
                    count = 0
                    if k == 1
                        k = 2
                        state = 1
                    else
                        state = 3
                    end
                end


            elseif state == 3
                if count == 0
                    b_block = B_block(Dict{Tuple{Int, Int}, Float64}())
                end

                b_block.repr[(row, col)] = value

                count += 1
                if count == 2*l
                    push!(B_blocks, b_block)
                    count = 0
                    k = k + 1
                    state = 1
                end

            end
        end

        matrix.A_blocks = A_blocks
        matrix.B_blocks = B_blocks
        matrix.C_blocks = C_blocks

        return matrix
    end
end

"""
    display_matrix(A_matrix)

    Wyświetla macierz A_matrix w formie blokowej.

    Podświetla na zielono elementy na przekątnej w celu czytelniejszego wyświetlania.
"""
function display_matrix(A_matrix)
    for x in 1:A_matrix.n
        row_elements = [] 
        for y in 1:A_matrix.n
            value = find_cell(A_matrix, row, col)
            formatted_value = if value < 0
                @sprintf("%6.9f", value)
            else
                @sprintf("%6.10f", value)
            end
            if x == y
                push!(row_elements, "\e[32m$formatted_value\e[0m")
            else 
                push!(row_elements, formatted_value)
            end
        end
        println(join(row_elements, " "))
    end
end

"""
    block_no(A_matrix, row::Int)

    Funkcja zwraca numer bloku, w którym znajduje się komórka o numerze wiersza row.
    Numeracja bloków zaczyna się od 1.
"""
function block_no(A::A_matrix, row::Int)
    return floor(Int, (row-1)/A.l) + 1
end


"""
    which_block(A_matrix, row::Int, col::Int)

    Funkcja zwraca typ bloku, w którym znajduje się komórka (row, col) macierzy A_matrix.
    Możliwe typy bloków to: "A", "B", "C".
    Jeśli komórka nie należy do żadnego bloku, funkcja zwraca nothing.
"""
function which_block(A::A_matrix, row::Int, col::Int)
    if row < 1 || row > A.n || col < 1 || col > A.n
        return nothing
    end

    l = A.l
    k = block_no(A, row)

    if col >= (1 + (k-2)*l) 
        if col < (1 + (k-1)*l)
            return "B"
        elseif col < (1 + k*l)
            return "A"
        elseif col < (1 + (k+1)*l)
            return "C"
        end
    end

    return nothing
end

"""
    find_cell(A_matrix, row::Int, col::Int)

    Funkcja zwraca wartość komórki (row, col) - indeksy w głównej macierzy - z macierzy A_matrix.
    Jeśli komórka nie należy do żadnego bloku, funkcja zwraca 0.0.
    Jeśli próbujemy odwołać się do komórki spoza macierzy, funkcja zwraca nothing.
"""
function find_cell(A::A_matrix, row::Int, col::Int)
    if row < 1 || row > A.n || col < 1 || col > A.n
        return nothing
    end

    block_type = which_block(A, row, col)
    l = A.l
    k = block_no(A, row)

    if block_type == "B"
        if haskey(A.B_blocks[k-1].repr, (row, col))
            return A.B_blocks[k-1].repr[(row, col)]
        end
    elseif block_type == "A"
        return A.A_blocks[k].repr[row - (k-1)*l, col - (k-1)*l]
    elseif block_type == "C"
        if haskey(A.C_blocks[k].repr, (row, col))
            return A.C_blocks[k].repr[(row, col)]
        end
    end

    return 0.0
end

"""
    set_cell(A_matrix, row::Int, col::Int, value::Float64)

    Funkcja ustawia wartość komórki (row, col) - indeksy w głównej macierzy - z macierzy A_matrix na value.
    Jeśli komórka nie należy do żadnego bloku, funkcja zwraca nothing.
    Jeśli próbujemy odwołać się do komórki spoza macierzy, funkcja zwraca nothing.
"""
function set_cell(A::A_matrix, row::Int, col::Int, value::Float64)
    if row < 1 || row > A.n || col < 1 || col > A.n
        return nothing
    end

    block_type = which_block(A, row, col)
    l = A.l
    k = block_no(A, row)

    if block_type == "B"
        A.B_blocks[k-1].repr[(row, col)] = value
    elseif block_type == "A"
        A.A_blocks[k].repr[row - (k-1)*l, col - (k-1)*l] = value
    elseif block_type == "C"
        A.C_blocks[k].repr[(row, col)] = value
    end

    return nothing
end

"""
    left_in_A_left(A_matrix, col::Int)

    Funkcja zwraca liczbę elementów w bloku, które znajdują się na prawo od kolumny col.
"""
function left_to_the_right(A::A_matrix, col::Int)
    return A.l - ((col-1)%A.l + 1)
end

"""
    left_in_A_left(A_matrix, col::Int)

    Funkcja zwraca liczbę elementów w bloku, które znajdują się na lewo od kolumny col.
"""
function left_to_the_left(A::A_matrix, col::Int)
    return (col - 1)%A.l
end

"""
    left_in_A_left(A_matrix, col::Int)

    Funkcja zwraca liczbę elementów, które należą do bloków i znajdują się na prawo od kolumny col.
"""
function lookup_cells_right(A::A_matrix, row::Int, col::Int)
    lookup = left_to_the_right(A, col)

    if which_block(A, row, col) == "B"
        lookup += A.l
    end

    if col + lookup <= A.n - A.l
        lookup += A.l
    end

    return lookup
end

"""
    lookup_cells_left(A_matrix, row::Int, col::Int)

    Funkcja zwraca liczbę elementów, które należą do bloków i znajdują się na lewo od kolumny col.
"""
function lookup_cells_left(A::A_matrix, row::Int, col::Int)
    lookup = left_to_the_left(A, col)
    block = which_block(A, row, col)
    k = block_no(A, row)

    if block == "A" 
        if k > 1
            lookup += A.l
        end
    elseif block == "C"
        if k > 1
            lookup += 2*A.l
        else
            lookup += A.l
        end
    end    

    return lookup
end

"""
    lookup_cells_down(A_matrix, col::Int)

    Funkcja zwraca liczbę elementów, które należą do bloków i znajdują się poniżej wiersza col.
"""
function lookup_cells_down(A::A_matrix, col::Int)
    k = block_no(A, col)
    lookup = left_to_the_right(A, col)

    if k < A.n/A.l
        if lookup == 0
            lookup = A.l
        elseif lookup == 1
            lookup = A.l + 1
        end
    end

    return lookup
end

"""
    solve_up(U::A_matrix, b::Vector{Float64})

    Funkcja rozwiązuje układ równań Ux = b, gdzie U jest macierzą górnotrójkątną.
    Funkcja zwraca wektor x.
"""
function solve_up(U::A_matrix, b::Vector{Float64})
    x = zeros(Float64, U.n)

    for k in U.n:-1:1
        x[k] = b[k]
        lookup_right = lookup_cells_right(U, k, k)
        for j in 1:lookup_right
            x[k] = x[k] - find_cell(U, k, k+j) * x[k+j]
        end
        x[k] = x[k] / find_cell(U, k, k)
    end

    return x
end

"""
    solve_down(L::A_matrix, b::Vector{Float64})

    Funkcja rozwiązuje układ równań Ly = b, gdzie L jest macierzą dolnotrójkątną.
    Funkcja zwraca wektor y.
"""
function solve_down(L::A_matrix, b::Vector{Float64})
    y = zeros(Float64, L.n)

    for k in 1:L.n
        y[k] = b[k]
        lookup_left = lookup_cells_left(L, k, k)
        for i in (k - lookup_left):k-1
            y[k] = y[k] - find_cell(L, k, i) * y[i]
        end
    end

    return y
end


"""
    gauss_basic(A::A_matrix, b::Vector{Float64})

    Funkcja sprowadza macierz A do postaci górnotrójkątnej.
"""
function gauss_basic(A::A_matrix, b::Vector{Float64})
    for k in 1:A.n-1
        lookup_down = lookup_cells_down(A, k)
        
        #iterujemy tylko przez elementy, które są w blokach
        for i in (k+1):(k+lookup_down)
            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            #zerujemy zmienną tuż pod przekątną
            set_cell(A, i, k, Float64(0))

            lookup_right = lookup_cells_right(A, i, k)

            #iterujemy tylko przez elementy, które są w blokach
            for j in (k+1):(k+lookup_right)
                #aktualizujemy współczynniki w równaniu
                set_cell(A, i, j, find_cell(A, i, j) - l_ik * find_cell(A, k, j))
            end

            #aktualizujemy wektor b
            b[i] = b[i] - l_ik * b[k]
        end
    end
end

"""
    swap_rows(A::A_matrix, b::Vector{Float64}, k::Int, index::Int)

    Funkcja zamienia wiersze k i index w macierzy A oraz wektorze b.
"""
function swap_rows(A::A_matrix, b::Vector{Float64}, k::Int, index::Int)
    lookup = max(lookup_cells_right(A, k, k), lookup_cells_right(A, index, k))

    #wiersze zamieniamy od kolumny k, gdyż wcześniejsze kolumny są zerami w obu wierszach
    for column in k:(k+lookup)
        k_value = find_cell(A, k, column)
        set_cell(A, k, column, find_cell(A, index, column))
        set_cell(A, index, column, k_value)
    end

    b_value = b[k]
    b[k] = b[index]
    b[index] = b_value
end
    
"""
    gauss_with_pivot(A::A_matrix, b::Vector{Float64})

    Funkcja sprowadza macierz A do postaci górnotrójkątnej z częściowym wyborem elementu głównego.
"""
function gauss_with_pivot(A::A_matrix, b::Vector{Float64})
    for k in 1:A.n-1
        index = k
        max = abs(find_cell(A, k, k))

        lookup_down = lookup_cells_down(A, k)

        #iterujemy przez elementy w kolumnie k w poszkiwaniu maksymalnego elementu co do wartości bezwzględnej
        for i in (k+1):(k+lookup_down)
            value = abs(find_cell(A, i, k))
            if value > max
                max = value
                index = i
            end
        end

        #jeżeli max jest zbyt mały, to macierz może być osobliwa lub narażona na błędy numeryczne
        if max < 1e-15
            println("Warning: matrix can be singular")
            return nothing
        end

        #jeżeli znaleźliśmy element większy od elementu na przekątnej, to zamieniamy wiersze
        if index != k
            swap_rows(A, b, k, index)
        end
        
        #procedura taka sama jak w gauss_basic
        for i in (k+1):(k+lookup_down)
            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            set_cell(A, i, k, Float64(0))

            lookup_right = lookup_cells_right(A, i, k)

            for j in (k+1):(k+lookup_right)
                set_cell(A, i, j, find_cell(A, i, j) - l_ik * find_cell(A, k, j))
            end

            b[i] = b[i] - l_ik * b[k]
        end        
    end
end

"""
    lu_decoposition_basic(A::A_matrix)

    Funkcja dokonuje dekompozycji LU macierzy A.
"""
function lu_decomposition_basic(A::A_matrix)
    #procedura analogiczna do gauss_basic
    for k in 1:A.n-1

        lookup_down = lookup_cells_down(A, k)

        for i in (k+1):(k+lookup_down)
            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            #ustawiamy wartość komórki tuż pod przekątną na współczynnik l_ik
            set_cell(A, i, k, l_ik)

            lookup_right = lookup_cells_right(A, i, k)

            for j in (k+1):(k+lookup_right)
                set_cell(A, i, j, find_cell(A, i, j) - l_ik * find_cell(A, k, j))
            end
        end
    end
end

"""
    swap_rows_lu(A::A_matrix, k::Int, index::Int)

    Funkcja zamienia wiersze k i index w macierzy A.
"""
function swap_rows_lu(A::A_matrix, k::Int, index::Int)
    lookup_right = max(lookup_cells_right(A, k, k), lookup_cells_right(A, index, k))
    lookup_left = max(lookup_cells_left(A, k, k), lookup_cells_left(A, index, k))

    #zamieniamy wszystkie elementy z bloków w wierszach k i index
    for column in (k - lookup_left):(k + lookup_right)
        k_value = find_cell(A, k, column)
        set_cell(A, k, column, find_cell(A, index, column))
        set_cell(A, index, column, k_value)
    end
end


"""
    lu_decomposition_with_pivot(A::A_matrix)

    Funkcja dokonuje dekompozycji LU macierzy A z częściowym wyborem elementu głównego.
"""
function lu_decomposition_with_pivot(A::A_matrix)
    perm = [i for i in 1:A.n]

    #procedura analogiczna do gauss_with_pivot
    for k in 1:A.n-1
        index = k
        max = abs(find_cell(A, k, k))
        lookup_down = lookup_cells_down(A, k)

        for i in (k+1):(k+lookup_down)
            value = abs(find_cell(A, i, k))
            if value > max
                max = value
                index = i
            end
        end

        if max < 1e-15
            println("Warning: matrix can be singular")
            return nothing
        end

        if index != k
            swap_rows_lu(A, k, index)
            #zapamiętujemy permutację wierszy
            perm[k], perm[index] = perm[index], perm[k]
        end
        
        for i in (k+1):(k+lookup_down)
            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            set_cell(A, i, k, l_ik)

            lookup_right = lookup_cells_right(A, i, k)

            for j in (k+1):(k+lookup_right)
                set_cell(A, i, j, find_cell(A, i, j) - l_ik * find_cell(A, k, j))
            end
        end              
    end

    return perm
end

"""
    A_mul_x(A::A_matrix)

    Funkcja mnoży macierz A przez wektor x (kolumnę jednostkową).
"""
function A_mul_x(A::A_matrix)
    b = zeros(Float64, A.n)
    for row in 1:A.n
        start_elem = row - lookup_cells_left(A, row, row)
        end_elem = row + lookup_cells_right(A, row, row)
        sum = 0.0

        for col in start_elem:end_elem
            sum += find_cell(A, row, col)
        end

        b[row] = sum
    end
    return b
end

end
