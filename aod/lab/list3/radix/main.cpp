#include <iostream>
#include <fstream>
#include <string>
#include "radix_heap.hpp"

int main(int argc, char* argv[]) {
    if (argc != 7) {
        std::cerr << "Usage: " << argv[0] << " -d <datafile> -ss <sourcefile> -oss <outputfile> OR -d <datafile> -p2p <p2pfile> -op2p <outputp2pfile>\n";
        return 1;
    }

    std::string datafile;
    std::string outputfile;
    std::string sourcefile;
    std::string p2pfile;
    std::string outputp2pfile;

    for (int i = 1; i < argc; i += 2) {
        std::string arg = argv[i];
        if (arg == "-d") {
            datafile = argv[i + 1];
        } else if (arg == "-oss") {
            outputfile = argv[i + 1];
        } else if (arg == "-ss") {
            sourcefile = argv[i + 1];
        } else if (arg == "-p2p") {
            p2pfile = argv[i + 1];
        } else if (arg == "-op2p") {
            outputp2pfile = argv[i + 1];
        } else {
            std::cerr << "Unknown option: " << arg << "\n";
            return 1;
        }
    }

    try {
        Radix r;
        r.from_file(datafile, "graph");

        if (sourcefile != "") {
            r.from_file(sourcefile, "sources");
            std::ofstream ofs(outputfile, std::ios::out);
            if (!ofs.is_open()) {
                throw std::runtime_error("Could not open output file");
            }

            r.test_min_vertex(ofs);
            r.test_sources(ofs, datafile, sourcefile);
        } else if (p2pfile != "") {
            r.from_file(p2pfile, "pairs");
            std::ofstream ofs(outputp2pfile, std::ios::out);
            if (!ofs.is_open()) {
                throw std::runtime_error("Could not open output file");
            }

            r.test_pairs(ofs, datafile, p2pfile);
        }

    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << "\n";
        return 1;
    }

    return 0;
}
