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

# Include any dependencies generated for this target.
include divine/CMakeFiles/test-divine.dir/depend.make

# Include the progress variables for this target.
include divine/CMakeFiles/test-divine.dir/progress.make

# Include the compile flags for this target's objects.
include divine/CMakeFiles/test-divine.dir/flags.make

divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o: divine/CMakeFiles/test-divine.dir/flags.make
divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o: divine/test-divine-runner.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) -DBRICK_UNITTEST_REG $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/test-divine.dir/test-divine-runner.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine/test-divine-runner.cpp"

divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test-divine.dir/test-divine-runner.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) -DBRICK_UNITTEST_REG $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine/test-divine-runner.cpp" > CMakeFiles/test-divine.dir/test-divine-runner.cpp.i

divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test-divine.dir/test-divine-runner.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) -DBRICK_UNITTEST_REG $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine/test-divine-runner.cpp" -o CMakeFiles/test-divine.dir/test-divine-runner.cpp.s

divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.requires:

.PHONY : divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.requires

divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.provides: divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.requires
	$(MAKE) -f divine/CMakeFiles/test-divine.dir/build.make divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.provides.build
.PHONY : divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.provides

divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.provides.build: divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o


# Object files for target test-divine
test__divine_OBJECTS = \
"CMakeFiles/test-divine.dir/test-divine-runner.cpp.o"

# External object files for target test-divine
test__divine_EXTERNAL_OBJECTS =

divine/test-divine: divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o
divine/test-divine: divine/CMakeFiles/test-divine.dir/build.make
divine/test-divine: divine/libdivine.a
divine/test-divine: /usr/lib/libcurses.dylib
divine/test-divine: /usr/lib/libform.dylib
divine/test-divine: external/dbm/libdbm.a
divine/test-divine: external/libutap/libutap.a
divine/test-divine: divine/CMakeFiles/test-divine.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable test-divine"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine" && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/test-divine.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
divine/CMakeFiles/test-divine.dir/build: divine/test-divine

.PHONY : divine/CMakeFiles/test-divine.dir/build

divine/CMakeFiles/test-divine.dir/requires: divine/CMakeFiles/test-divine.dir/test-divine-runner.cpp.o.requires

.PHONY : divine/CMakeFiles/test-divine.dir/requires

divine/CMakeFiles/test-divine.dir/clean:
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine" && $(CMAKE_COMMAND) -P CMakeFiles/test-divine.dir/cmake_clean.cmake
.PHONY : divine/CMakeFiles/test-divine.dir/clean

divine/CMakeFiles/test-divine.dir/depend:
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/divine" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine/CMakeFiles/test-divine.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : divine/CMakeFiles/test-divine.dir/depend

