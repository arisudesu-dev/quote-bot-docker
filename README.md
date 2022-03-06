```
docker build -t tdlib-build -f tdlib-build.Dockerfile .
docker run -v C:/artifacts:/artifacts tdlib-build

docker build -t ghcr.io/arisudesu-dev/quote-bot:latest -t ghcr.io/arisudesu-dev/quote-bot:v0.32.5-arisu5 -f quote-bot.Dockerfile .
docker build -t ghcr.io/arisudesu-dev/quote-api:latest -t ghcr.io/arisudesu-dev/quote-api:v0.10.7-arisu -f quote-api.Dockerfile .

docker push ghcr.io/arisudesu-dev/quote-bot:latest
docker push ghcr.io/arisudesu-dev/quote-bot:v0.32.5-arisu5

docker push ghcr.io/arisudesu-dev/quote-api:latest
docker push ghcr.io/arisudesu-dev/quote-api:v0.10.7-arisu
```
