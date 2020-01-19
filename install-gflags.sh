#!/bin/sh
set -e

export CC=clang
export CXX=clang++
export CXXFLAGS=-stdlib=libc++

mkdir -p /tmp/deps
cd /tmp/deps

git clone https://github.com/gflags/gflags.git
cd gflags
git checkout tags/v2.2.2
cmake -B_build -H. \
  -DGFLAGS_INSTALL_STATIC_LIBS=ON \
  -DGFLAGS_BUILD_STATIC_LIBS=ON
cmake --build _build -- -j $(nproc)
sudo cmake --build _build --target install
cmake --build _build --target clean

rm -rf /tmp/deps
