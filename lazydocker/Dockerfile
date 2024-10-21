# build versions
ARG ALPINE_VERSION=3.20
ARG GO_VERSION=1.23.2
# packaged versions
ARG DOCKER_VERSION=27.3.1
ARG DOCKER_COMPOSE_VERSION=2.29.7
ARG DOCKER_COMPOSE_SHA256=383ce6698cd5d5bbf958d2c8489ed75094e34a77d340404d9f32c4ae9e12baf0
ARG LAZYDOCKER_VERSION=0.23.3


FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS build-base
RUN apk add -U -q --progress --no-cache git bash coreutils gcc musl-dev wget
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    DISABLE_WARN_OUTSIDE_CONTAINER=1

FROM build-base AS build-docker
ARG DOCKER_VERSION
WORKDIR /go/src/github.com/docker/cli
RUN git clone -q --branch v${DOCKER_VERSION} --single-branch --depth 1 https://github.com/docker/cli.git .
RUN ./scripts/build/binary && \
    rm build/docker && \
    mv build/docker-linux-* build/docker

FROM build-base AS build-docker-compose
ARG DOCKER_COMPOSE_VERSION
ARG DOCKER_COMPOSE_SHA256
RUN wget -q https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -O /bin/docker-compose && \
    echo "${DOCKER_COMPOSE_SHA256} */bin/docker-compose" | sha256sum --check

FROM build-base AS build-lazydocker
ARG LAZYDOCKER_VERSION
WORKDIR /go/src/github.com/jesseduffield/lazydocker
RUN git clone -q --branch v${LAZYDOCKER_VERSION} --single-branch --depth 1 https://github.com/jesseduffield/lazydocker.git .
RUN go build -a -mod=vendor \
    -ldflags="-s -w \
    -X main.version=${LAZYDOCKER_VERSION} \
    -X main.buildSource=Docker"

FROM busybox
COPY ./config.yml /root/.config/lazydocker/config.yml
COPY --from=build-docker /go/src/github.com/docker/cli/build/docker /bin/docker
COPY --from=build-docker-compose /bin/docker-compose /root/.docker/cli-plugins/docker-compose
COPY --from=build-lazydocker /go/src/github.com/jesseduffield/lazydocker/lazydocker /bin/lazydocker
ENTRYPOINT ["/bin/lazydocker"]
