cmake_minimum_required(VERSION 2.8)

project(helloasm)

set(CMAKE_ASM_SOURCE_FILE_EXTENSIONS "asm")
set(CMAKE_ASM_COMPILE_OBJECT "nasm -f elf64 -g -F dwarf -o <OBJECT> <SOURCE>")
SET(CMAKE_ASM_LINK_EXECUTABLE "ld <OBJECTS> -o <TARGET>")
enable_language(ASM)

add_executable(echo echo.asm)
add_executable(add add.asm)
add_executable(print_rax print_rax.asm)
add_executable(count_lines count_lines.asm)
add_executable(count_words count_words.asm)
add_executable(subtract subtract.asm)
add_executable(multiply multiply.asm)

