import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Wczytaj dane z pliku
plik_wejsciowy = './test/bm.txt'  # Zmień nazwę pliku na odpowiednią

data = pd.read_csv(plik_wejsciowy, sep=' ', header=None, names=['k', 'i', 'czas', 'wielkosc_najwiekszego_skojarzenia'])

# Unikalne wartości k i i
unique_k = data['k'].unique()
unique_i = data['i'].unique()

# Tworzenie wykresów dla każdego k
for k in unique_k:
    subset_k = data[data['k'] == k]
    plt.figure(figsize=(10, 6))
    
    # Scatter dla poszczególnych punktów
    sns.scatterplot(data=subset_k, x='i', y='wielkosc_najwiekszego_skojarzenia', label='wszystkie punkty', color='green', alpha=0.2)
    
    # Linia dla średnich wartości
    srednie_k = subset_k.groupby('i')['wielkosc_najwiekszego_skojarzenia'].mean().reset_index()
    
    # Średnie wartości jako punkty i linia
    # plt.scatter(srednie_k['i'], srednie_k['wielkosc_najwiekszego_skojarzenia'], color='red', label='Średnia (punkty)')
    plt.plot(srednie_k['i'], srednie_k['wielkosc_najwiekszego_skojarzenia'], color='green', label='średnia', marker='o')
    
    plt.title(f'Wielkość maksymalnego skojarzenia w zależności od i (k={k})')
    plt.xlabel('i')
    plt.ylabel('Wielkość maksymalnego skojarzenia')
    plt.legend()
    plt.grid(True)
    plt.savefig(f'wykres_skojarzenia_k_{k}.png')  # Zapis wykresu do pliku
    plt.show()

# Tworzenie wykresów dla każdego i
for i in unique_i:
    subset_i = data[data['i'] == i]
    plt.figure(figsize=(10, 6))
    
    # Scatter dla poszczególnych punktów
    sns.scatterplot(data=subset_i, x='k', y='czas', label='wszystkie punkty', color='green', alpha=0.2)
    
    # Linia dla średnich wartości
    srednie_i = subset_i.groupby('k')['czas'].mean().reset_index()
    
    # Średnie wartości jako punkty i linia
    # plt.scatter(srednie_i['k'], srednie_i['czas'], color='red', label='Średnia (punkty)')
    plt.plot(srednie_i['k'], srednie_i['czas'], color='green', label='średnia', marker='o')
    
    plt.title(f'Czas działania programu w zależności od k (i={i})')
    plt.xlabel('k')
    plt.ylabel('Czas działania programu')
    plt.legend()
    plt.grid(True)
    plt.savefig(f'wykres_czas_i_{i}.png')  # Zapis wykresu do pliku
    plt.show()
