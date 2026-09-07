FROM debian:bullseye AS build

ARG TDLIB_BUILD_NPROC
ARG TDLIB_REV
ARG TDLIB_VERSION

# Debian 11 left LTS on 2026-08-31: main moved to archive.debian.org, and
# bullseye-security was purged, so it is pinned to its final snapshot.
RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && ( \
        echo 'deb http://archive.debian.org/debian bullseye main'; \
        echo 'deb http://archive.debian.org/debian bullseye-updates main'; \
        echo 'deb http://snapshot.debian.org/archive/debian-security/20260901T000000Z bullseye-security main'; \
     ) > /etc/apt/sources.list \
    && ( \
        echo 'Acquire::Check-Valid-Until "false";' 'Acquire::Retries "5";'; \
    ) > /etc/apt/apt.conf.d/99bullseye-eol \
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

FROM debian:bullseye

COPY --from=build /build/tdlib /build/tdlib
