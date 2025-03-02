# Ewa Kasprzak 272356
# plik z implementacją

include("blocksys.jl")
include("matrixgen.jl")
using .blocksys
using .matrixgen
using LinearAlgebra
using TimerOutputs

function gauss_basic_time(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    time = @elapsed begin
        gauss_basic(A, b)
        x = solve_up(A, b)
    end

    open(file_to_save, "a") do file
        println(file, A.n, " ", time)
    end

    return x
end

function gauss_basic_alloc(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    alloc = @allocated begin
        gauss_basic(A, b)
        x = solve_up(A, b)
    end

    open(file_to_save, "a") do file
        println(file, A.n, " ", alloc)
    end

    return x
end


function gauss_with_pivot_time(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    time = @elapsed begin
        gauss_with_pivot(A, b)
        x = solve_up(A, b)
    end

    open(file_to_save, "a") do file
        println(file, A.n, " ", time)
    end

    return x
end

function gauss_with_pivot_alloc(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    alloc = @allocated begin
        gauss_with_pivot(A, b)
        x = solve_up(A, b)
    end

    open(file_to_save, "a") do file
        println(file, A.n, " ", alloc)
    end

    return x
end

function lu_solve_basic_time(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    time = @elapsed begin
        lu_decomposition_basic(A)
        y = solve_down(A, b)
        x = solve_up(A, y)
    end
    
    open(file_to_save, "a") do file
        println(file, A.n, " ", time)
    end
    
    return x
end

function lu_solve_basic_alloc(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    alloc = @allocated begin
        lu_decomposition_basic(A)
        y = solve_down(A, b)
        x = solve_up(A, y)
    end
    
    open(file_to_save, "a") do file
        println(file, A.n, " ", alloc)
    end
    
    return x
end

function lu_solve_pivot_time(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    time = @elapsed begin
        perm = lu_decomposition_with_pivot(A)
        y = solve_down(A, b[perm])
        x = solve_up(A, y)
    end
    
    open(file_to_save, "a") do file
        println(file, A.n, " ", time)
    end

    return x
end

function lu_solve_pivot_alloc(A::A_matrix, b::Vector{Float64}, file_to_save::String)
    alloc = @allocated begin
        perm = lu_decomposition_with_pivot(A)
        y = solve_down(A, b[perm])
        x = solve_up(A, y)
    end
    
    open(file_to_save, "a") do file
        println(file, A.n, " ", alloc)
    end

    return x
end

function print_matrix(A::Matrix{Float64})
    for i in 1:size(A, 1)
        for j in 1:size(A, 2)
            print(A[i, j], " ")
        end
        println()
    end
end

function read_matrix_from_file_demo(filename::String)
    open(filename, "r") do file
        n, l = parse.(Int, split(readline(file)))

        matrix = zeros(Float64, n, n)

        for line in eachline(file)
            row, col, value = parse.(Float64, split(line))
            matrix[Int(row), Int(col)] = value
        end

        return matrix
    end
end

function read_b_from_file(filename::String)
    open(filename, "r") do file
        n = parse(Int, readline(file))

        b = zeros(Float64, n)
        count = 1

        for line in eachline(file)
            value = parse(Float64, line)
            b[count] = value
            count += 1
        end

        return b
    end
end

function save_x_to_file(filename::String, x::Vector{Float64}, error::Float64)
    open(filename, "w") do file
        if error != -1
            println(file, error)
        end
        for i in 1:length(x)
            println(file, x[i])
        end
    end
end

function test_algorithms(filename_m::String, filename_b::String, n::Int, l::Int, cond::Float64)
    blockmat(n, l, cond, filename_m)

    size_A = @allocated A_exact = read_matrix_from_file_demo(filename_m)
    size_A_matrix = @allocated A = read_matrix_from_file(filename_m)

    open("alloc_matrix_bigger.txt", "a") do file
        println(file, n, " ", size_A_matrix)
    end

    A1 = deepcopy(A)
    A2 = deepcopy(A)
    A3 = deepcopy(A)

    if (filename_b == "")
        b_exact = A_exact * ones(Float64, n)
        b = A_mul_x(A)
        b1 = deepcopy(b)
        b2 = deepcopy(b)
        b3 = deepcopy(b)
    else
        b_exact = read_b_from_file(filename_b)
        b = read_b_from_file(filename_b)
        b1 = read_b_from_file(filename_b)
        b2 = read_b_from_file(filename_b)
        b3 = read_b_from_file(filename_b)
    end

    t = @elapsed x_exact = A_exact \ b_exact
    open("time_matrix.txt", "a") do file
        println(file, n, " ", t)
    end
    x = gauss_basic_time(A, b, "./time_gauss_bigger.txt")
    x1 = gauss_with_pivot_time(A1, b1, "./time_gauss_pivot_bigger.txt")
    x2 = lu_solve_basic_time(A2, b2, "./time_lu_bigger.txt")
    x3 = lu_solve_pivot_time(A3, b3, "./time_lu_pivot_bigger.txt")

    if (filename_b != "")
        save_x_to_file("./wyniki/gauss/x/b_$n.txt", x, -1)
        save_x_to_file("./wyniki/gauss_pivot/x/b_$n.txt", x1, -1)
        save_x_to_file("./wyniki/lu/x/b_$n.txt", x2, -1)
        save_x_to_file("./wyniki/lu_pivot/x/b_$n.txt", x3, -1)
    else
        error = norm(x_exact - x) / norm(x_exact)
        error1 = norm(x_exact - x1) / norm(x_exact)
        error2 = norm(x_exact - x2) / norm(x_exact)
        error3 = norm(x_exact - x3) / norm(x_exact)

        save_x_to_file("./wyniki/gauss/x/wb_$n.txt", x, error)
        save_x_to_file("./wyniki/gauss_pivot/x/wb_$n.txt", x1, error1)
        save_x_to_file("./wyniki/lu/x/wb_$n.txt", x2, error2)
        save_x_to_file("./wyniki/lu_pivot/x/wb_$n.txt", x3, error3)
    end
end

for size in 50000:50000:1000000
    for k in 1:10
        test_algorithms("matrix.txt", "", size, 4, 10.0)
    end
end

