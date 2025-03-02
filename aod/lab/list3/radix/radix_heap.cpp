#include "radix_heap.hpp"
#include <queue>
#include <unordered_set>
#include <limits>
#include <vector>
#include <utility>
#include <cmath>
#include <algorithm>

uint_fast64_t Radix::calculate_bucket(uint_fast64_t diff) {
    return 63 - __builtin_clz(diff);
}

void Radix::update_buckets(
    std::vector<uint_fast64_t>& dist,
    std::vector<std::vector<std::pair<uint_fast64_t, uint_fast64_t>>>& buckets,
    std::pair<uint_fast64_t, uint_fast64_t>& min,
    std::unordered_set<uint_fast64_t>& not_visited) {

    for (auto& bucket : buckets) {
        bucket.clear();
    }

    std::vector<Edge> edges = get_adj_list()[min.second];

    for (const auto& edge : edges) {
        uint_fast64_t d = min.first + edge.weight;
        if (d < dist[edge.to]) {
            dist[edge.to] = d;
        }
    }

    not_visited.erase(min.second);

    for (uint_fast64_t i : not_visited) {
        uint_fast64_t diff = dist[i] - min.first;
        uint_fast64_t bucket = calculate_bucket(diff);
        buckets[bucket].emplace_back(dist[i], i);
    }

    min = {std::numeric_limits<uint_fast64_t>::max(), std::numeric_limits<uint_fast64_t>::max()};
    for (const auto& bucket : buckets) {
        if (!bucket.empty()) {
            for (const auto& candidate : bucket) {
                if (candidate.first < min.first) {
                    min = candidate;
                }
            }
        }
    }

    if (min.first == std::numeric_limits<uint_fast64_t>::max() && !not_visited.empty()) {
        uint_fast64_t next = *not_visited.begin();
        min = {dist[next], next};
    }
}

void Radix::pre_work(std::vector<uint_fast64_t>& dist,
                     std::unordered_set<uint_fast64_t>& not_visited,
                     uint_fast64_t start,
                     std::pair<uint_fast64_t, uint_fast64_t>& min) {

    uint_fast64_t n = get_n();

    dist.assign(n + 1, std::numeric_limits<uint_fast64_t>::max());
    dist[start] = 0;

    for (uint_fast64_t i = 1; i <= n; ++i) {
        not_visited.insert(i);
    }

    min = {0, start};
}

std::vector<uint_fast64_t> Radix::radix_djikstra(uint_fast64_t start) {
    uint_fast64_t n = get_n();

    std::vector<uint_fast64_t> dist(n + 1);
    std::unordered_set<uint_fast64_t> not_visited;
    std::vector<std::vector<std::pair<uint_fast64_t, uint_fast64_t>>> buckets(65);
    std::pair<uint_fast64_t, uint_fast64_t> min;

    pre_work(dist, not_visited, start, min);

    while (!not_visited.empty()) {
        update_buckets(dist, buckets, min, not_visited);
    }

    return dist;
}

uint_fast64_t Radix::p2p_radix(uint_fast64_t start, uint_fast64_t end) {
    std::vector<uint_fast64_t> dist = radix_djikstra(start);
    return dist[end];
}

void Radix::test_min_vertex(std::ofstream& ofs) {
    std::cout << "Min vertex: " << min_vertex << "\n";
    auto start = std::chrono::high_resolution_clock::now();
    uint_fast64_t min_vertex = get_min_vertex();
    std::vector<uint_fast64_t> dist = radix_djikstra(min_vertex);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration = end - start;
    
    ofs << "p res " << n << " " << m << " radix\n";
    ofs << "c siec sklada sie z " << n << " wierzcholkow, " << m << " lukow,\n";
    ofs << "c koszty naleza do przedzialu [0," << max_weight << "]\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";
    ofs << "c sredni czas wyznaczenia najkrotszych sciezek miedzy zrodlem\n";
    ofs << "c a wszystkimi wierzcholkami wynosi " << duration.count() << " sec:\n";
    ofs << "t " << duration.count() << "\n";
}

 void Radix::test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file) {

    ofs << "p res sp ss radix\n";
    ofs << "f " << input_file << " " << source_file << "\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";

    double total_time = 0.0;

    for (uint_fast64_t source : sources) {
        auto start = std::chrono::high_resolution_clock::now();
        std::vector<uint_fast64_t> dist = radix_djikstra(source);
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

void Radix::test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file) {

    ofs << "p res sp p2p radix\n";
    ofs << "f " << input_file << " " << pairs_file << "\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";

    for (const auto& pair : pairs) {
        uint_fast64_t u = pair.first;
        uint_fast64_t v = pair.second;

        auto start = std::chrono::high_resolution_clock::now();
        uint_fast64_t dist = p2p_radix(u, max_weight);
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> duration = end - start;

        ofs << "d " << u << " " << v << " " << dist << "\n";
    }

    ofs.close();
}

