cmake_minimum_required(VERSION 3.1.0)
project(c_ares NONE)
include(ExternalProject)
externalproject_add(
  c_ares_ext
  URL https://github.com/c-ares/c-ares/archive/cares-1_14_0.tar.gz
  URL_HASH SHA256=62dd12f0557918f89ad6f5b759f0bf4727174ae9979499f5452c02be38d9d3e8
  CMAKE_ARGS -DCARES_STATIC=ON -DCARES_SHARED=OFF -DCARES_STATIC_PIC=ON
             "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
             "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
             "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
             "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
             "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
             "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
)
