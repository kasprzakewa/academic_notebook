module blocksys
using Printf

export A_block, B_block, C_block, A_matrix, find_cell, read_matrix_from_file, display_matrix

mutable struct A_block
    repr::Matrix{Float64}
end

mutable struct B_block
    repr::Vector{Tuple{Float64, Float64}}
end

mutable struct C_block
    repr::Vector{Float64}
end

mutable struct A_matrix
    A_blocks::Vector{A_block}
    B_blocks::Vector{B_block}
    C_blocks::Vector{C_block}
    l::Int
    n::Int
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
        b_block = B_block([])
        c_block = C_block([])
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
                    c_block = C_block([])
                end
                push!(c_block.repr, value)
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
                    b_block = B_block([])
                end
                
                if count % 2 == 0
                    temp = value
                else
                    push!(b_block.repr, (temp, value))
                end

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
    if x < 1 || x > A.n
        return nothing
    end

    if y < 1 || y > A.n
        return nothing
    end

    i = 0.0
    l = A.l

    k = floor(Int, (x-1) / l) + 1

    if y >= (1 + (k-2)*l) 
        if y < (1 + (k-1)*l)
            if y == (k-1)*l 
                i = A.B_blocks[k-1].repr[x - (k-1)*l][2]
            elseif y == (k-1)*l - 1
                i = A.B_blocks[k-1].repr[x - (k-1)*l][1]
            end
        elseif y < (1 + k*l)
            i = A.A_blocks[k].repr[x - (k-1)*l, y - (k-1)*l]
        elseif y < (1 + (k+1)*l)
            if x - (k-1)*l == y - k*l
                i = A.C_blocks[k].repr[y - k*l]
            end
        end
    end

    return i
                
end

function set_cell(A::A_matrix, x::Int, y::Int, value::Float64)
    if x < 1 || x > A.n
        return nothing
    end

    if y < 1 || y > A.n
        return nothing
    end

    i = 0.0
    l = A.l

    k = floor(Int, (x-1) / l) + 1

    if y >= (1 + (k-2)*l) 
        if y < (1 + (k-1)*l)
            if y == (k-1)*l 
                A.B_blocks[k-1].repr[x - (k-1)*l][2] = value
            elseif y == (k-1)*l - 1
                A.B_blocks[k-1].repr[x - (k-1)*l][1] = value
            end
        elseif y < (1 + k*l)
            A.A_blocks[k].repr[x - (k-1)*l, y - (k-1)*l] = value
        elseif y < (1 + (k+1)*l)
            if x - (k-1)*l == y - k*l
                A.C_blocks[k].repr[y - k*l] = value
            end
        end
    end

    return i
                
end

function display_matrix(A_matrix)
    for x in 1:A_matrix.n
        row_elements = [] 
        for y in 1:A_matrix.n
            value = find_cell(A_matrix, x, y)
            if value < 0
                push!(row_elements, @sprintf("%6.9f", value))
            else
                push!(row_elements, @sprintf("%6.10f", value))
            end
        end
        println(join(row_elements, " "))
    end
end

end
