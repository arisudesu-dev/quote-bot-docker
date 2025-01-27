#!/bin/sh

: "${BOT_VERSION:=v0.32.5-arisu20}"
: "${API_VERSION:=v0.10.7-arisu6}"
: "${TDLIB_VERSION:=1.8.4}"
: "${RLOTTIE_VERSION:=0.2}"

echo "Starting publish"
echo
echo "BOT_VERSION=$BOT_VERSION"
echo "API_VERSION=$API_VERSION"
echo

error() {
	echo "Failed with error code = $1"
	exit 1
}

echo "Building TDLib"
docker build -t "tdlib-build:$TDLIB_VERSION" -f tdlib-build.Dockerfile . || error $?

echo "Building RLottie"
docker build -t "rlottie-build:$RLOTTIE_VERSION" -f rlottie-build.Dockerfile . || error $?

echo Building quote-bot
docker build -t ghcr.io/arisudesu-dev/quote-bot:latest -t "ghcr.io/arisudesu-dev/quote-bot:$BOT_VERSION" -f quote-bot.Dockerfile . || error $?

echo Building quote-api
docker build -t ghcr.io/arisudesu-dev/quote-api:latest -t "ghcr.io/arisudesu-dev/quote-api:$API_VERSION" -f quote-api.Dockerfile . || error $?

echo "Pushing quote-bot"
docker push ghcr.io/arisudesu-dev/quote-bot:latest         || error $?
docker push "ghcr.io/arisudesu-dev/quote-bot:$BOT_VERSION" || error $?

echo "Pushing quote-api"
docker push ghcr.io/arisudesu-dev/quote-api:latest         || error $?
docker push "ghcr.io/arisudesu-dev/quote-api:$API_VERSION" || error $?

echo "Publish complete!"
exit 0
