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

RUN npm install \
    && sed -i 's#bindings.CanvasPatternInit.*##g' node_modules/canvas/lib/pattern.js

CMD [ "node", "index.js" ]
