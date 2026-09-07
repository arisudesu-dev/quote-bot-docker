ARG TDLIB_VERSION=1.8.4

FROM ghcr.io/arisudesu-dev/tdlib-build:${TDLIB_VERSION} AS tdlib-build

FROM debian:trixie

RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential ca-certificates libssl3t64 nodejs npm python3 tini \
    && find /var/cache/ /var/lib/apt/lists/ /var/log/ -type f -delete

WORKDIR /app
ADD quote-bot /app
COPY --from=tdlib-build /build/tdlib/lib/libtdjson.so /app/helpers/tdlib/data/libtdjson.so

RUN npm install

ENTRYPOINT [ "/usr/bin/tini", "--", "node" ]
CMD [ "index.js" ]
