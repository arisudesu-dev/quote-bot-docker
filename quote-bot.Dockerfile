ARG TDLIB_VERSION=1.8.4

FROM ghcr.io/arisudesu-dev/tdlib-build:${TDLIB_VERSION} AS tdlib-build

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
ADD quote-bot /app
COPY --from=tdlib-build /build/tdlib/lib/libtdjson.so /app/helpers/tdlib/data/libtdjson.so

RUN npm install

ENTRYPOINT [ "/usr/bin/tini", "--", "node" ]
CMD [ "index.js" ]
