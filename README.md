# searx-docker

Create a new searx instance in five minutes using Docker ( 
See https://github.com/asciimoo/searx/issues/1561 )

Do not use it for now : this is a work in progress and there is no antibot feature.

## How to use it
- [Install docker](https://docs.docker.com/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/)
- Get searx-docker
```sh
mkdir -p /opt
cd /opt
git clone https://github.com/searx/searx-docker.git
```
- Configure the .env file
- Check using ```docker-compose up```
- If everything is working, then :
```sh
cp /opt/searx-docker/searx-docker.service  /etc/systemd/system
systemctl start searx-docker.service
```

## What is included ?

- [Caddy](https://github.com/abiosoft/caddy-docker) as a reverse proxy (take care to call LetsEncrypt)
- [filtron](https://github.com/asciimoo/filtron): See [#4](https://github.com/asciimoo/filtron/pull/4) to build the docker image.
- [searx](https://github.com/asciimoo/searx): See [#1629](https://github.com/asciimoo/searx/pull/1629) to build the docker image.
- [morty](https://github.com/asciimoo/morty): clone the project, then "make build" to create the docker image
