#!/bin/sh
set -e

export CC=clang
export CXX=clang++
export CXXFLAGS=-stdlib=libc++

mkdir -p /tmp/deps
cd /tmp/deps

git clone https://github.com/grpc/grpc.git
cd grpc
git checkout v1.25.0
git submodule update --init

cmake -B_build -H. \
  -DgRPC_ZLIB_PROVIDER=package \
  -DgRPC_CARES_PROVIDER=package \
  -DgRPC_PROTOBUF_PROVIDER=package \
  -DgRPC_GFLAGS_PROVIDER=package \
  -DgRPC_SSL_PROVIDER=package \
  -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF
cmake --build _build -- -j $(nproc)
sudo cmake --build _build --target install
cmake --build _build --target clean

rm -rf /tmp/deps
