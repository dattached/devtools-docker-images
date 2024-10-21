ARG PSPG_VERSION=5.8.7
ARG USQL_VERSION=0.19.3


FROM debian:bookworm-slim AS build-pspg
SHELL ["/bin/sh", "-eux", "-c"]
RUN apt update; \
    apt install -y build-essential libncurses-dev wget; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /tmp/build
ARG PSPG_VERSION
RUN wget -q https://github.com/okbob/pspg/archive/refs/tags/${PSPG_VERSION}.tar.gz -O- | tar -xzf-; \
    cd pspg-${PSPG_VERSION}; \
    ./configure --with-ncursesw; \
    make; \
    mv ./pspg ../; \
    cd ..; \
    rm -rf pspg-${PSPG_VERSION}


FROM docker.io/usql/usql:${USQL_VERSION}
RUN apt update; \
    apt install -y gettext-base; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --chmod=755 ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
