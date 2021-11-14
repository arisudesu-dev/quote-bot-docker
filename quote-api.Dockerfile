FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ADD quote-api /app

RUN npm install canvas@2.6.1 && npm install # TODO: canvas crashes if installed via npm install from package.json

CMD [ "node", "index.js" ]
