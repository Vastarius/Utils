#!/bin/bash

current_dir=`pwd`

echo "Initializing CMake environment in $current_dir"

echo "-- Creating src, build dir and example"
mkdir $current_dir/src 
mkdir $current_dir/examples 
mkdir $current_dir/build

echo "-- Creating main.c in $current_dir/examples"
touch $current_dir/examples/main.c
echo "
#include <stdio.h>
#include \"../src/function.h\"

int main(){
   	printf(\"This is the main\\n\");
   	function();
  	return 0;
}

" >> $current_dir/examples/main.c

echo "-- Creating function.c in $current_dir/src"
touch $current_dir/src/function.c
echo "
#include <stdio.h>
#include \"function.h\"

int function(){
   	printf(\"This is the function\\n\");
  	return 0;
}

" >> $current_dir/src/function.c

echo "-- Creating function.h in $current_dir/src"
touch $current_dir/src/function.h
echo "

int function();

" >> $current_dir/src/function.h

echo "-- Creating CMakeLists.txt files"
touch CMakeLists.txt
echo "cmake_minimum_required(VERSION 3.16)

set(CMAKE_BUILD_TYPE Release)

project(Projet)

add_subdirectory(src)
add_subdirectory(examples)

" >> $current_dir/CMakeLists.txt

touch $current_dir/src/CMakeLists.txt
echo "
add_library(
	lib_name
	SHARED
	function.c
)

install(
	TARGETS lib_name
	DESTINATION lib
)

file(
	GLOB
	headers
	*.h
)

install(
	FILES \${headers}
	DESTINATION include/\${CMAKE_PROJECT_NAME}
)

" >> $current_dir/src/CMakeLists.txt

touch $current_dir/examples/CMakeLists.txt
echo "
file(
	GLOB
	usage_examples
	*.c
)

foreach(f \${usage_examples})
	get_filename_component(exampleName \${f} NAME_WE)
	add_executable(\${exampleName} \${f})
	target_link_libraries(\${exampleName} lib_name)
	install(PROGRAMS \${CMAKE_CURRENT_BINARY_DIR}/\${exampleName}
	DESTINATION bin
	RENAME \${CMAKE_PROJECT_NAME}-\${exampleName})
endforeach(f)	

" >> $current_dir/examples/CMakeLists.txt



echo "-- Environment has the following structure :"
echo "	|"
echo "	|- CMakeLists.txt"
echo "	|- src"
echo "	    \ CMakeLists.txt"
echo "	    \ function.c"
echo "	|- examples"
echo "	    \ CMakeLists.txt"
echo "	    \ main.c"
echo "	|- build"

echo "-- Move into build directory"
cd $current_dir/build
echo "-- [CMake] Generate buildsystem CMake"
cmake ../
echo "-- [Make] Build project"
make
echo "-- [main] Run ./examples/main"
./examples/main




