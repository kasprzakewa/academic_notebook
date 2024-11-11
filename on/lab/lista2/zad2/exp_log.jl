# Ewa Kasprzak 
# 272356
# zadanie 2 - julia

using Plots

e = MathConstants.e

# f_improved(x)

# Ulepszona wersja funkcji `f`, która efektywniej obsługuje duże wartości `x`.

# Argumenty
# - `x::Float64`: Wartość wejściowa.

# Zwraca
# - `Float64`: Wynik funkcji `f_improved` dla `x`.
function f_improved(x)
    if Float64(x) < 36.736800577044484
        return e^x * log(1 + e^(-x))
    else
        return 1
    end  
end

# f(x)

# Oryginalna funkcja `f`.

# Argumenty
# - `x::Float64`: Wartość wejściowa.

#Zwraca
# - `Float64`: Wynik funkcji `f` dla `x`.
f(x) = e^x * log(1 + e^(-x))


# find_largest_x()

# Znajduje największe `x`, dla którego funkcja `f` nie zwraca `Inf` ani `NaN`.

# Zwraca
# - `Float64`: Największa wartość `x`.
function find_largest_x()
    x = 0.0
    step = 0.001
    while true
        y = f(x)
        if isinf(y) || isnan(y)
            return x - step
        end
        x += step
    end
end


# find_min_x()

# Znajduje najmniejsze `x`, dla którego funkcja `f` nie zwraca `Inf` ani `NaN`.

# Zwraca
# - `Float64`: Najmniejsza wartość `x`.
function find_min_x()
    x = 0.0
    step = 0.0001
    while true
        y = f(x)
        if isinf(y) || isnan(y)
            return x + step
        end
        x -= step
    end
end

largest_x = find_largest_x()
println("Largest x + 0.01: ", largest_x + 0.01)
println("f(largest_x + 0.01): ", f(largest_x + 0.01))
println("e^(largest_x + 0.01): ", e^(largest_x + 0.01))
min_x = find_min_x()

x = min_x:0.01:min_x + 1
y = f.(x)
plot(x, y, label="f(x)", xlabel="x", ylabel="f(x)", title="f(x) w okolicach x = min_x", legend=:topleft)
savefig("f_x_min.png")

x = largest_x - 1:0.01:largest_x
y = f.(x)
plot(x, y, label="f(x)", xlabel="x", ylabel="f(x)", title="f(x) w okolicach x = largest_x", legend=:topleft)
savefig("f_x_largest.png")

x = -6:0.01:66
y = f.(x)
plot(x, y, label="f(x)", xlabel="x", ylabel="f(x)", title="f(x)", legend=:topleft)
savefig("f_x.png")

x = -6:0.01:66
y = f_improved.(x)
plot(x, y, label="f(x)", xlabel="x", ylabel="f(x)", title="f(x)", legend=:topleft)
savefig("f_improved_x.png")