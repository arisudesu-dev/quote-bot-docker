FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl make git zlib1g-dev libssl-dev gperf php-cli cmake g++ ca-certificates \
    && rm -rf /var/lib/apt/lists/*

VOLUME /artifacts

ENV TDLIB_VERSION 1.8.4
ENV TDLIB_REV 7eabd8ca60de025e45e99d4e5edd39f4ebd9467e

RUN mkdir /build \
    && cd /build \
    && curl -L -f -O https://github.com/tdlib/td/archive/${TDLIB_REV}.tar.gz \
    && tar xzvf ${TDLIB_REV}.tar.gz \
    && mv -T td-${TDLIB_REV} td \
    && cd td \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../tdlib .. \
    && cmake --build . --target prepare_cross_compiling \
    && cd .. \
    && php SplitSource.php \
    && cd build \
    && cmake --build . --target install \
    && cd .. \
    && php SplitSource.php --undo \
    && cd ..
