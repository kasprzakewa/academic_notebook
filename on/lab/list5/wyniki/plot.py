import matplotlib.pyplot as plt
import argparse
import os
from collections import defaultdict
import numpy as np

# Funkcja do wczytania danych z pliku dla trybu czasu
def wczytaj_dane_z_pliku_time(nazwa_pliku):
    dane = defaultdict(list)
    
    with open(nazwa_pliku, 'r') as plik:
        for linia in plik:
            dane_linia = linia.split()
            n = int(dane_linia[0])  # Rozmiar macierzy
            wartosc = float(dane_linia[1])  # Czas
            dane[n].append(wartosc)  # Grupowanie danych według 'n'

    return dane

# Funkcja do wczytania danych z pliku dla trybu alokacji
def wczytaj_dane_z_pliku_allocation(nazwa_pliku):
    dane_size1 = defaultdict(list)
    dane_size2 = defaultdict(list)

    with open(nazwa_pliku, 'r') as plik:
        for linia in plik:
            dane_linia = linia.split()
            n = int(dane_linia[0])  # Rozmiar macierzy
            size1 = float(dane_linia[1])  # Wartość dla size1
            size2 = float(dane_linia[2])  # Wartość dla size2
            dane_size1[n].append(size1)
            dane_size2[n].append(size2)

    return dane_size1, dane_size2

# Funkcja obliczania średnich
def oblicz_srednia(dane):
    srednie = {}
    for n, wartosci in dane.items():
        srednia = np.mean(wartosci)  # Obliczenie średniej arytmetycznej
        srednie[n] = srednia
    return srednie

# Funkcja główna programu
def main():
    # Ustawienia argumentów wiersza poleceń
    parser = argparse.ArgumentParser(description="Wykres zależności czasu lub alokacji od wartości z pliku.")
    parser.add_argument('pliki', help="Ścieżki do plików z danymi (można podać wiele plików)", nargs='+')
    parser.add_argument('-s', '--save', help="Ścieżka do pliku, w którym ma zostać zapisany wykres", default=None)
    parser.add_argument('-m', '--mode', help="Tryb wyświetlania wykresu ('czas' lub 'alokacja')", choices=['czas', 'alokacja'], required=True)

    # Parsowanie argumentów
    args = parser.parse_args()

    # Lista kolorów do wykresu (będziemy je przypisywać do kolejnych plików)
    kolory = ['blue', 'green', 'red', 'orange', 'purple', 'brown', 'pink', 'grey']
    labels = ['Gauss', 'Gauss pivot', 'LU', 'LU pivot', 'Julia']
    
    # Wczytanie danych ze wszystkich plików
    for idx, plik in enumerate(args.pliki):
        if args.mode == 'czas':
            dane = wczytaj_dane_z_pliku_time(plik)
            srednie = oblicz_srednia(dane)

            # Rysowanie danych z danego pliku
            for n, wartosci in dane.items():
                plt.scatter([n] * len(wartosci), wartosci, color=kolory[idx % len(kolory)], alpha=0.5, label=f'{labels[idx]}' if n == list(dane.keys())[0] else "")

            # Rysowanie średnich
            srednie_n = list(srednie.keys())
            srednie_wartosci = list(srednie.values())
            plt.scatter(srednie_n, srednie_wartosci, color=kolory[idx % len(kolory)], label=f'Średnie {labels[idx]}', zorder=5, marker='o', s=20)
            plt.plot(srednie_n, srednie_wartosci, color=kolory[idx % len(kolory)], linestyle='-', linewidth=2)

        elif args.mode == 'alokacja':
            dane_size1, dane_size2 = wczytaj_dane_z_pliku_allocation(plik)
            srednie_size1 = oblicz_srednia(dane_size1)
            srednie_size2 = oblicz_srednia(dane_size2)

            # Rysowanie danych dla size1
            for n, wartosci in dane_size1.items():
                plt.scatter([n] * len(wartosci), wartosci, color=kolory[idx % len(kolory)], alpha=0.5, label=f'Pełna struktura Plik {idx+1}' if n == list(dane_size1.keys())[0] else "")
            srednie_n_size1 = list(srednie_size1.keys())
            srednie_wartosci_size1 = list(srednie_size1.values())
            plt.scatter(srednie_n_size1, srednie_wartosci_size1, color=kolory[idx % len(kolory)], label=f'Średnie pełna struktura Plik {idx+1}', zorder=5, marker='o', s=20)
            plt.plot(srednie_n_size1, srednie_wartosci_size1, color=kolory[idx % len(kolory)], linestyle='-', linewidth=2)

            # Rysowanie danych dla size2
            for n, wartosci in dane_size2.items():
                plt.scatter([n] * len(wartosci), wartosci, color=kolory[idx % len(kolory)], alpha=0.5, label=f'Zoptymalizowana struktura Plik {idx+1}' if n == list(dane_size2.keys())[0] else "")
            srednie_n_size2 = list(srednie_size2.keys())
            srednie_wartosci_size2 = list(srednie_size2.values())
            plt.scatter(srednie_n_size2, srednie_wartosci_size2, color=kolory[idx % len(kolory)], label=f'Średnie zoptymalizowana struktura Plik {idx+1}', zorder=5, marker='o', s=20)
            plt.plot(srednie_n_size2, srednie_wartosci_size2, color=kolory[idx % len(kolory)], linestyle='-', linewidth=2)

    # Ustawienia osi
    if args.mode == 'czas':
        plt.title('Zależność czasu od rozmiaru macierzy')
        plt.xlabel('Rozmiar macierzy')
        plt.ylabel('Czas (w sekundach)')
    elif args.mode == 'alokacja':
        plt.title('Zależność alokacji od rozmiaru macierzy')
        plt.xlabel('Rozmiar macierzy')
        plt.ylabel('Alokacja (w bajtach)')

    # Wspólne elementy wykresu
    plt.grid(True)
    plt.legend()

    # Zapis lub wyświetlenie wykresu
    if args.save:
        katalog = os.path.dirname(args.save)
        if katalog and not os.path.exists(katalog):
            os.makedirs(katalog)
            print(f"Katalog {katalog} został utworzony.")

        plt.savefig(args.save)
        print(f"Wykres zapisany do pliku: {args.save}")
    else:
        plt.show()


# Uruchomienie programu
if __name__ == '__main__':
    main()
