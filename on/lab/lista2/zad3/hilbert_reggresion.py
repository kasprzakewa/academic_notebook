# Ewa Kasprzak
# 272356
# zadanie 3 - regresja

import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.metrics import mean_squared_error, r2_score
import math

# Twoje dane
n = np.arange(1, 101)
error_gauss = np.array([
    0.0, 5.661048867003676e-16, 8.022593772267726e-15, 4.137409622430382e-14, 1.6828426299227195e-12,
    2.618913302311624e-10, 1.2606867224171548e-8, 6.124089555723088e-8, 3.8751634185032475e-6,
    8.67039023709691e-5, 0.00015827808158590435, 0.13396208372085344, 0.11039701117868264, 1.4554087127659643,
    4.696668350857427, 54.15518954564602, 13.707236683836307, 10.257619124632317, 102.15983486270827,
    108.31777346206205, 44.089455838364245, 17.003425713362045, 25.842511917947366, 39.638573210187644,
    7.095757204652332, 63.80426636186403, 27.43309009053957, 276.91498822022265, 60.095450394724104,
    24.80615905441871, 21.45662601984968, 36.582441571177284, 37.556822732776205, 88.87380459381126,
    31.166902974731222, 15.563379312608332, 13.974714130452178, 72.12122789133323, 118.20336501589891,
    23.926484807638683, 41.348771577098454, 229.6423260398746, 53.18930954995268, 124.67413636996757,
    244.58124814685377, 69.14584939886464, 41.43803149349302, 58.952689545073156, 24.15062009750964,
    63.36958239742337, 44.17485839725116, 204.2938614173205, 845.0038584060173, 87.81389404828403,
    65.74841541183741, 128.52956069394094, 202.94297451029178, 77.80055608761916, 38.50172820107569,
    70.1365120366703, 70.48680315009305, 80.80535815640319, 1171.0957524521189, 477.5969557098007,
    224.6025726100588, 107.82249342677177, 869.2998457902479, 49.24285768599905, 91.14593211007856,
    95.4658793893325, 84.10744229656258, 42.307092357724784, 214.99913455636872, 199.14895020929498,
    97.10864536535114, 1612.1048069422793, 37.417510728026784, 62.09769674348925, 45.36521940779337,
    293.45873017622085, 78.95317735757816, 161.88088276379915, 69.9640016649769, 120.20158561989435,
    122.07049123242011, 279.40085636257396, 353.5804231763829, 111.9320896367902, 134.7871645479996,
    114.53822042443291, 244.6527772785898, 53.59876456176126, 398.36773229867356, 3955.9820272274083,
    910.0568760357633, 122.78969148367484, 84.35531964232052, 205.62746079396595, 50.03257312320969,
    122.08330990077465
])

conds_gauss = ([1.0, 19.28147006790397, 524.0567775860644, 15513.73873892924, 476607.2502425855, 1.4951058642254734e7, 4.753673567446793e8, 1.5257575538060041e10, 4.9315375594102344e11, 1.602441698742836e13, 5.222701316549833e14, 1.7515952300879806e16, 3.1883950689209334e18, 6.200786281355982e17, 3.67568286586649e17, 7.046389953630175e17, 1.249010044779401e18, 2.2477642911280653e18, 6.472700911391398e18, 1.1484020388436145e18, 3.2902428208431683e18, 1.093638219471544e19, 6.313779002744782e17, 2.1608428256899587e18, 1.3309197502927598e18, 5.825077809111695e18, 4.414670357556845e18, 5.889050001520599e18, 8.060274133463556e18, 5.512691295390715e18, 2.4040817319121502e19, 4.150195034190458e18, 1.1705237268888885e19, 4.56520144655429e18, 2.5524196131500777e19, 4.3381250003280466e18, 5.871718859396612e18, 2.563062353713175e19, 9.058525451393528e18, 6.584302662074187e18, 1.052376926308958e20, 2.6942022106451685e19, 3.891698791143783e19, 6.217427302987128e19, 1.1757348627810804e19, 1.5700045048756816e19, 1.2560652367315313e19, 6.715658888087732e18, 6.145459250718421e18, 2.3756325491900666e19, 1.0954570596695046e19, 1.1181915944118233e19, 1.5742943175983743e19, 5.6016350857096634e19, 1.397336450556287e19, 1.3226958264956718e20, 8.190646875595796e19, 1.4761377626051278e20, 1.0301535128466271e20, 1.5793843567095167e19, 9.02594600748171e18, 2.117203311967843e19, 5.464856320181306e19, 1.3689962392997861e19, 2.9970578787203408e19, 4.008315316366072e19, 3.3004955369925063e19, 2.2830192552072925e19, 1.0365448430956399e19, 4.090379535300334e19, 4.173680705336652e19, 1.3444081220511009e19, 2.6428343134908862e19, 8.217848436644733e19, 1.1867171248231748e19, 7.683350860155613e20, 5.070621522849007e19, 3.3084979663517553e19, 5.066840404055513e19, 2.2651725721104888e19, 1.993271967369309e19, 5.800062572517357e19, 2.721808531908327e19, 3.421518831864872e19, 7.01058362948007e19, 1.3863343121032901e20, 3.83087980092215e19, 3.3523314615853216e19, 2.5205541120204354e19, 2.1568171451928715e19, 1.4891908072699793e19, 4.578289413225024e19, 5.466483700113431e20, 6.443024727864211e19, 1.4481424267237818e20, 2.900131392231371e19, 2.2901437765462442e20, 2.000222082936708e19, 3.1190087510226334e19, 3.0310502811585376e19])

