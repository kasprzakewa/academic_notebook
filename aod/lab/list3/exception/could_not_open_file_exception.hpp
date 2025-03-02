#include <iostream>
#include <exception>
#include <string>

class CouldNotOpenFileException : public std::runtime_error {
private:
    std::string message;
public:
    explicit CouldNotOpenFileException()
        : std::runtime_error("Could not open file") {}
};
