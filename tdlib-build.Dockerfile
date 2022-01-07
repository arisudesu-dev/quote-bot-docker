FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends make git zlib1g-dev libssl-dev gperf php-cli cmake g++ ca-certificates \
    && rm -rf /var/lib/apt/lists/*

VOLUME /artifacts

RUN mkdir /build \
    && cd /build  \
    && git clone https://github.com/tdlib/td.git \
    && cd td \
    && git checkout v1.8.0 \
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

CMD [ "cp", "-R", "/build/td/tdlib", "/artifacts" ]
