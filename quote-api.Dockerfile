ARG RLOTTIE_VERSION=0.2

FROM ghcr.io/arisudesu-dev/rlottie-build:${RLOTTIE_VERSION} AS rlottie-build

FROM debian:bullseye

RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
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
