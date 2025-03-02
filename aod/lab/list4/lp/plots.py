import pandas as pd
import matplotlib.pyplot as plt

# Wczytanie danych z pliku
plik_wejsciowy = '../bipartite_matching/test/bm_lp.txt'  # Zmień na ścieżkę do swojego pliku
data = pd.read_csv(plik_wejsciowy, sep=' ', header=None, names=['k', 'time', 'time2'])

# Sprawdzenie, czy dane zostały wczytane poprawnie
print(data.head())

# Tworzenie wykresu
plt.figure(figsize=(10, 6))

# Wykres dla 'time'
plt.plot(data['k'], data['time'], marker='o', label='time', color='green')

# Wykres dla 'time2'
# plt.plot(data['k'], data['time2'], marker='s', label='time2', linestyle='--', color='orange')

# Dodanie opisu osi, tytułu i legendy
plt.xlabel('k')
plt.ylabel('Czas')
plt.title('Czas działania modelu w zależności od k')
plt.legend()
plt.grid(True)

# Zapis wykresu do pliku
plt.savefig('wykres_model_bm.png')

# Wyświetlenie wykresu
plt.show()
