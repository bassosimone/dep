cmake_minimum_required(VERSION 3.1.0)
project(libressl NONE)
include(ExternalProject)
externalproject_add(
  libressl_ext
  URL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.6.4.tar.gz
  URL_HASH SHA256=638a20c2f9e99ee283a841cd787ab4d846d1880e180c4e96904fc327d419d11f
  # TODO(bassosimone): apparently the BUILD_SHARED flag is
  # internally overriden so it actually has no effect.
  CMAKE_ARGS -DBUILD_SHARED=OFF
             "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
             "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
             "-DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}"
             "-DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}"
             "-DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}"
             "-DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}"
  )
