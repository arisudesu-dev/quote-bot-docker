FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD quote-api /app
ADD librlottie.so /usr/lib/librlottie.so

RUN npm install

CMD [ "node", "index.js" ]
