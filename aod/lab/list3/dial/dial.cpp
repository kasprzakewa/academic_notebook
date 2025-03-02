#include "dial.hpp"
#include <fstream>
#include <iostream>
#include <sstream>
#include <chrono>

std::vector<uint_fast64_t> Dial::dial(uint_fast64_t start, uint_fast64_t max_weight) {
    uint_fast64_t bucket_count = max_weight + 1;
    std::vector<std::vector<uint_fast64_t>> buckets(bucket_count);
    std::vector<uint_fast64_t> dist(n + 1, std::numeric_limits<uint_fast64_t>::max());

    dist[start] = 0;
    buckets[0].push_back(start);

    uint_fast64_t current_bucket = 0;

    while (true) {
        while (current_bucket < bucket_count && buckets[current_bucket].empty()) {
            current_bucket++;
        }

        if (current_bucket == bucket_count) break;

        while (!buckets[current_bucket].empty()) {
            uint_fast64_t u = buckets[current_bucket].back();
            buckets[current_bucket].pop_back();

            for (const auto& edge : adj_list[u]) {
                uint_fast64_t v = edge.to;
                uint_fast64_t w = edge.weight;

                if (dist[u] + w < dist[v]) {
                    uint_fast64_t new_dist = dist[u] + w;
                    uint_fast64_t new_bucket = new_dist % bucket_count;

                    if (dist[v] != std::numeric_limits<uint_fast64_t>::max()) {
                        uint_fast64_t old_bucket = dist[v] % bucket_count;
                        buckets[old_bucket].erase(
                            std::remove(buckets[old_bucket].begin(), buckets[old_bucket].end(), v),
                            buckets[old_bucket].end()
                        );
                    }

                    dist[v] = new_dist;
                    buckets[new_bucket].push_back(v);
                }
            }
        }
    }

    return dist;
}

uint_fast64_t Dial::p2p_dial(uint_fast64_t start, uint_fast64_t end) {
    std::vector<uint_fast64_t> dist = dial(start, max_weight);
    return dist[end];
}

void Dial::test_min_vertex(std::ofstream& ofs) {
    std::cout << "Min vertex: " << min_vertex << "\n";
    auto start = std::chrono::high_resolution_clock::now();
    uint_fast64_t min_vertex = get_min_vertex();
    std::vector<uint_fast64_t> dist = dial(min_vertex, max_weight);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration = end - start;
    
    ofs << "p res " << n << " " << m << " dial\n";
    ofs << "c siec sklada sie z " << n << " wierzcholkow, " << m << " lukow,\n";
    ofs << "c koszty naleza do przedzialu [0," << max_weight << "]\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";
    ofs << "c sredni czas wyznaczenia najkrotszych sciezek miedzy zrodlem\n";
    ofs << "c a wszystkimi wierzcholkami wynosi " << duration.count() << " sec:\n";
    ofs << "t " << duration.count() << "\n";
}

 void Dial::test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file) {
    ofs << "p res sp ss dial\n";
    ofs << "f " << input_file << " " << source_file << "\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";

    double total_time = 0.0;

    for (uint_fast64_t source : sources) {
        auto start = std::chrono::high_resolution_clock::now();
        std::vector<uint_fast64_t> dist = dial(source, max_weight);
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> duration = end - start;
        total_time += duration.count();

        ofs << "c shortest paths from source: " << source << "\n";
        for (uint_fast64_t i = 1; i <= n; i++) {
            ofs << "d " << source << " " << i << " " 
                << (dist[i] == std::numeric_limits<uint_fast64_t>::max() ? -1 : dist[i]) << "\n";
        }
    }

    ofs << "t " << (total_time / sources.size()) << "\n";
    ofs.close();
}

void Dial::test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file) {

    ofs << "p res sp p2p dial\n";
    ofs << "f " << input_file << " " << pairs_file << "\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";

    for (const auto& pair : pairs) {
        uint_fast64_t u = pair.first;
        uint_fast64_t v = pair.second;

        auto start = std::chrono::high_resolution_clock::now();
        uint_fast64_t dist = p2p_dial(u, max_weight);
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> duration = end - start;

        ofs << "d " << u << " " << v << " " << dist << "\n";
    }

    ofs.close();
}
