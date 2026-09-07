ARG RLOTTIE_VERSION=0.2

FROM ghcr.io/arisudesu-dev/rlottie-build:${RLOTTIE_VERSION} AS rlottie-build

FROM debian:bullseye

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
        ca-certificates curl \
    && node_script=$(curl -fsSL https://deb.nodesource.com/setup_16.x) \
    && bash -x -c "$node_script" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential nodejs python3 tini \
    && find /var/cache/ /var/lib/apt/lists/ /var/log/ -type f -delete

WORKDIR /app
ADD quote-api /app
COPY --from=rlottie-build /build/rlottie/lib/librlottie.so /usr/lib/librlottie.so

RUN npm install

ENTRYPOINT [ "/usr/bin/tini", "--", "node" ]
CMD [ "index.js" ]
