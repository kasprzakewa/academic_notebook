include("blocksys.jl")
include("matrixgen.jl")
using .blocksys
using .matrixgen

filename = "A.txt"
blockmat(12, 3, 10.0, filename)
matrix = read_matrix_from_file(filename)
display_matrix(matrix)
