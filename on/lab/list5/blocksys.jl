module blocksys
using Printf

export A_block, B_block, C_block, A_matrix, find_cell, read_matrix_from_file, display_matrix, elems_to_lookup_down, lookup_cells_right, gauss_basic, set_cell, gauss_with_pivot, lu_decomposition_basic, lu_decomposition_with_pivot, solve_gauss

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


function find_cell(A::A_matrix, x::Int, y::Int)
    if x < 1 || x > A.n || y < 1 || y > A.n
        return nothing
    end

    block_type = which_block(A, x, y)
    l = A.l
    k = floor(Int, (x-1) / l) + 1

    if block_type == "B"
        if haskey(A.B_blocks[k-1].repr, (x, y))
            return A.B_blocks[k-1].repr[(x, y)]
        end
    elseif block_type == "A"
        return A.A_blocks[k].repr[x - (k-1)*l, y - (k-1)*l]
    elseif block_type == "C"
        if haskey(A.C_blocks[k].repr, (x, y))
            return A.C_blocks[k].repr[(x, y)]
        end
    end

    return 0.0
end


function set_cell(A::A_matrix, x::Int, y::Int, value::Float64)
    if x < 1 || x > A.n || y < 1 || y > A.n
        return nothing
    end

    block_type = which_block(A, x, y)
    l = A.l
    k = floor(Int, (x-1) / l) + 1

    if block_type == "B"
        A.B_blocks[k-1].repr[(x, y)] = value
    elseif block_type == "A"
        A.A_blocks[k].repr[x - (k-1)*l, y - (k-1)*l] = value
    elseif block_type == "C"
        A.C_blocks[k].repr[(x, y)] = value
    end

    return nothing
end


function which_block(A::A_matrix, x::Int, y::Int)
    if x < 1 || x > A.n
        return nothing
    end

    if y < 1 || y > A.n
        return nothing
    end

    l = A.l
    k = floor(Int, (x-1) / l) + 1

    if y >= (1 + (k-2)*l) 
        if y < (1 + (k-1)*l)
            return "B"
        elseif y < (1 + k*l)
            return "A"
        elseif y < (1 + (k+1)*l)
            return "C"
        end
    end

    return nothing
end

function left_in_A(A::A_matrix, k::Int)
    l = A.l
    return l-((k-1)%l + 1)
end

function left_in_B(A::A_matrix, k::Int)
    l = A.l
    return l - ((k-1)%l + 1)
end

function C_index(A::A_matrix, i::Int)
    l = A.l
    return (i-1)%l + 1 
end

function elems_to_lookup_down(A::A_matrix, k::Int)
    l = A.l
    n = A.n
    index = floor(Int, (k-1)/l) + 1
    lookup = 0
    lookup_in_A = l - ((k-1)%l + 1)

    if index == n/l
        lookup = lookup_in_A
    elseif lookup_in_A == 0
        lookup = l
    elseif lookup_in_A == 1
        lookup = l + 1
    else
        lookup = lookup_in_A
    end

    return lookup
end

function lookup_cells_right(A::A_matrix, i::Int, k::Int)
    l = A.l
    lookup = nothing

    if which_block(A, i, k) == "A"
        lookup = left_in_A(A, k)
    else 
        lookup = left_in_B(A, k) + l
    end

    if k + lookup <= A.n - l
        lookup += l
    end

    return lookup
end

function solve_gauss(A::A_matrix, b::Vector{Float64})
    x = zeros(Float64, A.n)

    for k in A.n:-1:1
        x[k] = b[k]
        lookup_right = lookup_cells_right(A, k, k)
        for j in 1:lookup_right
            x[k] = x[k] - find_cell(A, k, k+j) * x[k+j]
        end
        x[k] = x[k] / find_cell(A, k, k)
    end

    return x
end


function gauss_basic(A::A_matrix, b::Vector{Float64})
    n = A.n
    l = A.l 

    for k in 1:n-1
        lookup_down = elems_to_lookup_down(A, k)
        
        for x in 1:lookup_down
            i = k + x

            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            set_cell(A, i, k, Float64(0))

            lookup_right = lookup_cells_right(A, i, k)

            for y in 1:lookup_right
                j = k + y
                value = find_cell(A, i, j) - l_ik * find_cell(A, k, j)
                set_cell(A, i, j, value)
            end

            b[i] = b[i] - l_ik * b[k]
        end
    end
