cmake_minimum_required(VERSION 2.32)
project(verilog-test)

option(BUILD_TESTS "Builds test binaries and adds them to CTest")

if(BUILD_TESTS)
  include(CTest)
  find_package(verilator REQUIRED CONFIG)
endif(BUILD_TESTS)

function(setup_test test_name top_level)
  if(BUILD_TESTS)
    add_executable(${test_name} ${ARGN})
    verilate(${test_name} SOURCES ${top_level} COVERAGE VERILATOR_ARGS -sv TOP_MODULE ${test_name})
    add_test(NAME ${test_name} COMMAND ${CMAKE_CURRENT_BINARY_DIR}/${test_name})
  endif(BUILD_TESTS)
endfunction()

add_subdirectory(src)
