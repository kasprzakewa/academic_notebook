CXX = g++
CXXFLAGS = -std=c++20 -O3
TARGET = djikstra
SRCS = main.cpp ../graph/graph.cpp djikstra.cpp
OBJS = $(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(TARGET)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJS)
