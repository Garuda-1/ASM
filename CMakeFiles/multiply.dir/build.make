# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

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
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/oktet/CPP/cpp-course/helloasm

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/oktet/CPP/cpp-course/helloasm

# Include any dependencies generated for this target.
include CMakeFiles/multiply.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/multiply.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/multiply.dir/flags.make

CMakeFiles/multiply.dir/multiply.asm.o: CMakeFiles/multiply.dir/flags.make
CMakeFiles/multiply.dir/multiply.asm.o: multiply.asm
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/oktet/CPP/cpp-course/helloasm/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building ASM object CMakeFiles/multiply.dir/multiply.asm.o"
	nasm -f elf64 -g -F dwarf -o CMakeFiles/multiply.dir/multiply.asm.o /home/oktet/CPP/cpp-course/helloasm/multiply.asm

CMakeFiles/multiply.dir/multiply.asm.o.requires:

.PHONY : CMakeFiles/multiply.dir/multiply.asm.o.requires

CMakeFiles/multiply.dir/multiply.asm.o.provides: CMakeFiles/multiply.dir/multiply.asm.o.requires
	$(MAKE) -f CMakeFiles/multiply.dir/build.make CMakeFiles/multiply.dir/multiply.asm.o.provides.build
.PHONY : CMakeFiles/multiply.dir/multiply.asm.o.provides

CMakeFiles/multiply.dir/multiply.asm.o.provides.build: CMakeFiles/multiply.dir/multiply.asm.o


# Object files for target multiply
multiply_OBJECTS = \
"CMakeFiles/multiply.dir/multiply.asm.o"

# External object files for target multiply
multiply_EXTERNAL_OBJECTS =

multiply: CMakeFiles/multiply.dir/multiply.asm.o
multiply: CMakeFiles/multiply.dir/build.make
multiply: CMakeFiles/multiply.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/oktet/CPP/cpp-course/helloasm/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking ASM executable multiply"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/multiply.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/multiply.dir/build: multiply

.PHONY : CMakeFiles/multiply.dir/build

CMakeFiles/multiply.dir/requires: CMakeFiles/multiply.dir/multiply.asm.o.requires

.PHONY : CMakeFiles/multiply.dir/requires

CMakeFiles/multiply.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/multiply.dir/cmake_clean.cmake
.PHONY : CMakeFiles/multiply.dir/clean

CMakeFiles/multiply.dir/depend:
	cd /home/oktet/CPP/cpp-course/helloasm && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/oktet/CPP/cpp-course/helloasm /home/oktet/CPP/cpp-course/helloasm /home/oktet/CPP/cpp-course/helloasm /home/oktet/CPP/cpp-course/helloasm /home/oktet/CPP/cpp-course/helloasm/CMakeFiles/multiply.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/multiply.dir/depend
