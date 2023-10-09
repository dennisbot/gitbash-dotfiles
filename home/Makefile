# Makefile

# Compiler
CXX = g++

# Compiler Flags
CXXFLAGS = -Wall -g

# Source Files
SRCS = $(FILE)
EXE = $(FILE:.cpp=.exe)

# Targets and Recipes
all: $(EXE)

$(EXE): $(SRCS)
	$(CXX) $(CXXFLAGS) $(SRCS) -o $(EXE)

clean:
	find . -name '*.exe' -type f -delete