errors_inv = np.array([0.0, 1.4043333874306803e-15, 0.0, 0.0, 3.3544360584359632e-12, 2.0163759404347654e-10, 4.713280397232037e-9, 3.07748390309622e-7, 4.541268303176643e-6, 0.0002501493411824886, 0.007618304284315809, 0.258994120804705, 5.331275639426837, 8.71499275104814, 7.344641453111494, 29.84884207073541, 10.516942378369349, 24.762070989128866, 109.94550732878284, 114.34403152557572, 34.52041154914292, 102.60161611995359, 22.272314298730727, 43.34914763015038, 21.04404299195525, 100.78434642499187, 35.68974530952139, 290.1167291705239, 43.40383683199056, 59.97231132227779, 23.74575780277118, 67.4381226943068, 32.889697413799794, 95.99116506490786, 36.723963451169304, 19.599011323097056, 16.39248770656996, 95.5655782183542, 263.5309838641091, 140.97274594056717, 40.75749340255354, 333.75226335487844, 54.52704305417691, 94.88356401052424, 179.92316617880468, 109.17112219679052, 83.82203728470037, 156.78973560359313, 35.92139018094681, 69.99768122728987, 55.809761559471625, 106.1172474183331, 744.7484527726867, 210.2464613988427, 189.75267252733053, 203.2090182892432, 179.84690703784088, 65.9494080848084, 156.62599163518624, 99.03812956663859, 67.11583016786831, 203.6011778456271, 795.5588000438513, 1086.5423819592033, 221.36543764872084, 315.9536161669259, 1068.4564344561395, 48.199644446108316, 86.36329259284261, 180.67098158083874, 147.7797386446267, 156.2338130673944, 170.47938021261336, 140.07241812343403, 112.68964045660078, 1301.5486948199118, 79.29251845602542, 92.62913885763327, 50.017774639937315, 300.6126663927216, 72.90816290059583, 285.5492838080292, 88.90702113948724, 129.4939160484596, 74.63520075111316, 287.4632883651759, 434.40265952147627, 155.09104478150795, 183.30488730421865, 162.86993783309939, 286.3271949181511, 67.98856424373786, 1017.1915095683285, 8152.156411830031, 869.5414679244335, 65.3038672337961, 130.35187655709555, 189.19835301302587, 250.89155610852345, 289.58478909269746])

# Logarytmowanie zmiennej zależnej
error_gauss_log = np.log(error_gauss[error_gauss > 0])
n_log_errors = n[error_gauss > 0].reshape(-1, 1)

# Logarytmowanie zmiennej niezależnej, nie trzeba usuwać miejsc, gdzie conds_gauss = 0, bo conds >= 1
conds_gauss_log = np.log(conds_gauss)
n_log_conds = n.reshape(-1, 1)

# Logarytmowanie zmiennej zależnej
errors_inv_log = np.log(errors_inv[errors_inv > 0])
n_log_errors_inv = n[errors_inv > 0].reshape(-1, 1)



def polynomial_reg(degree, gauss_log, n_log):
    poly = PolynomialFeatures(degree)
    n_poly = poly.fit_transform(n_log)

    model_poly = LinearRegression()
    model_poly.fit(n_poly, gauss_log)
    y_pred_poly = model_poly.predict(n_poly)
    return y_pred_poly

