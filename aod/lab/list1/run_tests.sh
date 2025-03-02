#Ewa Kasprzak 272356

#!/bin/bash

files_1=("1/d_1_1_r.txt" "1/d_1_2_r.txt" "1/d_1_3_r.txt" "1/d_1.txt" "1/u_1_1_r.txt" "1/u_1_2_r.txt" "1/u_1_3_r.txt" "1/u_1.txt")
files_2=("2/g2a-1.txt" "2/g2a-2.txt" "2/g2a-3.txt" "2/g2a-4.txt" "2/g2a-5.txt" "2/g2a-6.txt" "2/g2b-1.txt" "2/g2b-2.txt" "2/g2b-3.txt" "2/g2b-4.txt" "2/g2b-5.txt" "2/g2b-6.txt")
files_3=("3/g3-1.txt" "3/g3-2.txt" "3/g3-3.txt" "3/g3-4.txt" "3/g3-5.txt" "3/g3-6.txt" "3/s_c_c.txt" "3/s_s.txt")
files_4=("4/d4a-1.txt" "4/d4a-2.txt" "4/d4a-3.txt" "4/d4a-4.txt" "4/d4a-5.txt" "4/d4a-6.txt" "4/d4b-1.txt" "4/d4b-2.txt" "4/d4b-3.txt" "4/d4b-4.txt" "4/d4b-5.txt" "4/d4b-6.txt" "4/u4a-1.txt" "4/u4a-2.txt" "4/u4a-3.txt" "4/u4a-4.txt" "4/u4a-5.txt" "4/u4a-6.txt" "4/u4b-1.txt" "4/u4b-2.txt" "4/u4b-3.txt" "4/u4b-4.txt" "4/u4b-5.txt" "4/u4b-6.txt" "4/d_d.txt" "4/d_n_d.txt" "4/u_d.txt" "4/u_n_d.txt")

for file in "${files_2[@]}"; do
    echo "TEST: $file"
    julia graph.jl "$file"
    echo ""
done
