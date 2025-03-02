#include <iostream>
#include <exception>
#include <string>

class EdgeAlreadyExistsException : public std::invalid_argument {
public:
    explicit EdgeAlreadyExistsException()
        : std::invalid_argument("Edge already exists") {}
};
