FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD quote-bot /app

RUN npm install && npm install sharp@0.23.4 # TODO: sharp crashes if installed via npm install from installed via package.json
