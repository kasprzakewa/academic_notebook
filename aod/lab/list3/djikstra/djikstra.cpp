#include "djikstra.hpp"

std::vector<uint_fast64_t> Djikstra::djikstra(uint_fast64_t start) {
    std::vector<uint_fast64_t> dist(n + 1, std::numeric_limits<uint_fast64_t>::max());
    dist[start] = 0;
    
    using P = std::pair<uint_fast64_t, uint_fast64_t>;
    std::priority_queue<P, std::vector<P>, std::greater<P>> minHeap;
    
    minHeap.push({0, start});
    
    while (!minHeap.empty()) {
        uint_fast64_t u = minHeap.top().second;
        uint_fast64_t d = minHeap.top().first;
        minHeap.pop();

        for (const Edge& e : adj_list[u]) {
            uint_fast64_t v = e.to;
            uint_fast64_t weight = e.weight;

            if (dist[v] > dist[u] + weight) {
                dist[v] = dist[u] + weight;
                minHeap.push({dist[v], v});
            }
        }
    }

    return dist;
}

uint_fast64_t Djikstra::p2p_djikstra(uint_fast64_t start, uint_fast64_t end) {
    std::vector<uint_fast64_t> dist = djikstra(start);
    return dist[end];
}

void Djikstra::test_min_vertex(std::ofstream& ofs) {
    std::cout << "Min vertex: " << min_vertex << "\n";
    auto start = std::chrono::high_resolution_clock::now();
    uint_fast64_t min_vertex = get_min_vertex();
    std::vector<uint_fast64_t> dist = djikstra(min_vertex);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration = end - start;
    
    ofs << "p res " << n << " " << m << " djikstra\n";
    ofs << "c siec sklada sie z " << n << " wierzcholkow, " << m << " lukow,\n";
    ofs << "c koszty naleza do przedzialu [0," << max_weight << "]\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";
    ofs << "c sredni czas wyznaczenia najkrotszych sciezek miedzy zrodlem\n";
    ofs << "c a wszystkimi wierzcholkami wynosi " << duration.count() << " sec:\n";
    ofs << "t " << duration.count() << "\n";
}

 void Djikstra::test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file) {

    ofs << "p res sp ss dijkstra\n";
    ofs << "f " << input_file << " " << source_file << "\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";

    double total_time = 0.0;

    for (uint_fast64_t source : sources) {
        auto start = std::chrono::high_resolution_clock::now();
        std::vector<uint_fast64_t> dist = djikstra(source);
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

void Djikstra::test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file) {

    ofs << "p res sp p2p dijkstra\n";
    ofs << "f " << input_file << " " << pairs_file << "\n";
    ofs << "g " << n << " " << m << " 0 " << max_weight << "\n";

    for (const auto& pair : pairs) {
        uint_fast64_t u = pair.first;
        uint_fast64_t v = pair.second;

        auto start = std::chrono::high_resolution_clock::now();
        uint_fast64_t dist = p2p_djikstra(u, v);
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> duration = end - start;

        ofs << "d " << u << " " << v << " " << dist << "\n";
    }

    ofs.close();
}



