# Docker images for dev tools

* bootstrap — Shell scripts to use in Dockerfiles.
* [lazydocker](https://github.com/jesseduffield/lazydocker) —
A simple terminal UI for both docker and docker-compose.

* [usql](https://github.com/xo/usql) — Universal command-line interface for SQL databases. Includes [pspg](https://github.com/okbob/pspg), Unix pager designed for work with tables.


# bootstrap

[![Docker Pulls](https://img.shields.io/docker/pulls/dattached/bootstrap)](https://hub.docker.com/r/dattached/bootstrap)

Managed collection of shell scripts to use in Dockerfiles:

* [debian-add-apt-postgresql.sh](https://github.com/dattached/devtools-docker-images/blob/main/bootstrap/docs.md#debian-add-apt-postgresqlsh) — Add PostgreSQL APT [repository](https://wiki.postgresql.org/wiki/Apt) with latest packages.
* [debian-apt-install-devtools.sh](https://github.com/dattached/devtools-docker-images/blob/main/bootstrap/docs.md#debian-apt-install-devtoolssh) — Install [Git](https://git-scm.com), [Task](https://taskfile.dev), [Oh My Zsh!](https://ohmyz.sh), [LSD](https://github.com/lsd-rs/lsd).
* [debian-pip-install-uv.sh](https://github.com/dattached/devtools-docker-images/blob/main/bootstrap/docs.md#debian-pip-install-uvsh) — Install and configure [uv](https://docs.astral.sh/uv/) with system [pip]() under root.

See [Documentation](https://github.com/dattached/devtools-docker-images/blob/main/bootstrap/docs.md) for details.

Example:

```Dockerfile
# Dockerfile
RUN --mount=type=bind,from=dattached/bootstrap,dst=/b \
    apt-get update; \
    bash /b/debian-apt-install-devtools.sh; \
    apt-get clean; \
    rm -rf /tmp/* /var/tmp/*
```

With cached APT directories:

```Dockerfile
# Dockerfile
RUN --mount=type=cache,dst=/var/cache/apt,sharing=locked \
    --mount=type=cache,dst=/var/lib/apt,sharing=locked \
    --mount=type=bind,from=dattached/bootstrap,dst=/b \
    apt-get update; \
    bash /b/debian-apt-install-devtools.sh; \
    rm -rf /tmp/* /var/tmp/*
```


# lazydocker

[![Docker Pulls](https://img.shields.io/docker/pulls/dattached/lazydocker)](https://hub.docker.com/r/dattached/lazydocker)

Image for [lazydocker](https://github.com/jesseduffield/lazydocker) terminal UI.

Example:

```yaml
# compose.yml
services:
  # ...
  lazydocker:
    image: dattached/lazydocker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      #- ./compose.yml:/compose.yml:ro
      #- ./config.yml:/root/.config/lazydocker/config.yml:ro
```


# usql

[![Docker Pulls](https://img.shields.io/docker/pulls/dattached/usql)](https://hub.docker.com/r/dattached/usql)

Image for [usql](https://github.com/xo/usql) SQL console with [pspg](https://github.com/okbob/pspg) table pager.

Example:

```yaml
# compose.yml
services:

  postgres:
    image: postgres:17-bookworm
    healthcheck:
      test: pg_isready -t3 -h127.0.0.1
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
      start_interval: 0s
    environment:
      PGDATA: /var/lib/postgresql/data/pgdata
      POSTGRES_DB_FILE: /postgres_db
      POSTGRES_USER_FILE: /postgres_user
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password
    configs:
      - postgres_db
      - postgres_user
    secrets:
      - postgres_password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  usql:
    image: dattached/usql:latest
    container_name: usql
    depends_on:
      postgres:
        condition: service_healthy
    stdin_open: true
    tty: true
    environment:
      POSTGRES_DB_FILE: /postgres_db
      POSTGRES_USER_FILE: /postgres_user
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password
      USQL_CONF_TEMPLATE: /root/.config/usql/config.yaml.tpl
      USQL_CONNECTION: postgres
      USQL_FILEENV_NAMES: POSTGRES_*_FILE
    configs:
      - postgres_db
      - postgres_user
      - {source: usql_config, target: /root/.config/usql/config.yaml.tpl}
    secrets:
      - postgres_password

configs:
  postgres_db: {content: postgres-test}
  postgres_user: {content: postgres-test}
  usql_config: {file: config.yaml}

secrets:
  postgres_password: {environment: POSTGRES_PASSWORD}

volumes:
  postgres_data:
```

```yaml
# config.yaml
connections:
  postgres: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
```

```shell
# .env
export POSTGRES_PASSWORD=secret
```

# Development

Install [Task](https://taskfile.dev).

For `IMG` one of `bootstrap`, `lazydocker`, `usql`:

```shell
$ task init
$ task build:IMG
$ task testrun:IMG
$ task release:IMG
$ task clean
```
