# Ewa Kasprzak
# 272356
# zadanie 4

using Polynomials

# definicja wielomianu wilkinsona w postaci naturalnej
P = Polynomial([2432902008176640000.0, -8752948036761600000.0, 13803759753640704000.0, -12870931245150988800.0, 8037811822645051776.0, -3599979517947607200.0, 1206647803780373360.0, -311333643161390640.0, 63030812099294896.0, -10142299865511450.0, 1307535010540395.0, -135585182899530.0, 11310276995381.0, -756111184500.0, 40171771630.0, -1672280820.0, 53327946.0, -1256850.0, 20615.0, -210.0, 1.0], :x)

# definicja zmodyfikowanego wielomianu wilkinsona w postaci naturalnej
P_modified = Polynomial([2432902008176640000.0, -8752948036761600000.0, 13803759753640704000.0, -12870931245150988800.0, 8037811822645051776.0, -3599979517947607200.0, 1206647803780373360.0, -311333643161390640.0, 63030812099294896.0, -10142299865511450.0, 1307535010540395.0, -135585182899530.0, 11310276995381.0, -756111184500.0, 40171771630.0, -1672280820.0, 53327946.0, -1256850.0, 20615.0, -210.0-2^(-23), 1.0], :x)

# definicja wielomianu wilkinsona w postaci iloczynowej
p(x) = (x - 20)*(x - 19)*(x - 18)*(x - 17)*(x - 16)*(x - 15)*(x - 14)*(x - 13)*(x - 12)*(x - 11)*(x - 10)*(x - 9)*(x - 8)*(x - 7)*(x - 6)*(x - 5)*(x - 4)*(x - 3)*(x - 2)*(x - 1)

# obliczenie pierwiastków wielomianu wilkinsona
A = roots(P)

# obliczenie pierwiastków zmodyfikowanego wielomianu wilkinsona
A_modified = roots(P_modified)

# faktyczne pierwiastki zmodyfikowanego wielomianu wilkinsona
modified_roots = [1.00000, 2.00000, 3.00000, 4.00000, 5.00000, 6.00001, 6.99970, 8.00727, 8.91725, 10.09527 + 0.64350im, 10.09527 - 0.64350im, 11.79363 + 1.65233im, 11.79363 - 1.65233im, 13.99236 + 2.51883im, 13.99236 - 2.51883im, 16.73074 + 2.81262im, 16.73074 - 2.81262im, 19.50244 + 1.94033im, 19.50244 - 1.94033im, 20.84691]

println("\\hline")
println("\\textbf{\\( k \\)} & \\textbf{\\( z_k \\)} & \\textbf{\\( \\left|P(z_k) \\right|\\)} & \\textbf{\\( \\left|p(z_k)\\right|\\)} & \\textbf{\\( \\left|z_k - k\\right| \\)} \\\\")
for i in 1:20
    println(modified_roots[i], " & ", A_modified[i], " & ", abs(P(A_modified[i])), " & ", abs(p(A_modified[i])), " & ", abs(A_modified[i] - modified_roots[i]), " \\\\")
    println("\\hline")
end


println("\\hline")
println("\\textbf{\\( k \\)} & \\textbf{\\( z_k \\)} & \\textbf{\\( \\left|P(z_k) \\right|\\)} & \\textbf{\\( \\left|z_k - k\\right|\\)} \\\\")
println("\\hline")
for i in 1:20
    println(i, " & ", A[i], " & ", abs(P(A[i])), " & ", abs(A[i] - i), " \\\\")
    println("\\hline")
end
