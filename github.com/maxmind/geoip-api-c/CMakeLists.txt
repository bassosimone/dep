cmake_minimum_required(VERSION 3.1.0)
project(geoip_api_c NONE)

message(STATUS "Downloading geoip sources from github")
set(_geoip_commit 204cc59067839c06cc0f7d27e23c06b1c2555ead)
file(
  DOWNLOAD
  https://github.com/maxmind/geoip-api-c/archive/${_geoip_commit}.tar.gz
  "${CMAKE_CURRENT_BINARY_DIR}/geoip.tar.gz"
  EXPECTED_HASH SHA256=87483be5cb28d5c11c3b61a3a255a38583eefe2a7d82faa8f0ffd8a0ca6767c8
  TLS_VERIFY ON SHOW_PROGRESS
)
execute_process(
  COMMAND ${CMAKE_COMMAND} -E tar xzf "${CMAKE_CURRENT_BINARY_DIR}/geoip.tar.gz"
  RESULT_VARIABLE failure
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)
if(${failure})
  message(FATAL_ERROR "Cannot extract geoip sources: ${failure}")
endif()
set(_geoip_dir "${CMAKE_CURRENT_BINARY_DIR}/geoip-api-c-${_geoip_commit}")
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_SOURCE_DIR}/geoip-build.cmake"
    "${_geoip_dir}/CMakeLists.txt" 
  RESULT_VARIABLE failure
)
if(${failure})
  message(FATAL_ERROR "Cannot copy our CMakeLists.txt into geoip sources: ${failure}")
endif()

#execute_process(
#  COMMAND ${CMAKE_COMMAND} "-G ${CMAKE_GENERATOR}"
#             "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
#             "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
#             "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
#             "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
#             "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
#             "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
#             . # <- directory where to operate
#  RESULT_VARIABLE failure
#  WORKING_DIRECTORY "${_geoip_dir}"
#)

include(ExternalProject)
externalproject_add(
  geoip_api_c_ext
  SOURCE_DIR "${_geoip_dir}"
  CMAKE_ARGS "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
             "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
             "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
             "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
             "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
             "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
)
