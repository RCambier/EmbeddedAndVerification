# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.5.1/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.5.1/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build"

# Utility rule file for BenchmarkC.

# Include the progress variables for this target.
include examples/CMakeFiles/BenchmarkC.dir/progress.make

examples/CMakeFiles/BenchmarkC: examples/BenchmarkC.so


examples/BenchmarkC.so: tools/divine
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Generating BenchmarkC.so"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/examples" && ../tools/divine compile --cesmi /Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2\ 2/examples/cesmi/BenchmarkC.c

BenchmarkC: examples/CMakeFiles/BenchmarkC
BenchmarkC: examples/BenchmarkC.so
BenchmarkC: examples/CMakeFiles/BenchmarkC.dir/build.make

.PHONY : BenchmarkC

# Rule to build all files generated by this target.
examples/CMakeFiles/BenchmarkC.dir/build: BenchmarkC

.PHONY : examples/CMakeFiles/BenchmarkC.dir/build

examples/CMakeFiles/BenchmarkC.dir/clean:
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/examples" && $(CMAKE_COMMAND) -P CMakeFiles/BenchmarkC.dir/cmake_clean.cmake
.PHONY : examples/CMakeFiles/BenchmarkC.dir/clean

examples/CMakeFiles/BenchmarkC.dir/depend:
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/examples" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/examples" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/examples/CMakeFiles/BenchmarkC.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : examples/CMakeFiles/BenchmarkC.dir/depend

