#!/bin/sh
set -e

export CC=clang
export CXX=clang++
export CXXFLAGS=-stdlib=libc++

mkdir -p /tmp/deps
cd /tmp/deps

git clone https://github.com/c-ares/c-ares.git
cd c-ares
git checkout cares-1_15_0
cmake \
    -B_build \
    -H. \
    -DCARES_STATIC=ON \
    -DCARES_STATIC_PIC=ON \
    -DCARES_SHARED=OFF \
    -DCMAKE_BUILD_TYPE=Release
cmake --build _build -- -j $(nproc)
sudo cmake --build _build --target install
cmake --build _build --target clean

rm -rf /tmp/deps
