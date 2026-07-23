FROM alpine:latest AS builder

RUN apk add --no-cache \
    build-base \
    cmake \
    zlib-dev zlib-static \
    zstd-dev zstd-static \
    lz4-dev lz4-static

RUN mkdir -p /usr/lib/cmake/zstd && \
    echo 'add_library(zstd STATIC IMPORTED)' > /usr/lib/cmake/zstd/zstdConfig.cmake && \
    echo 'set_target_properties(zstd PROPERTIES IMPORTED_LOCATION "/usr/lib/libzstd.a")' >> /usr/lib/cmake/zstd/zstdConfig.cmake && \
    echo 'add_library(zstd::zstd ALIAS zstd)' >> /usr/lib/cmake/zstd/zstdConfig.cmake && \
    echo 'add_library(ZSTD::ZSTD ALIAS zstd)' >> /usr/lib/cmake/zstd/zstdConfig.cmake && \
    echo 'add_library(zstd::libzstd_static ALIAS zstd)' >> /usr/lib/cmake/zstd/zstdConfig.cmake

WORKDIR /app

COPY . .

RUN mkdir build && cd build && \
    cmake .. \
        -DBUILD_PACKER_TOOL=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_EXE_LINKER_FLAGS="-static" \
        -DCMAKE_FIND_LIBRARY_SUFFIXES=".a" && \
    make -j$(nproc)

FROM scratch

COPY --from=builder /app/build/packer_tool/packer_tool /packer_tool

ENTRYPOINT ["/packer_tool"]