def exponential_reg(gauss_log, n_log):
    model_exp = LinearRegression()
    model_exp.fit(n_log, gauss_log)
    y_pred_exp = model_exp.predict(n_log)
    return y_pred_exp

print("_________________________________ERRORS GAUSS_________________________________")
#Regresja wykładnicza
y_pred_exp = exponential_reg(error_gauss_log, n_log_errors)
mse_exp = mean_squared_error(error_gauss_log, y_pred_exp)
r2_exp = r2_score(error_gauss_log, y_pred_exp)
print(f"Regresja wykładnicza - MSE: {mse_exp}, R2: {r2_exp}")

mse_poly_values = []
r2_poly_values = []

plt.figure(figsize=(10, 20))

# Regresja wielomianowa
for i in range(2, 10):
    degree = i
    y_pred_poly = polynomial_reg(degree, error_gauss_log, n_log_errors)
    mse_poly = mean_squared_error(error_gauss_log, y_pred_poly)
    r2_poly = r2_score(error_gauss_log, y_pred_poly)
    mse_poly_values.append(mse_poly)
    r2_poly_values.append(r2_poly)
    print(f"Regresja wielomianowa stopnia {degree} - MSE: {mse_poly}, R2: {r2_poly}")

    # Wizualizacja
    plt.subplot(4, 2, i-1)
    plt.scatter(n_log_errors, error_gauss_log, color='blue', label='Dane rzeczywiste', s=2)
    plt.plot(n_log_errors, y_pred_exp, color='red', label='Regresja wykładnicza')
    plt.plot(n_log_errors, y_pred_poly, color='green', label=f'Regresja wielomianowa stopnia {degree}')
    plt.xlabel('log(n)')
    plt.ylabel('log(error_gauss)')
    plt.legend()

    plt.text(0.05, 0.95, f'MSE: {mse_poly:.4f}\nR²: {r2_poly:.4f}', transform=plt.gca().transAxes,
             verticalalignment='top', bbox=dict(boxstyle='round,pad=0.3', edgecolor='black', facecolor='white'))

plt.savefig(f'wykres_err_gauss.png')
plt.tight_layout()
plt.show()

# Wizualizacja funkcji, dla ktorej log jest stale rowny 1
plt.plot(range(2, 10), [1]*8, color='black', label='y=1')
plt.scatter(range(2, 10), mse_poly_values, color='blue', label='MSE')
plt.scatter(range(2, 10), r2_poly_values, color='red', label='R2')
plt.xlabel('Stopień wielomianu')
plt.ylabel('Wartość')
plt.legend()
plt.savefig('wykres_mse_r2_err_gauss.png')
plt.show()

# stopien wielomianu, dla ktorego mse i r2 sa najblizsze 1
min_dist = math.inf
best_degree = 0
for i in range(1, 9):
    dist = abs(mse_poly_values[i - 1] - 1) + abs(r2_poly_values[i-1] - 1)
    if dist < min_dist:
        min_dist = dist
        best_degree = i + 1

print(f"Najlepszy stopień wielomianu: {best_degree}")


print()
print()
print("_________________________________ERRORS INV_________________________________")
# Regresja wykładnicza
y_pred_exp = exponential_reg(errors_inv_log, n_log_errors_inv)
mse_exp = mean_squared_error(errors_inv_log, y_pred_exp)
r2_exp = r2_score(errors_inv_log, y_pred_exp)
print(f"Regresja wykładnicza - MSE: {mse_exp}, R2: {r2_exp}")

mse_poly_values = []
r2_poly_values = []

plt.figure(figsize=(10, 20))

# Regresja wielomianowa
for i in range(2, 10):
    degree = i
    y_pred_poly = polynomial_reg(degree, errors_inv_log, n_log_errors_inv)
    mse_poly = mean_squared_error(errors_inv_log, y_pred_poly)
    r2_poly = r2_score(errors_inv_log, y_pred_poly)
    mse_poly_values.append(mse_poly)
    r2_poly_values.append(r2_poly)
    print(f"Regresja wielomianowa stopnia {degree} - MSE: {mse_poly}, R2: {r2_poly}")

    # Wizualizacja
    plt.subplot(4, 2, i - 1)
    plt.scatter(n_log_errors_inv, errors_inv_log, color='blue', label='Dane rzeczywiste', s=2)
    plt.plot(n_log_errors_inv, y_pred_exp, color='red', label='Regresja wykładnicza')
    plt.plot(n_log_errors_inv, y_pred_poly, color='green', label=f'Regresja wielomianowa stopnia {degree}')
    plt.xlabel('log(n)')
    plt.ylabel('log(errors_inv)')
    plt.legend()

    plt.text(0.05, 0.95, f'MSE: {mse_poly:.4f}\nR²: {r2_poly:.4f}', transform=plt.gca().transAxes,
             verticalalignment='top', bbox=dict(boxstyle='round,pad=0.3', edgecolor='black', facecolor='white'))

