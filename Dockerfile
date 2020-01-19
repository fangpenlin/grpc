FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    libtool \
    curl \
    make \
    g++ \
    unzip \
    gdb \
    git \
    gnupg2 \
    sudo && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    libssl-dev \
    zlib1g \
    zlib1g-dev \
    libunwind8-dev \
    libelf-dev \
    libdwarf-dev \
    binutils-dev \
    python-dev && \
    rm -rf /var/lib/apt/lists/*

# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-9 main" >> /etc/apt/sources.list && \
    echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-9 main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
        libllvm-9-ocaml-dev \
        libllvm9 \
        llvm-9 \
        llvm-9-dev \
        llvm-9-doc \
        llvm-9-examples \
        llvm-9-runtime \
        clang-9 \
        clang-tools-9 \
        clang-9-doc \
        libclang-common-9-dev \
        libclang-9-dev \
        libclang1-9 \
        clang-format-9 \
        python-clang-9 \
        clangd-9 \
        lldb-9 \
        lld-9 \
        libc++-9-dev \
        libc++abi-9-dev \
        libomp-9-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

ENV CC=clang-9
ENV CXX=clang++-9
RUN ln -s /usr/bin/clang-9 /usr/bin/clang && \
    ln -s /usr/bin/clang++-9 /usr/bin/clang++

RUN curl -OL https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2-Linux-x86_64.sh && \
    chmod +x cmake-3.16.2-Linux-x86_64.sh && \
    ./cmake-3.16.2-Linux-x86_64.sh --skip-license --prefix=/usr/local

COPY ./install-c-ares.sh /tmp/
RUN ./install-c-ares.sh || { echo 'install-c-ares.sh failed' ; exit 1; }

COPY ./install-protobuf.sh /tmp/
RUN ./install-protobuf.sh || { echo 'install-protobuf.sh failed' ; exit 1; }

COPY ./install-gflags.sh /tmp/
RUN ./install-gflags.sh || { echo 'install-gflags.sh failed' ; exit 1; }

COPY ./install-glog.sh /tmp/
RUN ./install-glog.sh || { echo 'install-glog.sh failed' ; exit 1; }

COPY ./install-grpc.sh /tmp/
RUN ./install-grpc.sh || { echo 'install-grpc.sh failed' ; exit 1; }

RUN apt-get update && apt-get install -y \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY . ./grpc
ENV CXXFLAGS=-stdlib=libc++
RUN cd grpc/examples/cpp/helloworld && \
    cmake -B_build -H. && cmake --build _build
