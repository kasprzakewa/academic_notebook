import matplotlib.pyplot as plt
import numpy as np
import collections
import sys

def plot_k_time(file_paths, plot_name):
    # Inicjalizacja figury
    plt.figure(figsize=(10, 6))

    # Lista kolorów
    colors = ['blue', 'green', 'red', 'orange', 'purple', 'cyan', 'magenta']
    label = ['edmonds karp', 'shortest augmenting path']
    color_index = 0
    label_index = 0

    # Przetwarzanie każdego pliku osobno
    for file_path in file_paths:
        try:
            # Wczytanie danych z pliku
            data = []
            with open(file_path, 'r') as file:
                for line in file:
                    parts = line.split()
                    if len(parts) == 2:
                        try:
                            k = int(parts[0])
                            time = float(parts[1])
                            data.append((k, time))
                        except ValueError:
                            print(f"Nieprawidłowy wiersz w pliku {file_path}: {line.strip()}")
        except FileNotFoundError:
            print(f"Plik nie znaleziony: {file_path}")
            continue

        if not data:
            print(f"Brak danych w pliku: {file_path}")
            continue

        # Grupowanie danych według k
        grouped_data = collections.defaultdict(list)
        for k, time in data:
            grouped_data[k].append(time)

        # Wyznaczenie średnich czasów dla każdego k
        average_times = {k: np.mean(times) for k, times in grouped_data.items()}

        # Przygotowanie danych do wykresu
        all_k = [k for k, time in data]
        all_times = [time for k, time in data]

        # Rysowanie punktów i średnich dla aktualnego pliku
        color = colors[color_index % len(colors)]  # Użyj kolejnego koloru
        labels = label[label_index]
        plt.scatter(all_k, all_times, color=color, label=f'Punkty: {labels}', alpha=0.4)
        avg_k = list(average_times.keys())
        avg_time = list(average_times.values())
        plt.plot(avg_k, avg_time, color=color, marker='o', label=f'Średnia: {labels}')
        
        color_index += 1
        label_index = (label_index + 1) % 2


    # Opisy osi i tytuł
    plt.xlabel('k')
    plt.ylabel('Czas')
    plt.title('Wykres czasu w zależności od k')
    plt.legend()
    plt.grid(True)
    plt.savefig(plot_name + '.png')

    # Wyświetlenie wykresu
    plt.show()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Użycie: python script.py <ścieżka_do_pliku1> <ścieżka_do_pliku2> ... <nazwa_wykresu>")
    else:
        *file_paths, plot_name = sys.argv[1:]
        plot_k_time(file_paths, plot_name)
