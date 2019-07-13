#!/bin/sh

. ./util.sh

SERVICE_NAME="searx-docker.service"

if [ ! -x "$(which systemctl)" ]; then
    echo "systemctl not found" 1>&2
    exit 1
fi

if [ ! -x "$(which git)" ]; then
    echo "git not found" 1>&2
    exit 1
fi

# stop the systemd service
systemctl stop "${SERVICE_NAME}"

# update, change to 'git pull --rebase --autostash origin master' at your own risk
git pull --ff-only --autostash origin master

if [ $(git ls-files -u | wc -l) -gt 0 ]; then
    echo "There are git conflicts"
else
    # update docker images
    docker-compose pull

    # update searx configuration
    source ./.env
    docker-compose run searx ${SEARX_COMMAND} -d
fi

# let the user see
echo "Use\nsystemctl start \"${SERVICE_NAME}\"\nto restart searx"
