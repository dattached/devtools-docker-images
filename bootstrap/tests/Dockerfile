ARG BOOTSTRAP_VERSION=none
FROM dattached/bootstrap:${BOOTSTRAP_VERSION} AS bootstrap


# --- base images


FROM debian:12.7-slim AS base-debian
SHELL ["/bin/sh", "-eux", "-c"]

FROM python:3.12-slim-bookworm AS base-python
SHELL ["/bin/sh", "-eux", "-c"]


# --- tests


FROM base-debian AS debian-add-apt-postgresql

RUN --mount=type=cache,dst=/var/cache/apt,sharing=locked \
    --mount=type=cache,dst=/var/lib/apt,sharing=locked \
    --mount=type=bind,from=bootstrap,dst=/b \
    apt-get update; \
    test -z "$(apt-cache search --names-only postgresql-client-17)"; \
    bash /b/debian-add-apt-postgresql.sh; \
    test -n "$(apt-cache search --names-only postgresql-client-17)"; \
    rm -rf /tmp/* /var/tmp/*


FROM base-debian AS debian-apt-install-devtools

RUN --mount=type=cache,dst=/var/cache/apt,sharing=locked \
    --mount=type=cache,dst=/var/lib/apt,sharing=locked \
    --mount=type=bind,from=bootstrap,dst=/b \
    apt-get update; \
    bash /b/debian-apt-install-devtools.sh; \
    test -n "$(curl --version)"; \
    test -n "$(git --version)"; \
    test -n "$(jq --version)"; \
    test -n "$(lsd --version)"; \
    test -n "$(task --version)"; \
    test -n "$(wget --version)"; \
    test -n "$(zsh --version)"; \
    rm -rf /tmp/* /var/tmp/*


FROM base-python AS debian-pip-install-uv

RUN --mount=type=cache,dst=/root/.cache/pip \
    --mount=type=bind,from=bootstrap,dst=/b \
    bash /b/debian-pip-install-uv.sh; \
    test -n "$(uv --version)"
