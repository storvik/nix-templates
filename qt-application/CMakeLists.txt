cmake_minimum_required(VERSION 3.10.0)

project(
  myqtapp
  VERSION 0.0.1
  LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(GNUInstallDirs)
include(InstallRequiredSystemLibraries)

option(ENABLE_TESTING "Should unit tests be compiled." ON)

find_package(Qt5 5.15 REQUIRED COMPONENTS Core Network Widgets Test)

# Qt settings
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Make .ui files in ui/ accessible
set(CMAKE_AUTOUIC_SEARCH_PATHS ui/)
set(AUTOMOC_PATH_PREFIX ON)

set(${PROJECT_NAME}_SOURCES
    src/main.cpp
    src/MainWindow.cpp)

set(${PROJECT_NAME}_INCLUDES
    include/MainWindow.h)

set(${PROJECT_NAME}_UIS ui/MainWindow.ui)

# set(${PROJECT_NAME}_RESOURCES assets/resources.qrc)

add_executable(${PROJECT_NAME}
  ${${PROJECT_NAME}_SOURCES}
  ${${PROJECT_NAME}_INCLUDES}
  ${${PROJECT_NAME}_UIS})
  # ${${PROJECT_NAME}_RESOURCES})

target_include_directories(
  ${PROJECT_NAME}
  PRIVATE "${PROJECT_SOURCE_DIR}/include")

target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Widgets)

if(ENABLE_TESTING)
  enable_testing()

  # Test test
  add_executable(TestTest tests/QtTestTest.cpp)
  add_test(NAME TestTest COMMAND TestTest)
  target_link_libraries(TestTest PRIVATE Qt5::Test)

endif()

install(
  TARGETS ${PROJECT_NAME}
  DESTINATION ${CMAKE_INSTALL_BINDIR})
