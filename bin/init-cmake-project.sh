#!/bin/bash

mkdir -p $1/src
mkdir -p $1/build
printf "#include <stdio.h>\nint main(void) {\nprintf(\"hello world\");\nreturn 0;\n}" > $1/src/main.cpp
printf "cmake_minimum_required(VERSION 2.6)\nadd_executable(main main.cpp)" > $1/src/CMakeLists.txt
cd $1/build
cmake ../src
make
