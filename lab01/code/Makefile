# leads comments in a line
# Build all: default target
all : demo

# Separate compilation to build object files
main.o : main.cpp functions.h
	g++ -c -ggdb main.cpp

functions.o : functions.cpp functions.h
	g++ -c -ggdb functions.cpp

# linking
# demo is a target which depends upon main.o and greet.o
# "g++ main.o greet.o -o demo" is the command to produce the executable file
# You need to use a TAB before g++
demo : main.o functions.o
	g++ main.o functions.o -o demo

# Testing
check : all
	./demo

# Clean up all build targets so that one may get a clean build
clean :
	rm -f *.o demo 
