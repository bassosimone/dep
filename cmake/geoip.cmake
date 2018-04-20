project(geoip C)
cmake_minimum_required(VERSION 3.1.0)

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
  libGeoIP/GeoIP.c
  libGeoIP/GeoIP.h
  libGeoIP/GeoIPCity.c
  libGeoIP/GeoIPCity.h
  libGeoIP/GeoIP_deprecated.c
  libGeoIP/GeoIP_internal.h
  libGeoIP/pread.c
  libGeoIP/pread.h
  libGeoIP/regionName.c
  libGeoIP/timeZone.c
)
target_include_directories(
  geoip
  PUBLIC
  "${CMAKE_SOURCE_DIR}/libGeoIP"
)
install(
  FILES
  libGeoIP/GeoIP.h
  libGeoIP/GeoIPCity.h
  libGeoIP/pread.h
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
  apps/geoiplookup.c
)
target_include_directories(
  geoiplookup
  PUBLIC
  "${CMAKE_SOURCE_DIR}/libGeoIP"
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
  data/GeoIP.dat
  DESTINATION
  bin
)
