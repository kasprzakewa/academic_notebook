# Ewa Kasprzak
# 272356
# zadanie 3

using LinearAlgebra
using PrettyTables

function hilb(n::Int)
    # Function generates the Hilbert matrix  A of size n,
    #  A (i, j) = 1 / (i + j - 1)
    # Inputs:
    #	n: size of matrix A, n>=1
    #
    #
    # Usage: hilb(10)
    #
    # Pawel Zielinski
        if n < 1
            error("size n should be >= 1")
        end
        return [1 / (i + j - 1) for i in 1:n, j in 1:n]
end

function matcond(n::Int, c::Float64)
# Function generates a random square matrix A of size n with
# a given condition number c.
# Inputs:
#	n: size of matrix A, n>1
#	c: condition of matrix A, c>= 1.0
#
# Usage: matcond(10, 100.0)
#
# Pawel Zielinski
        if n < 2
         error("size n should be > 1")
        end
        if c< 1.0
         error("condition number  c of a matrix  should be >= 1.0")
        end
        (U,S,V)=svd(rand(n,n))
        return U*diagm(0 =>[LinRange(1.0,c,n);])*V'
end

# Funkcja rozwiązująca układ równań A * x = b za pomocą eliminacji Gaussa (operator \)
# Parametry:
#   A: macierz n x n
#   b: wektor o rozmiarze n
# Zwraca:
#   x: wektor rozwiązania układu A * x = b
function gauss(A, b)
    return A \ b
end

# Funkcja rozwiązująca układ równań A * x = b za pomocą odwrotności macierzy
# Parametry:
#   A: macierz n x n
#   b: wektor o rozmiarze n
# Zwraca:
#   x: wektor rozwiązania układu A * x = b
function inversion(A, b)
    return inv(A) * b
end

function test_gauss(n::Int)
    A = hilb(n)
    cond_gauss = cond(A)
    x_exact = ones(n)
    b = A * x_exact
    x_gauss = gauss(A, b)
    error_gauss = norm(x_exact - x_gauss) / norm(x_exact)
    
    return x_gauss, error_gauss, cond_gauss
end

function test_gauss_matcond(n::Int, c::Float64)
    A = matcond(n, c)
    x_exact = ones(n)
    b = A * x_exact
    x_gauss = gauss(A, b)
    error_gauss = norm(x_exact - x_gauss) / norm(x_exact)
    return x_gauss, error_gauss
end

function test_inversion(n::Int)
    A = hilb(n)
    cond_inv = cond(A)
    x_exact = ones(n)
    b = A * x_exact
    x_inversion = inversion(A, b)
    error_inv = norm(x_exact - x_inversion) / norm(x_exact)
    return x_inversion, error_inv, cond_inv
end

function test_inversion_matcond(n::Int, c::Float64)
    A = matcond(n, c)
    x_exact = ones(n)
    b = A * x_exact
    x_inversion = inversion(A, b)
    error_inv = norm(x_exact - x_inversion) / norm(x_exact)
    return x_inversion, error_inv
end

function test_hilb_gauss()
    gauss_data = []
    for i in 1:20
        x_gauss, error_gauss, cond_gauss = test_gauss(i)

        if gauss_data == []
            gauss_data = ["$i" "$cond_gauss" "$error_gauss"]
        else
            new_row = ["$i" "$cond_gauss" "$error_gauss"]
            gauss_data = vcat(gauss_data, new_row)
        end
    end

    pretty_table(gauss_data, header=["n", "cond_gauss", "error_gauss"], alignment=:l, header_crayon = crayon"green")
end

function test_matcond_gauss(n_values, c_values)
    gauss_data = []

    for c in c_values
        for n in n_values

            if gauss_data == []
                _, error_gauss = test_gauss_matcond(n, c)
                gauss_data = ["$n" "$c" "$error_gauss"]
            else
                _, error_gauss = test_gauss_matcond(n, c)
                new_row = ["$n" "$c" "$error_gauss"]
                gauss_data = vcat(gauss_data, new_row)
            end
        end
    end

    pretty_table(gauss_data, header=["n", "cond", "error_gauss"], alignment=:l, header_crayon = crayon"green")
end

function test_hilb_inversion(n)
    inversion_data = []
    for i in 1:n
        x_inversion, error_inv, cond_inv = test_inversion(i)

        if inversion_data == []
            inversion_data = ["$i" "$cond_inv" "$error_inv"]
        else
            new_row = ["$i" "$cond_inv" "$error_inv"]
            inversion_data = vcat(inversion_data, new_row)
        end
    end

    pretty_table(inversion_data, header=["n", "cond_inv", "error_inv"], alignment=:l, header_crayon = crayon"green")
end

function test_matcond_inversion(n_values, c_values)
    inversion_data = []

    for c in c_values
        for n in n_values

            if inversion_data == []
                _, error_inv = test_inversion_matcond(n, c)
                inversion_data = ["$n" "$c" "$error_inv"]
            else
                _, error_inv = test_inversion_matcond(n, c)
                new_row = ["$n" "$c" "$error_inv"]
                inversion_data = vcat(inversion_data, new_row)
            end
        end
    end

    pretty_table(inversion_data, header=["n", "cond", "error_inv"], alignment=:l, header_crayon = crayon"green")
end

function test_hilb_gauss_latex()
    println("\\hline")
    println("\\textbf{n} & \\textbf{cond} & \\textbf{error} \\\\")
    println("\\hline")
    for i in 2:20
        x_gauss, error_gauss, cond_gauss = test_gauss(i)
        
        println("$i & $cond_gauss & $error_gauss \\\\")
        println("\\hline")
    end
end

function test_matcond_gauss_latex(n_values, c_values)
    println("\\hline")
    println("\\textbf{n} & \\textbf{cond} & \\textbf{error} \\\\")
    println("\\hline")
    for c in c_values
        for n in n_values
            _, error_gauss = test_gauss_matcond(n, c)

            println("$n & $c & $error_gauss \\\\")
            println("\\hline")
        end
    end
end

function test_hilb_inversion_latex(n)
    println("\\hline")
    println("\\textbf{n} & \\textbf{cond} & \\textbf{error} \\\\")
    println("\\hline")

    for i in 2:n
        x_inversion, error_inv, cond_inv = test_inversion(i)

        println("$i & $cond_inv & $error_inv \\\\")
        println("\\hline")
    end
end

function test_matcond_inversion_latex(n_values, c_values)
    println("\\hline")
    println("\\textbf{n} & \\textbf{cond} & \\textbf{error} \\\\")
    println("\\hline")

    for c in c_values
        for n in n_values
            _, error_inv = test_inversion_matcond(n, c)

            println("$n & $c & $error_inv \\\\")
            println("\\hline")
        end
    end
end







n_values = [5, 10, 20]
c_values = [1.0, 10.0, 10.0^3, 10.0^7, 10.0^12, 10.0^16]

# #JULIA
test_hilb_gauss()
test_matcond_gauss(n_values, c_values)
test_hilb_inversion(20)
test_matcond_inversion(n_values, c_values)

#LATEX
test_hilb_gauss_latex()
test_matcond_gauss_latex(n_values, c_values)
test_hilb_inversion_latex(20)
test_matcond_inversion_latex(n_values, c_values)