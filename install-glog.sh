#!/bin/sh
set -e

export CC=clang
export CXX=clang++
export CXXFLAGS=-stdlib=libc++

mkdir -p /tmp/deps
cd /tmp/deps

git clone https://github.com/google/glog.git
cd glog
git checkout tags/v0.4.0

cmake -B_build -H.
cmake --build _build -- -j $(nproc)
sudo cmake --build _build --target install
cmake --build _build --target clean

rm -rf /tmp/deps
