cmake_minimum_required(VERSION 3.8)

project(packer_tool LANGUAGES C CXX)

file(GLOB LIB_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/../lib/*.c")

add_executable(${PROJECT_NAME} main.cpp ${LIB_SOURCES})

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
set_target_properties(${PROJECT_NAME} PROPERTIES
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../lib
)

target_link_libraries(${PROJECT_NAME} PRIVATE z zstd)