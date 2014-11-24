################################################################################
# Makefile for general code snippets
#
# by André Pereira (LIP-Minho)
################################################################################

SHELL = /bin/sh

BIN_NAME = matrix_mult

#CXX = g++
#LD  = g++

CXX = icpc
LD  = icpc

#-vec-report3 -openmp


CXXFLAGS   = -Wall -Wextra -std=c++11

ifeq ($(AVX),yes)
	CXXFLAGS += -mavx -DAVX
else
	ifeq ($(SSE),yes)
		CXXFLAGS += -msse4.1 -DSSE
	endif
endif

ifeq ($(DEBUG),yes)
	CXXFLAGS += -ggdb3
endif

################################################################################
# Control awesome stuff
################################################################################

SRC_DIR = src
BIN_DIR = bin
BUILD_DIR = build
SRC = $(wildcard $(SRC_DIR)/*.cpp)
OBJ = $(patsubst src/%.cpp,build/%.o,$(SRC))
DEPS = $(patsubst build/%.o,build/%.d,$(OBJ))
BIN = $(BIN_NAME)

vpath %.cpp $(SRC_DIR)

################################################################################
# Rules
################################################################################

.DEFAULT_GOAL = all

$(BUILD_DIR)/%.d: %.cpp
	$(CXX) -M $(CXXFLAGS) $(INCLUDES) $< -o $@ $(LIBS)

$(BUILD_DIR)/%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) $< -o $@ $(LIBS)

$(BIN_DIR)/$(BIN_NAME): $(DEPS) $(OBJ)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $@ $(OBJ) $(LIBS)

checkdirs:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BIN_DIR)

all: checkdirs $(BIN_DIR)/$(BIN_NAME)

clean:
	rm -f $(BUILD_DIR)/* $(BIN_DIR)/* 