plt.savefig(f'wykres_err_inv.png')
plt.tight_layout()
plt.show()

# Wizualizacja funkcji, dla ktorej log jest stale rowny 1
plt.plot(range(2, 10), [1]*8, color='black', label='y=1')
plt.scatter(range(2, 10), mse_poly_values, color='blue', label='MSE')
plt.scatter(range(2, 10), r2_poly_values, color='red', label='R2')
plt.xlabel('Stopień wielomianu')
plt.ylabel('Wartość')
plt.legend()
plt.savefig('wykres_mse_r2_err_inv.png')
plt.show()

# stopien wielomianu, dla ktorego mse i r2 sa najblizsze 1
min_dist = math.inf
best_degree = 0
for i in range(1, 9):
    dist = abs(mse_poly_values[i-1] - 1) + abs(r2_poly_values[i-1] - 1)
    if dist < min_dist:
        min_dist = dist
        best_degree = i + 1

print(f"Najlepszy stopień wielomianu: {best_degree}")



print()
print()
print("_________________________________CONDS_________________________________")
# Regresja wykładnicza
y_pred_exp = exponential_reg(conds_gauss_log, n_log_conds)
mse_exp = mean_squared_error(conds_gauss_log, y_pred_exp)
r2_exp = r2_score(conds_gauss_log, y_pred_exp)
print(f"Regresja wykładnicza - MSE: {mse_exp}, R2: {r2_exp}")

mse_poly_values = []
r2_poly_values = []

plt.figure(figsize=(10, 20))

# Regresja wielomianowa
for i in range(2, 10):
    degree = i
    y_pred_poly = polynomial_reg(degree, conds_gauss_log, n_log_conds)
    mse_poly = mean_squared_error(conds_gauss_log, y_pred_poly)
    r2_poly = r2_score(conds_gauss_log, y_pred_poly)
    mse_poly_values.append(mse_poly)
    r2_poly_values.append(r2_poly)
    print(f"Regresja wielomianowa stopnia {degree} - MSE: {mse_poly}, R2: {r2_poly}")

    # Wizualizacja
    plt.subplot(4, 2, i - 1)
    plt.scatter(n_log_conds, conds_gauss_log, color='blue', label='Dane rzeczywiste', s=2)
    plt.plot(n_log_conds, y_pred_exp, color='red', label='Regresja wykładnicza')
    plt.plot(n_log_conds, y_pred_poly, color='green', label=f'Regresja wielomianowa stopnia {degree}')
    plt.xlabel('log(n)')
    plt.ylabel('log(conds_gauss)')
    plt.legend()

    plt.text(0.05, 0.95, f'MSE: {mse_poly:.4f}\nR²: {r2_poly:.4f}', transform=plt.gca().transAxes,
             verticalalignment='top', bbox=dict(boxstyle='round,pad=0.3', edgecolor='black', facecolor='white'))


plt.savefig(f'wykres_conds.png')
plt.tight_layout()
plt.show()

# Wizualizacja funkcji, dla ktorej log jest stale rowny 1
plt.plot(range(2, 10), [1]*8, color='black', label='y=1')
plt.scatter(range(2, 10), mse_poly_values, color='blue', label='MSE')
plt.scatter(range(2, 10), r2_poly_values, color='red', label='R2')
plt.xlabel('Stopień wielomianu')
plt.ylabel('Wartość')
plt.legend()
plt.savefig('wykres_mse_r2_conds.png')
plt.show()

# stopien wielomianu, dla ktorego mse i r2 sa najblizsze 1
min_dist = math.inf
best_degree = 0
for i in range(1, 9):
    dist = abs(mse_poly_values[i-1] - 1) + abs(r2_poly_values[i-1] - 1)
    if dist < min_dist:
        min_dist = dist
        best_degree = i + 1

print(f"Najlepszy stopień wielomianu: {best_degree}")
