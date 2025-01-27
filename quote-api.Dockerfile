FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y curl tini \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD quote-api /app
COPY --from=rlottie-build:0.2 /build/rlottie/rlottie/lib/librlottie.so /usr/lib/librlottie.so

RUN npm install

ENTRYPOINT [ "/usr/bin/tini", "--", "node" ]
CMD [ "index.js" ]
