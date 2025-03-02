# Ewa Kasprzak
# 272356
# testy

using .NumericalMethods

# Definicja wspólnych parametrów
delta = 5e-6
epsilon = 5e-6
maxit = 100

# Zadanie 1: Testy metod dla równania sin(x) - (1/2)x^2 = 0
f1 = x -> sin(x) - (0.5*x)^2
pf1 = x -> cos(x) - 0.5*x

println("Testy dla równania sin(x) - (1/2)x^2 = 0:")
println("Metoda bisekcji:")
println(NumericalMethods.mbisekcji(f1, 1.5, 2.0, delta, epsilon))
println("Metoda Newtona:")
println(NumericalMethods.mstycznych(f1, pf1, 1.5, delta, epsilon, maxit))
println("Metoda siecznych:")
println(NumericalMethods.msiecznych(f1, 1.0, 2.0, delta, epsilon, maxit))

# Zadanie 5: Przecięcie wykresów y = 3x i y = exp(x)
f2 = x -> 3x - exp(x)
delta = 1e-4
epsilon = 1e-4
println("\nPrzecięcie wykresów y = 3x i y = exp(x):")
println(NumericalMethods.mbisekcji(f2, 0.0, 1.0, delta, epsilon))

# Zadanie 6: Równania f1(x) = e^(1-x) - 1 i f2(x) = x * e^(-x)
f3 = x -> exp(1 - x) - 1
pf3 = x -> -exp(1 - x)
f4 = x -> x * exp(-x)
pf4 = x -> exp(-x) * (1 - x)
delta = 1e-5
epsilon = 1e-5

println("\nRównanie f1(x) = e^(1-x) - 1:")
println("Metoda bisekcji:")
println(NumericalMethods.mbisekcji(f3, 0.0, 1.01, delta, epsilon))
println("Metoda Newtona:")
println(NumericalMethods.mstycznych(f3, pf3, 1.5, delta, epsilon, maxit))
println("Metoda siecznych:")
println(NumericalMethods.msiecznych(f3, 0.0, 2.0, delta, epsilon, maxit))

println("\nRównanie f2(x) = x * e^(-x):")
println("Metoda bisekcji:")
println(NumericalMethods.mbisekcji(f4, -0.5, 1.0, delta, epsilon))
println("Metoda Newtona:")
println(NumericalMethods.mstycznych(f4, pf4, 1.5, delta, epsilon, maxit))
println("Metoda siecznych:")
println(NumericalMethods.msiecznych(f4, -0.5, 1.0, delta, epsilon, maxit))

println("\nTesty dla równania f2(x) = x * e^(-x)")
println("Metoda newtona:")
println(NumericalMethods.mstycznych(f4, pf4, 0.5, delta, epsilon, maxit))
println(NumericalMethods.mstycznych(f4, pf4, 1.0, delta, epsilon, maxit))