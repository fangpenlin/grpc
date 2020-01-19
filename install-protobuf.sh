#!/bin/sh
set -e

export CC=clang
export CXX=clang++
export CXXFLAGS=-stdlib=libc++

mkdir -p /tmp/deps
cd /tmp/deps

git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git checkout v3.11.2
git submodule update --init --recursive

cmake -B_build -Hcmake
cmake --build _build -- -j $(nproc)
sudo cmake --build _build --target install
cmake --build _build --target clean

rm -rf /tmp/deps
