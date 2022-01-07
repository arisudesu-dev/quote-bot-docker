```
docker build -t tdlib-build -f tdlib-build.Dockerfile .
docker run -v C:/artifacts:/artifacts tdlib-build

docker build -t ghcr.io/arisudesu-dev/quote-bot:latest -t ghcr.io/arisudesu-dev/quote-bot:v0.31.4-arisu -f quote-bot.Dockerfile .
docker build -t ghcr.io/arisudesu-dev/quote-api:latest -t ghcr.io/arisudesu-dev/quote-api:v0.9.6-arisu2 -f quote-api.Dockerfile .

docker push ghcr.io/arisudesu-dev/quote-bot:latest
docker push ghcr.io/arisudesu-dev/quote-bot:v0.31.4-arisu

docker push ghcr.io/arisudesu-dev/quote-api:latest
docker push ghcr.io/arisudesu-dev/quote-api:v0.9.6-arisu2
```
