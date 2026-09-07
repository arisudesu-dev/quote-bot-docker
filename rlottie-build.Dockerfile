FROM debian:bullseye AS build

ARG RLOTTIE_BUILD_NPROC
ARG RLOTTIE_REV
ARG RLOTTIE_VERSION

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
        ca-certificates curl g++ meson \
    && mkdir /build \
    && cd /build \
    && curl -L -f -O "https://github.com/Samsung/rlottie/archive/${RLOTTIE_REV}.tar.gz" \
    && tar xzvf "${RLOTTIE_REV}.tar.gz" \
    && mv -T "rlottie-${RLOTTIE_REV}" src \
    && cd src \
    && meson --prefix="$PWD/../rlottie" -Dmodule=false build \
    && ninja -C build ${RLOTTIE_BUILD_NPROC:+-j} $RLOTTIE_BUILD_NPROC install

FROM debian:bullseye

COPY --from=build /build/rlottie /build/rlottie
