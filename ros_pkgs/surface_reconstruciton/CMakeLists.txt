cmake_minimum_required(VERSION 3.26.4)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CUDA_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CUDA_ARCHITECTURES native)

project(surface_reconstruciton LANGUAGES CXX CUDA)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(visualization_msgs REQUIRED)
find_package(CUDAToolkit REQUIRED)

add_library(Vec3 include/Vec3.hpp)
set_target_properties(Vec3 PROPERTIES LINKER_LANGUAGE CXX)

add_library(Vec2 include/Vec2.hpp)
set_target_properties(Vec2 PROPERTIES LINKER_LANGUAGE CXX)

add_library(Timer include/timer.hpp)
set_target_properties(Timer PROPERTIES LINKER_LANGUAGE CXX)

add_library(MarchingCubes include/marching_cubes.cu include/marching_cubes.hpp)
set_target_properties(MarchingCubes PROPERTIES LINKER_LANGUAGE CUDA)
target_link_libraries(MarchingCubes PRIVATE cuda cudart)

add_library(ImageProcessing include/image_processing.cu include/image_processing.hpp)
set_target_properties(ImageProcessing PROPERTIES LINKER_LANGUAGE CUDA)
target_link_libraries(ImageProcessing PRIVATE cuda cudart cublas)

add_executable(main src/main.cpp)
set_target_properties(main PROPERTIES LINKER_LANGUAGE CXX)
target_link_libraries(main PRIVATE MarchingCubes ImageProcessing Timer) 
ament_target_dependencies(main PUBLIC rclcpp sensor_msgs visualization_msgs)

install(TARGETS
  main
  DESTINATION lib/${PROJECT_NAME})

ament_package()
