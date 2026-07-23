cmake_minimum_required(VERSION 3.8)
# Добавляем язык C, так как ядро библиотеки написано на нем
project(packer_tool LANGUAGES C CXX)

# Собираем пути ко всем исходникам библиотеки gpak
file(GLOB LIB_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/../lib/*.c")

# Передаем их компилятору вместе с нашим main.cpp
add_executable(${PROJECT_NAME} main.cpp ${LIB_SOURCES})

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)
set_target_properties(${PROJECT_NAME} PROPERTIES
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
)

# Указываем, где искать заголовочные файлы
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../lib
)

# Если библиотека внутри себя использует сжатие zstd и deflate (zlib),
# нужно прилинковать системные библиотеки для этих алгоритмов
target_link_libraries(${PROJECT_NAME} PRIVATE z zstd)