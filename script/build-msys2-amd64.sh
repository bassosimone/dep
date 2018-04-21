#!/bin/sh
set -e
cmake "-GMSYS Makefiles" -DCMAKE_BUILD_TYPE=Release \
  "-DCMAKE_INSTALL_PREFIX=MK_DIST/msys2/amd64" \
  -DMK_DEP_DEPNAME=$1
make
