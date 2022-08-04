EIGEN=$HOME/projects/eigen
g++ -I$EIGEN -o eigen-demo eigen-demo.cpp && valgrind ./eigen-demo