end

function gauss_with_pivot(A::A_matrix, b::Vector{Float64})
    n = A.n
    l = A.l
    perm = [i for i in 1:n]

    for k in 1:n-1
        index = k
        max = abs(find_cell(A, k, k))
        lookup_down = elems_to_lookup_down(A, k)

        for i in 1:lookup_down
            value = abs(find_cell(A, k+i, k))
            if value > max
                max = value
                index = k + i
            end
        end

        if max < 1e-15
            println("Warning: matrix can be singular")
            return nothing
        end

        if index != k
            swap_rows(A, b, k, index)
            perm[k], perm[index] = perm[index], perm[k]
        end
        
        for x in 1:lookup_down
            i = k + x

            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            set_cell(A, i, k, Float64(0))

            lookup_right = lookup_cells_right(A, i, k)

            for y in 1:lookup_right
                j = k + y
                value = find_cell(A, i, j) - l_ik * find_cell(A, k, j)
                set_cell(A, i, j, value)
            end

            b[i] = b[i] - l_ik * b[k]
        end        
    end

    return perm
end

function swap_rows(A::A_matrix, b::Vector{Float64}, k::Int, index::Int)
    lookupK = lookup_cells_right(A, k, k)
    lookupIndex = lookup_cells_right(A, index, k)

    lookup = max(lookupK, lookupIndex)

    for i in 0:lookup
        column = k + i
        k_value = find_cell(A, k, column)
        set_cell(A, k, column, find_cell(A, index, column))
        set_cell(A, index, column, k_value)
    end

    b_value = b[k]
    
    b[k] = b[index]
    b[index] = b_value
end

function lu_decomposition_basic(A::A_matrix, b::Vector{Float64})
    n = A.n
    l = A.l 

    for k in 1:n-1
        lookup_down = elems_to_lookup_down(A, k)
        
        for x in 1:lookup_down
            i = k + x

            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            set_cell(A, i, k, l_ik)

            lookup_right = lookup_cells_right(A, i, k)

            for y in 1:lookup_right
                j = k + y
                value = find_cell(A, i, j) - l_ik * find_cell(A, k, j)
                set_cell(A, i, j, value)
            end

            b[i] = b[i] - l_ik * b[k]
        end
    end
end

function lu_decomposition_with_pivot(A::A_matrix, b::Vector{Float64})
    n = A.n
    l = A.l
    perm = [i for i in 1:n]

    for k in 1:n-1
        index = k
        max = abs(find_cell(A, k, k))
        lookup_down = elems_to_lookup_down(A, k)

        for i in 1:lookup_down
            value = abs(find_cell(A, k+i, k))
            if value > max
                max = value
                index = k + i
            end
        end

        if max < 1e-15
            println("Warning: matrix can be singular")
            return nothing
        end

        if index != k
            swap_rows(A, b, k, index)
            perm[k], perm[index] = perm[index], perm[k]
        end
        
        for x in 1:lookup_down
            i = k + x

            l_ik = find_cell(A, i, k) / find_cell(A, k, k)
            set_cell(A, i, k, l_ik)

            lookup_right = lookup_cells_right(A, i, k)

            for y in 1:lookup_right
                j = k + y
                value = find_cell(A, i, j) - l_ik * find_cell(A, k, j)
                set_cell(A, i, j, value)
            end

            b[i] = b[i] - l_ik * b[k]
        end        
    end

    return perm
end

function display_matrix(A_matrix, k_value)
    for x in 1:A_matrix.n
        row_elements = [] 
        for y in 1:A_matrix.n
            value = find_cell(A_matrix, x, y)
            formatted_value = if value < 0
                @sprintf("%6.9f", value)
            else
                @sprintf("%6.10f", value)
            end
            if x == y
                push!(row_elements, "\e[32m$formatted_value\e[0m")
            elseif value != nothing
                if value == k_value
                    push!(row_elements, "\e[31m$formatted_value\e[0m")
                else
                    push!(row_elements, formatted_value)
                end
            else 
                push!(row_elements, formatted_value)
            end
        end
        println(join(row_elements, " "))
    end
end

end
