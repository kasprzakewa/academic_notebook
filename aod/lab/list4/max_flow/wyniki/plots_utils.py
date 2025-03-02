import matplotlib.pyplot as plt
import numpy as np
import collections
import sys

def plot_k_util(file_path, plot_name, util_type):
    # Wczytanie danych z pliku
    data = []
    with open(file_path, 'r') as file:
        for line in file:
            parts = line.split()
            if len(parts) == 3:
                try:
                    k = int(parts[0])
                    if (util_type == 'maxflow'):
                        util = float(parts[1])
                    else:
                        util = float(parts[2])
                    data.append((k, util))
                except ValueError:
                    print(f"Nieprawidłowy wiersz w pliku: {line.strip()}")

    if not data:
        print("Brak danych do analizy.")
        return

    # Grupowanie danych według k
    grouped_data = collections.defaultdict(list)
    for k, util in data:
        grouped_data[k].append(util)

    # Wyznaczenie średnich wartości dla każdego k
    average_utils = {k: np.mean(utils) for k, utils in grouped_data.items()}

    # Przygotowanie danych do wykresu
    all_k = [k for k, util in data]
    all_utils = [util for k, util in data]

    # Rysowanie wykresu
    plt.figure(figsize=(10, 6))

    # Punkty dla wszystkich wartości k i wyników
    plt.scatter(all_k, all_utils, color='green', label='Wszystkie punkty', alpha=0.4)

    # Średnie wyniki dla każdego k
    avg_k = list(average_utils.keys())
    avg_util = list(average_utils.values())
    plt.plot(avg_k, avg_util, color='green', marker='o', label='Średnia wartość')

    # Opisy osi i tytuł
    plt.xlabel('k')
    ylabel = 'max flow' if util_type == 'maxflow' else 'liczba ścieżek powiększających'
    plt.ylabel(ylabel)
    titel = 'max flow' if util_type == 'maxflow' else 'liczby ścieżek powiększających'
    plt.title(f'Wykres {titel} w zależności od k')
    plt.legend()
    plt.grid(True)
    plt.savefig(plot_name + '.png')

    # Wyświetlenie wykresu
    plt.show()

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Użycie: python script.py <sciezka_do_pliku> <nazwa_wykresu> <typ_util>")
        print("<typ_util>: maxflow lub augmenting_paths")
    else:
        file_path = sys.argv[1]
        plot_name = sys.argv[2]
        util_type = sys.argv[3].lower()

        if util_type not in ['maxflow', 'augmenting_paths']:
            print("Nieprawidłowy typ util. Wybierz 'maxflow' lub 'augmenting_paths'.")
        else:
            plot_k_util(file_path, plot_name, util_type)
