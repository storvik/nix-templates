find_package(GTest REQUIRED)
include(GoogleTest)

add_executable(ExampleTest ExampleTest.cpp)
target_include_directories(ExampleTest PRIVATE "${GTEST_INCLUDE_DIR}" "${PROJECT_SOURCE_DIR}/include")
target_link_libraries(ExampleTest PRIVATE gtest gtest_main)
#add_test(NAME ExampleTest_name COMMAND ExampleTest) # not needed because of gtest_discover_tests
gtest_discover_tests(ExampleTest)
