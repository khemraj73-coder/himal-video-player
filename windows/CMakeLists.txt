cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "himal_video_player")
project(${PROJECT_NAME} LANGUAGES CXX)

set(BINARY_NAME "himal_video_player")

flutter_application_target()

add_executable(${BINARY_NAME} WIN32
  "runner/flutter_window.cpp"
  "runner/main.cpp"
  "runner/utils.cpp"
  "runner/win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "runner/Runner.rc"
  "runner/runner.ico"
)

apply_standard_settings(${BINARY_NAME})

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

add_dependencies(${BINARY_NAME} flutter_assemble)