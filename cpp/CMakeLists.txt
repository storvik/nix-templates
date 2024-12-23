cmake_minimum_required(VERSION 3.10.0)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "Do not build in-source. Please remove CMakeCache.txt and the CMakeFiles/ directory. Then build out-of-source.")
endif()

project(
  myapp
  VERSION 0.0.1
  LANGUAGES CXX # C CUDA
  DESCRIPTION "C++ application description.")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(GNUInstallDirs)
include(InstallRequiredSystemLibraries)

option(ENABLE_TESTING "Should unit tests be compiled." ON)

set(${PROJECT_NAME}_SOURCES
    src/main.cpp)

set(${PROJECT_NAME}_INCLUDES
    # includes
)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME}
  PRIVATE
  ${${PROJECT_NAME}_SOURCES}
  ${${PROJECT_NAME}_INCLUDES})

target_include_directories(
  ${PROJECT_NAME}
  PRIVATE "${PROJECT_SOURCE_DIR}/include")

target_link_libraries(${PROJECT_NAME} PRIVATE)

if(ENABLE_TESTING)
  enable_testing()

  # Enable extra warnings when building tests
  add_compile_options(-Wall -Wextra -pedantic -Werror)

  add_subdirectory(tests)

  # Test test
  # add_executable(TestTest)
  # target_sources(TestTest PRIVATE tests/ExampleTest.cpp)
  # target_link_libraries(TestTest PRIVATE)
  # add_test(NAME TestTest COMMAND TestTest)

endif()

install(
  TARGETS ${PROJECT_NAME}
  DESTINATION ${CMAKE_INSTALL_BINDIR})
