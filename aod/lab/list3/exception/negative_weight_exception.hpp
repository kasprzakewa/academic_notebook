#include <iostream>
#include <exception>
#include <string>

class NegativeWeightException : public std::exception {
private:
    std::string message;
public:
    explicit NegativeWeightException() : message("Negative weights are not supported") {}

    const char* what() const noexcept override {
        return message.c_str();
    }
};
