# searx-docker

Create a new searx instance in five minutes using Docker ( 
See https://github.com/asciimoo/searx/issues/1561 )

Do not use it for now : this is a work in progress and there is no antibot feature.

## What is included ?

- [Caddy](https://github.com/abiosoft/caddy-docker) as a reverse proxy (create a LetsEncrypt certificate automaticaly)
- [filtron](https://github.com/asciimoo/filtron): See [#4](https://github.com/asciimoo/filtron/pull/4) to build the docker image.
- [searx](https://github.com/asciimoo/searx): See [#1629](https://github.com/asciimoo/searx/pull/1629) to build the docker image.
- [morty](https://github.com/asciimoo/morty): clone the project, then "make build" to create the docker image

## How to use it
- [Install docker](https://docs.docker.com/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/)
- Get searx-docker
```sh
cd /usr/local
git clone https://github.com/searx/searx-docker.git
cd searx-docker
```
- Edit the .env file according to your need
- Check everything is working: ```./start.sh```,
- ```cp searx-docker.service.template searx-docker.service```
- edit the content of ```WorkingDirectory``` in the ```searx-docker.service``` file (only if the installation path is different from /usr/local/searx-docker)
- Install the systemd unit :
```sh
systemctl enable $(pwd)/searx-docker.service
systemctl start searx-docker.service
```

## Custom docker-compose.yaml

Do not modify docker-compose.yaml otherwise you won't be able to update easily from the git repository.

It is possible to the [extend feature](https://docs.docker.com/compose/extends/) of docker-compose :
- stop the service : ```systemctl stop searx-docker.service```
- create a new docker-compose-extend.yaml, check with ```start.sh```
- update searx-docker.service (see SEARX_DOCKERCOMPOSEFILE)
- restart the servie  : ```systemctl restart searx-docker.service```

## How to update ?

- Check the content of ```update.sh```
