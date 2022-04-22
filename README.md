# searxng-docker

Create a new SearXNG  instance in five minutes using Docker

## What is included ?

| Name | Description | Docker image | Dockerfile |
| -- | -- | -- | -- |
| [Caddy](https://github.com/caddyserver/caddy) | Reverse proxy (create a LetsEncrypt certificate automatically) | [caddy/caddy:2-alpine](https://hub.docker.com/_/caddy) | [Dockerfile](https://github.com/caddyserver/caddy-docker) |
| [SearXNG](https://github.com/searxng/searxng) | SearXNG by itself | [searxng/searxng:latest](https://hub.docker.com/r/searxng/searxng) | [Dockerfile](https://github.com/searxng/searxng/blob/master/Dockerfile) |
| [Redis](https://github.com/redis/redis) | In-memory database | [redis:alpine](https://hub.docker.com/_/redis) | [Dockerfile-alpine.template](https://github.com/docker-library/redis/blob/master/Dockerfile-alpine.template) |

## How to use it
- [Install docker](https://docs.docker.com/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/) (be sure that docker-compose version is at least 1.9.0)
- Get searxng-docker
  ```sh
  cd /usr/local
  git clone https://github.com/searxng/searxng-docker.git
  cd searxng-docker
  ```
- Edit the [.env](https://github.com/searxng/searxng-docker/blob/master/.env) file to set the hostname and an email
- Generate the secret key ```sed -i "s|ultrasecretkey|$(openssl rand -hex 32)|g" searxng/settings.yml```
- Edit the [searxng/settings.yml](https://github.com/searxng/searxng-docker/blob/master/searxng/settings.yml) file according to your need
- Check everything is working: ```docker-compose up```

### Start SearXNG with systemd

You can skip this step if you don't use systemd.

- ```cp searxng-docker.service.template searxng-docker.service```
- edit the content of ```WorkingDirectory``` in the ```searxng-docker.service``` file (only if the installation path is different from /usr/local/searxng-docker)
- Install the systemd unit:
  ```sh
  systemctl enable $(pwd)/searxng-docker.service
  systemctl start searxng-docker.service
  ```

## Note on the image proxy feature

The SearXNG image proxy is activated by default.

The default [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) allow the browser to access to ```${SEARXNG_HOSTNAME}``` and ```https://*.tile.openstreetmap.org;```.

If some users wants to disable the image proxy, you have to modify [./Caddyfile](https://github.com/searxng/searxng-docker/blob/master/Caddyfile). Replace the ```img-src 'self' data: https://*.tile.openstreetmap.org;``` by ```img-src * data:;```.

## Custom docker-compose.yaml

Do not modify docker-compose.yaml otherwise you won't be able to update easily from the git repository.

It is possible to use the [extend feature](https://docs.docker.com/compose/extends/) of docker-compose:
- stop the service: ```systemctl stop searxng-docker.service```
- create a new docker-compose-extend.yaml, check with ```start.sh```
- update searxng-docker.service (see SEARXNG_DOCKERCOMPOSEFILE)
- restart the service: ```systemctl restart searxng-docker.service```

## Multi Architecture Docker images

Supported architecture:
- amd64
- arm64
- arm/v7
