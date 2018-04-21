cmake_minimum_required(VERSION 3.1.0)
project(geoip_api_c C)

message(STATUS "Downloading geoip sources from github")
set(_geoip_commit 204cc59067839c06cc0f7d27e23c06b1c2555ead)
file(
  DOWNLOAD
  https://github.com/maxmind/geoip-api-c/archive/${_geoip_commit}.tar.gz
  "${CMAKE_CURRENT_BINARY_DIR}/geoip.tar.gz"
  EXPECTED_HASH SHA256=87483be5cb28d5c11c3b61a3a255a38583eefe2a7d82faa8f0ffd8a0ca6767c8
  TLS_VERIFY ON
  SHOW_PROGRESS
)
execute_process(
  COMMAND ${CMAKE_COMMAND} -E tar xzf "${CMAKE_CURRENT_BINARY_DIR}/geoip.tar.gz"
  RESULT_VARIABLE failure
)
if(${failure})
  message(FATAL_ERROR "Cannot extract geoip sources: ${failure}")
endif()
set(_geoip_dir "${CMAKE_CURRENT_BINARY_DIR}/${_geoip_commit}")

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
if("${MSVC}")
  add_definitions(-DWIN32 -D_CRT_SECURE_NO_WARNINGS -DGEOIP_STATIC
                  -D_WINSOCK_DEPRECATED_NO_WARNINGS)
endif()
add_definitions(-DPACKAGE_VERSION=\"1.6.12\")

# TODO(bassosimone): add more required checks

add_library(
  geoip
  STATIC
  "${_geoip_dir}/libGeoIP/GeoIP.c"
  "${_geoip_dir}/libGeoIP/GeoIP.h"
  "${_geoip_dir}/libGeoIP/GeoIPCity.c"
  "${_geoip_dir}/libGeoIP/GeoIPCity.h"
  "${_geoip_dir}/libGeoIP/GeoIP_deprecated.c"
  "${_geoip_dir}/libGeoIP/GeoIP_internal.h"
  "${_geoip_dir}/libGeoIP/pread.c"
  "${_geoip_dir}/libGeoIP/pread.h"
  "${_geoip_dir}/libGeoIP/regionName.c"
  "${_geoip_dir}/libGeoIP/timeZone.c"
)
target_include_directories(
  geoip
  PUBLIC
  "${_geoip_dir}/libGeoIP"
)
install(
  FILES
  "${_geoip_dir}/libGeoIP/GeoIP.h"
  "${_geoip_dir}/libGeoIP/GeoIPCity.h"
  "${_geoip_dir}/libGeoIP/pread.h"
  DESTINATION
  include
)
install(
  TARGETS
  geoip
  DESTINATION
  lib
)
if(WIN32)
  target_link_libraries(geoip ws2_32)
endif()

add_executable(
  geoiplookup
  "${_geoip_dir}/apps/geoiplookup.c"
)
target_include_directories(
  geoiplookup
  PUBLIC
  "${_geoip_dir}/libGeoIP"
)
target_link_libraries(
  geoiplookup
  geoip
)
install(
  TARGETS
  geoiplookup
  DESTINATION
  bin
)

install(
  FILES
  "${_geoip_dir}/data/GeoIP.dat"
  DESTINATION
  bin
)
