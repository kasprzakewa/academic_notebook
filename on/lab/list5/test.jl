include("blocksys.jl")
include("matrixgen.jl")
using .blocksys
using .matrixgen
using LinearAlgebra
using TimerOutputs

function gauss_basic_timed(A::A_matrix, b::Vector{Float64})
    t = TimerOutput()
    @timeit t "gauss_basic" begin
        gauss_basic(A, b)
        x = solve_gauss(A, b)
    end

    println(t)

    return x
end

function gauss_with_pivot_timed(A::A_matrix, b::Vector{Float64})
    t = TimerOutput()
    @timeit t "gauss_with_pivot" begin
        gauss_with_pivot(A, b)
        x = solve_gauss(A, b)
    end

    println(t)

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

function test_lookup_down(A::A_matrix)
    for k in 1:A.n
        lookup_down = elems_to_lookup_down(A, k)
        println("lookup_down: ", lookup_down)
    end
end

function test_lookup_right(A::A_matrix)
    for k in 1:A.n
        lookup_down = elems_to_lookup_down(A, k)
        for i in 1:lookup_down
            j = k+i
            lookup_right, c_id = lookup_cells_right(A, k, j)
            println("($j, $k) ", lookup_right, " ", c_id)
        end
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

filename_matrix = "./dane/500tys/A.txt"
filename_b = "./dane/500tys/b.txt"
# n = 50000
# l = 2000
# blockmat(n, l, 10.0, filename)

# A_exact = read_matrix_from_file_demo(filename_matrix)
# b_exact = read_b_from_file(filename_b)
# x_exact = A_exact \ b_exact

A = read_matrix_from_file(filename_matrix)
b = read_b_from_file(filename_b)
A1 = deepcopy(A)
b1 = deepcopy(b)

x = gauss_basic_timed(A, b)
x1 = gauss_with_pivot_timed(A1, b1)

# error_basic = norm(x_exact - x) / norm(x_exact)
# error_pivot = norm(x_exact - x1) / norm(x_exact)

# println("Error basic: ", error_basic)
# println("Error pivot: ", error_pivot)

println()
println()
error = norm(x - x1) / norm(x)
println("-------------------------")
println()
println("Error: ", error)