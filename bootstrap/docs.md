# Bootstrap scripts

* [debian-add-apt-postgresql.sh](#debian-add-apt-postgresqlsh)
* [debian-apt-install-devtools.sh](#debian-apt-install-devtoolssh)
* [debian-pip-install-uv.sh](#debian-pip-install-uvsh)


## debian-add-apt-postgresql.sh

Add https://apt.postgresql.org repository with latest PostgreSQL packages.

### Synopsis
```shell
debian-add-apt-postgresql.sh [-h]
```

### Example
```Dockerfile
# Dockerfile
RUN --mount=type=cache,dst=/var/cache/apt,sharing=locked \
    --mount=type=cache,dst=/var/lib/apt,sharing=locked \
    --mount=type=bind,from=dattached/bootstrap,dst=/b \
    apt-get update; \
    bash /b/debian-add-apt-postgresql.sh; \
    rm -rf /tmp/* /var/tmp/*
```

## debian-apt-install-devtools.sh

Install standard devtools.

### Synopsis
```shell
debian-apt-install-devtools.sh [-h]
```

### Example
```Dockerfile
# Dockerfile
ENV TASK_VERSION=x.y.z
# if TASK_VERSION is not specified, the latest GitHub release version is used
RUN --mount=type=cache,dst=/var/cache/apt,sharing=locked \
    --mount=type=cache,dst=/var/lib/apt,sharing=locked \
    --mount=type=bind,from=dattached/bootstrap,dst=/b \
    apt-get update; \
    bash /b/debian-apt-install-devtools.sh; \
    rm -rf /tmp/* /var/tmp/*
```

## debian-pip-install-uv.sh

Install and configure uv with system pip under root.

Generates `uv` config:
```toml
# /root/.config/uv/uv.toml
compile-bytecode = true
link-mode = "copy"
python-downloads = "never"
[pip]
compile-bytecode = true
require-hashes = true
verify-hashes = true
```

### Synopsis
```shell
debian-pip-install-uv.sh [-h]
```

### Example
```Dockerfile
# Dockerfile
RUN --mount=type=cache,dst=/root/.cache/pip \
    --mount=type=bind,from=dattached/bootstrap,dst=/b \
    bash /b/debian-pip-install-uv.sh
```
