FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl meson g++ ca-certificates \
    && rm -rf /var/lib/apt/lists/*

VOLUME /artifacts

ENV RLOTTIE_VERSION 0.2
ENV RLOTTIE_REV bf3d272df3916a0c34575ac8286cb0fe672fd0d4

RUN mkdir /build \
    && cd /build \
    && curl -L -f -O https://github.com/Samsung/rlottie/archive/${RLOTTIE_REV}.tar.gz \
    && tar xzvf ${RLOTTIE_REV}.tar.gz \
    && mv -T rlottie-${RLOTTIE_REV} rlottie \
    && cd rlottie \
    && meson --prefix=$(pwd)/rlottie -Dmodule=false build \
    && ninja -C build install \
    && cd ..

CMD [ "cp", "-R", "/build/rlottie/rlottie", "/artifacts" ]
