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
    apt install -y gettext-base libncursesw6; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --from=build-pspg /tmp/build/pspg /bin/pspg
COPY ./config.pspg.ini /root/.config/pspg/config.ini
ENV PAGER=/bin/pspg \
    PSPG_CONF=/root/.config/pspg/config.ini
COPY --chmod=755 ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
