cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "himal_video_player")
project(${PROJECT_NAME} LANGUAGES CXX)

set(BINARY_NAME "himal_video_player")

cmake_policy(SET CMP0063 NEW)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)

add_executable(${BINARY_NAME}
  "runner/main.cc"
  "runner/my_application.cc"
  "runner/my_application.h"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)

apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app PkgConfig::GTK)

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

add_dependencies(${BINARY_NAME} flutter_assemble)