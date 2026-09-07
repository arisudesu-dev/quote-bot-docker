FROM debian:trixie AS build

ARG RLOTTIE_BUILD_NPROC
ARG RLOTTIE_REV
ARG RLOTTIE_VERSION

RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl g++ meson ninja-build \
    && mkdir /build \
    && cd /build \
    && curl -L -f -O "https://github.com/Samsung/rlottie/archive/${RLOTTIE_REV}.tar.gz" \
    && tar xzvf "${RLOTTIE_REV}.tar.gz" \
    && mv -T "rlottie-${RLOTTIE_REV}" src \
    && cd src \
    && sed -i '/#include <cstring>/a #include <limits>' src/vector/vrle.cpp \
    && meson --prefix="$PWD/../rlottie" -Dmodule=false build \
    && ninja -C build ${RLOTTIE_BUILD_NPROC:+-j} $RLOTTIE_BUILD_NPROC install

FROM debian:trixie

COPY --from=build /build/rlottie /build/rlottie
