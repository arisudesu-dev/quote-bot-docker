@echo off

set BOT_VERSION=v0.32.5-arisu13
set API_VERSION=v0.10.7-arisu5
set TDLIB_VERSION=1.8.4

echo Starting publish
echo.
echo BOT_VERSION=%BOT_VERSION%
echo API_VERSION=%API_VERSION%
echo.

echo Building TDLib
docker build -t tdlib-build -f tdlib-build.Dockerfile . || goto :error
docker run -v %cd%\build:/artifacts tdlib-build         || goto :error

echo Copy prebuild TDLib
cp build\tdlib\lib\libtdjson.so.%TDLIB_VERSION% libtdjson.so || goto :error

echo Building quote-bot
docker build -t ghcr.io/arisudesu-dev/quote-bot:latest -t ghcr.io/arisudesu-dev/quote-bot:%BOT_VERSION% -f quote-bot.Dockerfile . || goto :error

echo Building quote-api
docker build -t ghcr.io/arisudesu-dev/quote-api:latest -t ghcr.io/arisudesu-dev/quote-api:%API_VERSION% -f quote-api.Dockerfile . || goto :error

echo Pushing quote-bot
docker push ghcr.io/arisudesu-dev/quote-bot:latest        || goto :error
docker push ghcr.io/arisudesu-dev/quote-bot:%BOT_VERSION% || goto :error

echo Pushing quote-api
docker push ghcr.io/arisudesu-dev/quote-api:latest        || goto :error
docker push ghcr.io/arisudesu-dev/quote-api:%API_VERSION% || goto :error

echo Publish complete!
goto :EOF

:error
echo Failed with error code = %errorlevel%.
exit /b %errorlevel%
