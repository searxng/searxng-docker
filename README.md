# searxng-docker

Create a new SearXNG  instance in five minutes using Docker

## What is included ?

| Name | Description | Docker image | Dockerfile |
| -- | -- | -- | -- |
| [Caddy](https://github.com/caddyserver/caddy) | Reverse proxy (create a LetsEncrypt certificate automatically) | [caddy/caddy:2-alpine](https://hub.docker.com/_/caddy) | [Dockerfile](https://github.com/caddyserver/caddy-docker) |
| [Filtron](https://github.com/searxng/filtron) |  Filtering reverse HTTP proxy, bot and abuse protection | [dalf/filtron:latest](https://hub.docker.com/r/dalf/filtron) | See [asciimoo/filtron#4](https://github.com/asciimoo/filtron/pull/4) |
| [SearXNG](https://github.com/searxng/searxng) | SearXNG by itself | [searxng/searxng:latest](https://hub.docker.com/r/searxng/searxng) | [Dockerfile](https://github.com/searxng/searxng/blob/master/Dockerfile) |
| [Morty](https://github.com/dalf/morty) | Privacy aware web content sanitizer proxy as a service. | [dalf/morty:latest](https://hub.docker.com/r/dalf/morty) | [Dockerfile](https://github.com/dalf/morty/blob/master/Dockerfile) |

## How to use it
- [Install docker](https://docs.docker.com/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/) (be sure that docker-compose version is at least 1.9.0).
- only on MacOSX: ```brew install coreutils``` to install ```greadlink```
- Get searxng-docker
```sh
cd /usr/local
git clone https://github.com/searxng/searxng-docker.git
cd searxng-docker
```
- Generate MORTY_KEY ```sed -i "s|ReplaceWithARealKey\!|$(openssl rand -base64 33)|g" .env```
- Edit the other settings in [.env](https://github.com/searxng/searxng-docker/blob/master/.env) file according to your need
- Check everything is working: ```./start.sh```,
- ```cp searxng-docker.service.template searxng-docker.service```
- edit the content of ```WorkingDirectory``` in the ```searxng-docker.service``` file (only if the installation path is different from /usr/local/searxng-docker)
- Install the systemd unit :
```sh
systemctl enable $(pwd)/searxng-docker.service
systemctl start searxng-docker.service
```

## Note on the image proxy feature

The SearXNG image proxy is activated by default using [Morty](https://github.com/dalf/morty).

The default [Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) allow the browser to access to {SEARXNG_HOSTNAME} and ```https://*.tile.openstreetmap.org;```.

If some users wants to disable the image proxy, you have to modify [./Caddyfile](https://github.com/searxng/searxng-docker/blob/master/Caddyfile). Replace the ```img-src 'self' data: https://*.tile.openstreetmap.org;``` by ```img-src * data:;```

## Custom docker-compose.yaml

Do not modify docker-compose.yaml otherwise you won't be able to update easily from the git repository.

It is possible to the [extend feature](https://docs.docker.com/compose/extends/) of docker-compose :
- stop the service : ```systemctl stop searxng-docker.service```
- create a new docker-compose-extend.yaml, check with ```start.sh```
- update searxng-docker.service (see SEARXNG_DOCKERCOMPOSEFILE)
- restart the servie  : ```systemctl restart searxng-docker.service```

## Multi Architecture Docker images

For now only the amd64 platform is supported.

## How to update ?

Check the content of [```update.sh```](https://github.com/searxng/searxng-docker/blob/master/update.sh)

## Access to the Filtron API

The [Filtron API](https://github.com/searxng/filtron#api) is available on ```http://localhost:4041```

For example, to display the loaded rules:
```
curl http://localhost:4041/rules | jq
```
