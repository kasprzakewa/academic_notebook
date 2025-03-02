#include "graph.hpp"

uint_fast64_t Graph::get_n() {
    return n;
}

void Graph::set_n(uint_fast64_t n) {
    this->n = n;
}

uint_fast64_t Graph::get_m() {
    return m;
}

void Graph::set_m(uint_fast64_t m) {
    this->m = m;
}

uint_fast64_t Graph::get_min_vertex() {
    return min_vertex;
}

void Graph::set_min_vertex(uint_fast64_t min_vertex) {
    this->min_vertex = min_vertex;
}

uint_fast64_t Graph::get_max_weight() {
    return max_weight;
}

void Graph::set_max_weight(uint_fast64_t max_weight) {
    this->max_weight = max_weight;
}

std::unordered_map<uint_fast64_t, std::vector<Edge>> Graph::get_adj_list() {
    return adj_list;
}

void Graph::set_adj_list(std::unordered_map<uint_fast64_t, std::vector<Edge>> adj_list) {
    this->adj_list = adj_list;
}

void Graph::add_edge(uint_fast64_t u, uint_fast64_t v, uint_fast64_t w) {
    if (adj_list.contains(u)) {
        for (uint_fast64_t i = 0; i < adj_list[u].size(); i++) {
            if (adj_list[u][i].to == v) {
                adj_list[u][i].weight = w;
                // throw EdgeAlreadyExistsException();
            }
        }
    }
    adj_list[u].push_back(Edge{v, w});

}

void Graph::print_graph() {
    for (auto it = adj_list.begin(); it != adj_list.end(); ++it) {
        std::cout << it->first << " -> [ ";
        for (const auto& e : it->second) {
            std::cout << "(to: " << e.to << ", weight: " << e.weight << ") ";
        }
        std::cout << "]\n";
    }
}

void Graph::from_file(const std::string& filename, const std::string& file_type) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        throw std::runtime_error("Could not open file: " + filename);
    }

    std::string line;
    if (file_type == "graph") {
        while (std::getline(file, line)) {
            if (line.empty() || line[0] == 'c') {
                continue;
            }

            std::istringstream iss(line);
            char type;
            iss >> type;

            if (type == 'p') {
                std::string problem;
                iss >> problem >> n >> m;
            } else if (type == 'a') {
                uint_fast64_t u, v, w;
                iss >> u >> v >> w;
                if (u < min_vertex) {
                    min_vertex = u;
                }
                if (v < min_vertex) {
                    min_vertex = v;
                }
                if (w > max_weight) {
                    max_weight = w;
                }
                add_edge(u, v, w);
            }
        }
    } else if (file_type == "sources") {
        while (std::getline(file, line)) {
            if (line.empty() || line[0] == 'c') {
                continue;
            }

            std::istringstream iss(line);
            char type;
            iss >> type;

            if (type == 'p') {
                std::string aux;
                std::string sp;
                std::string problem;
                uint_fast64_t x;
                iss >> aux >> sp >> problem >> x;
                sources.resize(x);
            } else if (type == 's') {
                uint_fast64_t source;
                iss >> source;
                sources.push_back(source);
            }
        }
    } else if (file_type == "pairs") {
        while (std::getline(file, line)) {
            if (line.empty() || line[0] == 'c') {
                continue;
            }

            std::istringstream iss(line);
            char type;
            iss >> type;

            if (type == 'p') {
                std::string aux;
                std::string sp;
                std::string problem;
                uint_fast64_t x;
                iss >> aux >> sp >> problem >> x;
            }

            if (type == 'q') {
                uint_fast64_t u, v;
                iss >> u >> v;
                pairs.emplace_back(u, v);
            }
        }
    }

    file.close();
}


void Graph::test_min_vertex(std::ofstream& ofs) { 
    
} 

void Graph::test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file) { 
    
}

void Graph::test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file) {

}

uint_fast64_t Graph::random_number(uint_fast64_t n) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<uint_fast64_t> dis(1, n);
    return dis(gen);
}