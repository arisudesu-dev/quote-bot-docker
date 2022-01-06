```
docker build -t ghcr.io/arisudesu-dev/quote-bot:latest -t ghcr.io/arisudesu-dev/quote-bot:v0.31.4-arisu -f quote-bot.Dockerfile .
docker push ghcr.io/arisudesu-dev/quote-bot:latest
docker push ghcr.io/arisudesu-dev/quote-bot:v0.31.4-arisu

docker build -t ghcr.io/arisudesu-dev/quote-api:latest -t ghcr.io/arisudesu-dev/quote-api:v0.9.6-arisu -f quote-api.Dockerfile .
docker push ghcr.io/arisudesu-dev/quote-api:latest
docker push ghcr.io/arisudesu-dev/quote-api:v0.9.6-arisu
```
