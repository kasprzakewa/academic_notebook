#ifndef GRAPH_HPP
#define GRAPH_HPP

#include <iostream>
#include <unordered_map>
#include <vector>
#include <queue>
#include <climits>
#include <stdexcept>
#include <fstream>
#include <sstream>
#include <chrono>
#include <random>
#include <deque>
#include <list>
#include <cstdint>

#include "../exception/negative_weight_exception.hpp"
#include "../exception/could_not_open_file_exception.hpp"
#include "../exception/edge_already_exists.hpp"

struct Edge {
    uint_fast64_t to = 0, weight = 0;
    Edge(uint_fast64_t t, uint_fast64_t w) : to(t), weight(w) {}
};

class Graph {
protected:
    uint_fast64_t n = 0, m = 0, min_vertex = INT_MAX, max_weight = 0;
    std::unordered_map<uint_fast64_t, std::vector<Edge>> adj_list;
    std::vector<uint_fast64_t> sources;
    std::vector<std::pair<uint_fast64_t, uint_fast64_t>> pairs;

public:
    virtual ~Graph() = default;

    virtual uint_fast64_t get_n();
    virtual void set_n(uint_fast64_t n);

    virtual uint_fast64_t get_m();
    virtual void set_m(uint_fast64_t m);

    virtual uint_fast64_t get_min_vertex();
    virtual void set_min_vertex(uint_fast64_t min_vertex);

    virtual uint_fast64_t get_max_weight();
    virtual void set_max_weight(uint_fast64_t max_weight);

    virtual std::unordered_map<uint_fast64_t, std::vector<Edge>> get_adj_list();
    virtual void set_adj_list(std::unordered_map<uint_fast64_t, std::vector<Edge>> adj_list);

    virtual void add_edge(uint_fast64_t u, uint_fast64_t v, uint_fast64_t w);

    virtual void print_graph();
    virtual void from_file(const std::string& filename, const std::string& file_type);
    virtual void test_min_vertex(std::ofstream& ofs);
    virtual  void test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file);
    virtual void test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file);
    virtual uint_fast64_t random_number(uint_fast64_t n);
};

#endif 