```
docker build \
  -t ghcr.io/arisudesu-dev/quote-bot:latest \
  -t ghcr.io/arisudesu-dev/quote-bot:v0.30.3-arisu \
  -f quote-bot.Dockerfile .

docker build \
  -t ghcr.io/arisudesu-dev/quote-api:latest \
  -t ghcr.io/arisudesu-dev/quote-api:v0.8.3-arisu \
  -f quote-api.Dockerfile .

docker push ghcr.io/arisudesu-dev/quote-bot
docker push ghcr.io/arisudesu-dev/quote-api
```
