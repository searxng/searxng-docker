# fufusoup-docker

Create a new Fufusoup  instance in five minutes using Docker

## What is included ?

| Name | Description | Docker image | Dockerfile |
| -- | -- | -- | -- |
| [Caddy](https://github.com/caddyserver/caddy) | Reverse proxy (create a LetsEncrypt certificate automatically) | [caddy/caddy:2-alpine](https://hub.docker.com/_/caddy) | [Dockerfile](https://github.com/caddyserver/caddy-docker) |
| [Fufusoup](https://github.com/mkmtech7/fufusoup) | Fufusoup by itself | [mkmtechnology/fufusoup:1.0](https://hub.docker.com/repository/docker/mkmtechnology/fufusoup) | [Dockerfile](https://github.com/mkmtech7/fufusoup/blob/master/Dockerfile) |
| [Redis](https://github.com/redis/redis) | In-memory database | [redis:alpine](https://hub.docker.com/_/redis) | [Dockerfile-alpine.template](https://github.com/docker-library/redis/blob/master/Dockerfile-alpine.template) |

## How to use it
- [Install docker](https://docs.docker.com/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/) (be sure that docker-compose version is at least 1.9.0)
- Get fufusoup-docker
  ```sh
  cd /usr/local
  git clone https://github.com/mkmtech7/fufusoup-docker
  cd searxng-docker
  ```
- Edit the [.env](https://github.com/mkmtech7/fufusoup-docker/blob/master/.env) file to set the hostname and an email
- Generate the secret key ```sed -i "s|ultrasecretkey|$(openssl rand -hex 32)|g" searxng/settings.yml```
- Edit the [searxng/settings.yml](https://github.com/mkmtech7/fufusoup-docker/blob/master/searxng/settings.yml) file according to your need
- Check everything is working: ```docker-compose up```
- Run Fufusoup in the background: ```docker-compose up -d```

## How to access the logs
To access the logs from all the containers use: `docker-compose logs -f`.

To access the logs of one specific container:
- Caddy: `docker-compose logs -f caddy`
- Fufusoup: `docker-compose logs -f fufusoup`
- Redis: `docker-compose logs -f redis`

### Start Fufusoup with systemd

You can skip this step if you don't use systemd.

- ```cp searxng-docker.service.template searxng-docker.service```
- edit the content of ```WorkingDirectory``` in the ```searxng-docker.service``` file (only if the installation path is different from /usr/local/searxng-docker)
- Install the systemd unit:
  ```sh
  systemctl enable $(pwd)/searxng-docker.service
  systemctl start searxng-docker.service
  ```

## Note on the image proxy feature

The Fufusoup image proxy is activated by default.

The default [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) allow the browser to access to ```${SEARXNG_HOSTNAME}``` and ```https://*.tile.openstreetmap.org;```.

If some users wants to disable the image proxy, you have to modify [./Caddyfile](https://github.com/searxng/searxng-docker/blob/master/Caddyfile). Replace the ```img-src 'self' data: https://*.tile.openstreetmap.org;``` by ```img-src * data:;```.

## Multi Architecture Docker images

Supported architecture:
- amd64
- arm64
- arm/v7

## How to update ?

To update the SearXNG stack:

```sh
docker-compose pull
docker-compose down
docker-compose up
```

To update this `docker-compose.yml` file:

Check out the newest version on github: [fufusoup/fufusoup-docker](https://github.com/searxng/searxng-docker).
