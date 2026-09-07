ARG RLOTTIE_VERSION=0.2

FROM ghcr.io/arisudesu-dev/rlottie-build:${RLOTTIE_VERSION} AS rlottie-build

FROM debian:trixie

RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates nodejs npm tini \
    && find /var/cache/ /var/lib/apt/lists/ /var/log/ -type f -delete

WORKDIR /app
ADD quote-api /app
COPY --from=rlottie-build /build/rlottie/lib64/librlottie.so /usr/lib/librlottie.so

RUN npm install

ENTRYPOINT [ "/usr/bin/tini", "--", "node" ]
CMD [ "index.js" ]
