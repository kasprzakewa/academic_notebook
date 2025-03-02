#ifndef DIAL_HPP
#define DIAL_HPP

#include "../graph/graph.hpp"

class Dial : public Graph {
public:
    std::vector<uint_fast64_t> dial(uint_fast64_t start, uint_fast64_t max_weight);
    uint_fast64_t p2p_dial(uint_fast64_t start, uint_fast64_t end);
    void test_min_vertex(std::ofstream& ofs) override;
    void test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file) override;
    void test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file) override;

};

#endif