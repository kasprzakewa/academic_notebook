#ifndef DJIKSTRA_HPP
#define DJIKSTRA_HPP

#include "../graph/graph.hpp"

class Djikstra : public Graph {
public:
    std::vector<uint_fast64_t> djikstra(uint_fast64_t start);
    uint_fast64_t p2p_djikstra(uint_fast64_t start, uint_fast64_t end);
    void test_min_vertex(std::ofstream& ofs) override;
    void test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file) override;

    void test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file) override;
};

#endif


