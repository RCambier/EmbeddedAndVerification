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
include external/tbbmalloc/CMakeFiles/tbbmalloc.dir/depend.make

# Include the progress variables for this target.
include external/tbbmalloc/CMakeFiles/tbbmalloc.dir/progress.make

# Include the compile flags for this target's objects.
include external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o: ../external/tbbmalloc/backend.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tbbmalloc.dir/backend.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/backend.cpp"

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tbbmalloc.dir/backend.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/backend.cpp" > CMakeFiles/tbbmalloc.dir/backend.cpp.i

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tbbmalloc.dir/backend.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/backend.cpp" -o CMakeFiles/tbbmalloc.dir/backend.cpp.s

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.requires:

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.provides: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.requires
	$(MAKE) -f external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.provides.build
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.provides

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.provides.build: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o


external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o: ../external/tbbmalloc/frontend.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tbbmalloc.dir/frontend.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/frontend.cpp"

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tbbmalloc.dir/frontend.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/frontend.cpp" > CMakeFiles/tbbmalloc.dir/frontend.cpp.i

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tbbmalloc.dir/frontend.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/frontend.cpp" -o CMakeFiles/tbbmalloc.dir/frontend.cpp.s

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.requires:

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.provides: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.requires
	$(MAKE) -f external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.provides.build
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.provides

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.provides.build: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o


external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o: ../external/tbbmalloc/backref.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tbbmalloc.dir/backref.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/backref.cpp"

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tbbmalloc.dir/backref.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/backref.cpp" > CMakeFiles/tbbmalloc.dir/backref.cpp.i

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tbbmalloc.dir/backref.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/backref.cpp" -o CMakeFiles/tbbmalloc.dir/backref.cpp.s

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.requires:

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.provides: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.requires
	$(MAKE) -f external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.provides.build
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.provides

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.provides.build: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o


external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o: ../external/tbbmalloc/large_objects.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tbbmalloc.dir/large_objects.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/large_objects.cpp"

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tbbmalloc.dir/large_objects.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/large_objects.cpp" > CMakeFiles/tbbmalloc.dir/large_objects.cpp.i

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tbbmalloc.dir/large_objects.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/large_objects.cpp" -o CMakeFiles/tbbmalloc.dir/large_objects.cpp.s

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.requires:

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.provides: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.requires
	$(MAKE) -f external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.provides.build
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.provides

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.provides.build: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o


external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o: ../external/tbbmalloc/proxy.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tbbmalloc.dir/proxy.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/proxy.cpp"

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tbbmalloc.dir/proxy.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/proxy.cpp" > CMakeFiles/tbbmalloc.dir/proxy.cpp.i

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tbbmalloc.dir/proxy.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/proxy.cpp" -o CMakeFiles/tbbmalloc.dir/proxy.cpp.s

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.requires:

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.provides: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.requires
	$(MAKE) -f external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.provides.build
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.provides

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.provides.build: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o


external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o: ../external/tbbmalloc/tbb_function_replacement.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/tbb_function_replacement.cpp"

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/tbb_function_replacement.cpp" > CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.i

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/tbb_function_replacement.cpp" -o CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.s

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.requires:

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.provides: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.requires
	$(MAKE) -f external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.provides.build
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.provides

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.provides.build: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o


external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/flags.make
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o: ../external/tbbmalloc/tbbmalloc.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o -c "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/tbbmalloc.cpp"

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.i"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/tbbmalloc.cpp" > CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.i

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.s"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc/tbbmalloc.cpp" -o CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.s

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.requires:

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.provides: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.requires
	$(MAKE) -f external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.provides.build
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.provides

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.provides.build: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o


# Object files for target tbbmalloc
tbbmalloc_OBJECTS = \
"CMakeFiles/tbbmalloc.dir/backend.cpp.o" \
"CMakeFiles/tbbmalloc.dir/frontend.cpp.o" \
"CMakeFiles/tbbmalloc.dir/backref.cpp.o" \
"CMakeFiles/tbbmalloc.dir/large_objects.cpp.o" \
"CMakeFiles/tbbmalloc.dir/proxy.cpp.o" \
"CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o" \
"CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o"

# External object files for target tbbmalloc
tbbmalloc_EXTERNAL_OBJECTS =

external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build.make
external/tbbmalloc/libtbbmalloc.a: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_8) "Linking CXX static library libtbbmalloc.a"
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && $(CMAKE_COMMAND) -P CMakeFiles/tbbmalloc.dir/cmake_clean_target.cmake
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/tbbmalloc.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build: external/tbbmalloc/libtbbmalloc.a

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/build

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backend.cpp.o.requires
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/frontend.cpp.o.requires
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/backref.cpp.o.requires
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/large_objects.cpp.o.requires
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/proxy.cpp.o.requires
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbb_function_replacement.cpp.o.requires
external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires: external/tbbmalloc/CMakeFiles/tbbmalloc.dir/tbbmalloc.cpp.o.requires

.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/requires

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/clean:
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" && $(CMAKE_COMMAND) -P CMakeFiles/tbbmalloc.dir/cmake_clean.cmake
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/clean

external/tbbmalloc/CMakeFiles/tbbmalloc.dir/depend:
	cd "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/external/tbbmalloc" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc" "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc/CMakeFiles/tbbmalloc.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : external/tbbmalloc/CMakeFiles/tbbmalloc.dir/depend
