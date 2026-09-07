FROM debian:trixie AS build

ARG TDLIB_BUILD_NPROC
ARG TDLIB_REV
ARG TDLIB_VERSION

RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates cmake curl g++ git gperf libssl-dev make php-cli zlib1g-dev \
    && mkdir /build \
    && cd /build \
    && curl -L -f -O "https://github.com/tdlib/td/archive/${TDLIB_REV}.tar.gz" \
    && tar xzvf "${TDLIB_REV}.tar.gz" \
    && mv -T "td-${TDLIB_REV}" src \
    && cd src \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH="$PWD/../../tdlib" .. \
    && cmake --build . ${TDLIB_BUILD_NPROC:+-j} $TDLIB_BUILD_NPROC --target prepare_cross_compiling \
    && cd .. \
    && php SplitSource.php \
    && cd build \
    && cmake --build . ${TDLIB_BUILD_NPROC:+-j} $TDLIB_BUILD_NPROC --target install

FROM debian:trixie

COPY --from=build /build/tdlib /build/tdlib
