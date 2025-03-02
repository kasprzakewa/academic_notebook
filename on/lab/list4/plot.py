import numpy as np

def function(n):
    a = 0
    b = 1
    # tablica rownoodleglych punktow na przedziale 0-1
    x = np.linspace(0, 1, n)
    y = np.linspace(0, 1, 1000000000)
    maximum = 0


    for point in y:
        il = iloczyn(x, n, point)
        if il > maximum:
            maximum = il

    print("maximum is ", maximum)
        
def iloczyn(x, n, point):
    result = 1
    for k in range(0, n):
        result *= (point - x[k])
    
    return result

function(10)