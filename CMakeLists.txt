cmake_minimum_required(VERSION 3.1.0)
project(dep C CXX)
include(ExternalProject)

# TODO(bassosimone): explain
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE INTERNAL
    "Type of builds that are allowed" FORCE)

# TODO(bassosimone): explain
if(${WIN32})
  set(CMAKE_CXX_FLAGS_RELEASE "/MT /O2 /Ob2 /DNDEBUG")
  set(CMAKE_C_FLAGS_RELEASE "/MT /O2 /Ob2 /DNDEBUG")
  set(CMAKE_CXX_FLAGS_DEBUG "/MT /Zi /Ob0 /Od /RTC1")
  set(CMAKE_C_FLAGS_DEBUG "/MT /Zi /Ob0 /Od /RTC1")
  if("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/MK_DIST/windows/386")
  elseif("${CMAKE_SIZEOF_VOID_P}" STREQUAL "8")
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/MK_DIST/windows/amd64")
  else()
    message(FATAL_ERROR "Unexpected SIZEOF_VOID_P value")
  endif()
endif()

set(MK_DEPS_ENABLE_GEOIP OFF CACHE STRING "Whether to build GeoIP")
if(${MK_DEPS_ENABLE_GEOIP})
  # TODO(bassosimone): explain...
  externalproject_add(
    ext_geoip
    URL https://github.com/maxmind/geoip-api-c/archive/204cc59067839c06cc0f7d27e23c06b1c2555ead.tar.gz
    URL_HASH SHA256=87483be5cb28d5c11c3b61a3a255a38583eefe2a7d82faa8f0ffd8a0ca6767c8
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different
      "${CMAKE_SOURCE_DIR}/cmake/geoip.cmake"
      "${CMAKE_BINARY_DIR}/ext_geoip-prefix/src/ext_geoip/CMakeLists.txt"
  )
  externalproject_add(
    ext_geoip_cmaked
    SOURCE_DIR "${CMAKE_BINARY_DIR}/ext_geoip-prefix/src/ext_geoip"
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
               "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
               "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
               "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
               "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
    DEPENDS ext_geoip
  )
endif()

set(MK_DEPS_ENABLE_CARES ON CACHE STRING "Whethere to build c-ares")
if(${MK_DEPS_ENABLE_CARES})
  externalproject_add(
    ext_cares
    URL https://github.com/c-ares/c-ares/archive/cares-1_14_0.tar.gz
    URL_HASH SHA256=62dd12f0557918f89ad6f5b759f0bf4727174ae9979499f5452c02be38d9d3e8
    CMAKE_ARGS -DCARES_STATIC=ON
               -DCARES_SHARED=OFF
               -DCARES_STATIC_PIC=ON
               "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
               "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
               "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
               "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
               "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
  )
endif()

set(MK_DEPS_ENABLE_LIBRESSL ON CACHE STRING "Whether to build libressl")
if(${MK_DEPS_ENABLE_LIBRESSL})
  externalproject_add(
    ext_libressl
    URL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.6.4.tar.gz
    URL_HASH SHA256=638a20c2f9e99ee283a841cd787ab4d846d1880e180c4e96904fc327d419d11f
    # TODO(bassosimone): apparently the BUILD_SHARED flag is
    # internally overriden so it actually has no effect.
    CMAKE_ARGS -DBUILD_SHARED=OFF
               "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
               "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
               "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
               "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
               "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
  )
endif()

set(MK_DEPS_ENABLE_LIBEVENT ON CACHE STRING "Whether to build libevent")
if(${MK_DEPS_ENABLE_LIBEVENT})
  if(NOT (${MK_DEPS_ENABLE_LIBRESSL}))
    message(FATAL_ERROR "libevent depends on libressl")
  endif()
  externalproject_add(
    ext_libevent
    URL https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz
    URL_HASH SHA256=316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
               "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
               "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
               "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
               "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
               "-DOPENSSL_INCLUDE_DIR=${CMAKE_INSTALL_PREFIX}/include"
               "-DLIB_EAY_DEBUG=${CMAKE_INSTALL_PREFIX}/lib/crypto.lib"
               "-DSSL_EAY_DEBUG=${CMAKE_INSTALL_PREFIX}/lib/ssl.lib"
               -DEVENT__DISABLE_BENCHMARK=ON
               -DEVENT__DISABLE_TESTS=ON
               -DEVENT__DISABLE_REGRESS=ON
               -DEVENT__DISABLE_SAMPLES=ON
               -DEVENT__BUILD_SHARED_LIBRARIES=OFF
    DEPENDS ext_libressl
  )
endif()
