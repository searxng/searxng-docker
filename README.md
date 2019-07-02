# searx-docker

Create a new searx instance in five minutes using Docker ( 
See https://github.com/asciimoo/searx/issues/1561 )

Do not use it for now : this is a work in progress and there is no antibot feature.

## How to use it
- [Install docker](https://docs.docker.com/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/)
- ```git clone https://github.com/searx/searx-docker.git```
- Configure the .env file
- ```docker-compose up -d```

## What is included for now ?

- [Caddy](https://github.com/mholt/caddy) as a reverse proxy (take care to call LetsEncrypt)
- [searx](https://github.com/asciimoo/searx). See [#1629](https://github.com/asciimoo/searx/pull/1629) to build the docker image.
- [morty](https://github.com/asciimoo/morty). See [#73](https://github.com/asciimoo/morty/pull/73) to build the docker image.
