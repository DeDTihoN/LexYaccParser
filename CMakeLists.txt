cmake_minimum_required(VERSION 3.17)
project(parser_c__)

set(CMAKE_CXX_STANDARD 17)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(MyParser LexYacc/grammar.y ${CMAKE_CURRENT_BINARY_DIR}/grammar.tab.cpp)
FLEX_TARGET(MyScanner LexYacc/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.yy.cpp)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/LexYacc)


add_executable(parser_c__ ${BISON_MyParser_OUTPUTS} ${FLEX_MyScanner_OUTPUTS} main.cpp LexYacc/ASTNode.cpp)
