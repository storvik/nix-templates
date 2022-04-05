cmake_minimum_required(VERSION 3.10)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR "Do not build in-source. Please remove CMakeCache.txt and the CMakeFiles/ directory. Then build out-of-source.")
endif()

project(mylib
  LANGUAGES CXX # C CUDA
  VERSION 0.0.1
  DESCRIPTION "C++ library description")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(CTest)                          # Must be called before adding tests but after calling project(). This automatically calls enable_testing() and configures ctest targets when using Make/Ninja
include(CMakeDependentOption)           # This is a really useful scripts that creates options that depends on other options. It can even be used with generator expressions !
include(GNUInstallDirs)                 # This will define the default values for installation directories (all platforms even if named GNU)
include(InstallRequiredSystemLibraries) # Tell CMake that the `install` target needs to install required system libraries (eg: Windows SDK)
include(CMakePackageConfigHelpers)      # Helper to create relocatable packages

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake") # Make our cmake scripts available

# Define option to enable unit testing
option(ENABLE_TESTING "Should unit tests be compiled." OFF)

# Static build
option(ENABLE_STATIC "Enable statically compiled libraries" ON)

set(${PROJECT_NAME}_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  CACHE STRING "Path to install ${PROJECT_NAME} Config*.cmake files to.")

# Check dependencies
find_package(spdlog REQUIRED)

set(${PROJECT_NAME}_SOURCES
  src/test.cpp)

set(${PROJECT_NAME}_INCLUDES
  include/mylib/test.h)

add_library(${PROJECT_NAME} SHARED)

# Set project version number
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${PROJECT_VERSION})

# Setting SOVERSION to major version number creates symlink libmylib.so.0 -> libmylib.so
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION 0)

# Public headers will be installed, should contain neccessary functions.
# Pricate headers should not be placed in include/
set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER ${${PROJECT_NAME}_INCLUDES})

target_sources(${PROJECT_NAME}
  PRIVATE
  ${${PROJECT_NAME}_SOURCES})

target_include_directories(${PROJECT_NAME}
  PRIVATE
  include/${PROJECT_NAME}
  src)

target_link_libraries(${PROJECT_NAME}
  PRIVATE
  spdlog::spdlog)

# do the same for static version
if(ENABLE_STATIC)
  add_library(${PROJECT_NAME}_STATIC STATIC)
  set_target_properties(${PROJECT_NAME}_STATIC PROPERTIES VERSION ${PROJECT_VERSION})
  set_target_properties(${PROJECT_NAME}_STATIC PROPERTIES PUBLIC_HEADER ${${PROJECT_NAME}_INCLUDES})
  target_sources(${PROJECT_NAME}_STATIC
    PRIVATE
    ${${PROJECT_NAME}_SOURCES})
  target_include_directories(${PROJECT_NAME}_STATIC
    PRIVATE
    include/${PROJECT_NAME}
    src)
  target_link_libraries(${PROJECT_NAME}_STATIC
    PRIVATE
    spdlog::spdlog)
  set_target_properties(${PROJECT_NAME}_STATIC PROPERTIES OUTPUT_NAME ${PROJECT_NAME}_static)
endif()

# Version checker helper from cmake, this way the user can use
# version number in find_package
write_basic_package_version_file(
  ${PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion)

configure_package_config_file(
  ${PROJECT_SOURCE_DIR}/cmake/Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR}
  PATH_VARS CMAKE_INSTALL_INCLUDEDIR)

# Install library
install(
  TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}_Targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})

if(ENABLE_STATIC)
  install(
    TARGETS ${PROJECT_NAME}_STATIC
    EXPORT ${PROJECT_NAME}_Targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME})
endif()

# Install cmake package config files
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR})

install(
  EXPORT ${PROJECT_NAME}_Targets
  NAMESPACE ${PROJECT_NAME}::
  FILE ${PROJECT_NAME}Targets.cmake
  DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR})

if(ENABLE_TESTING)
  enable_testing()

  # Enable extra warnings when building tests
  if (MSVC)
    add_compile_options(/W4 /WX)
  else()
    add_compile_options(-Wall -Wextra -pedantic -Werror)
  endif()

  add_subdirectory(tests)
endif()
