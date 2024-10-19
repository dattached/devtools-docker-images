# dattached/lazydocker

Docker Hub image builder for [Lazydocker](https://github.com/jesseduffield/lazydocker) terminal UI.

Requires [Task](https://taskfile.dev) to be installed.

## Usage

### Docker

```shell
$ docker run --rm -it \
-v /var/run/docker.sock:/var/run/docker.sock \
dattached/lazydocker
```

### Docker compose

```yaml
services:
  # ...
  lazydocker:
    image: dattached/lazydocker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      #- ./compose.yml:/compose.yml:ro
      #- ./config.yml:/root/.config/lazydocker/config.yml:ro
```

## Development

```shell
$ task build testrun
$ task publish
$ task clean
```
