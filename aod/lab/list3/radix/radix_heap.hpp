#ifndef RADIX_HPP
#define RADIX_HPP

#include "../graph/graph.hpp"

#include <unordered_set> 
#include <vector>        
#include <utility>
#include <limits>


class Radix : public Graph {
    
public:
    uint_fast64_t calculate_bucket(uint_fast64_t diff);

    void update_buckets(std::vector<uint_fast64_t>& dist, std::vector<std::vector<std::pair<uint_fast64_t, uint_fast64_t>>>& buckets, std::pair<uint_fast64_t, uint_fast64_t>& min, std::unordered_set<uint_fast64_t>& not_visited);

    void pre_work(std::vector<uint_fast64_t>& dist, std::unordered_set<uint_fast64_t>& not_visited, uint_fast64_t start, std::pair<uint_fast64_t, uint_fast64_t>& min);

    std::vector<uint_fast64_t> radix_djikstra(uint_fast64_t start);
    uint_fast64_t p2p_radix(uint_fast64_t start, uint_fast64_t end);
    void test_min_vertex(std::ofstream& ofs) override;
    void test_sources(std::ofstream& ofs, std::string& input_file, std::string& source_file) override;
    void test_pairs(std::ofstream& ofs, std::string& input_file, std::string& pairs_file) override;
};

#endif