#!/bin/sh

. ./util.sh

if [ ! -x "${which systemctl}" ]; then
    echo "systemctl not found" 1>&2
    exit 1
fi

if [ ! -x "${which git}" ]; then
    echo "git not found" 1>&2
    exit 1
fi

# stop the systemd service
systemctl stop searx-docker.service

# save local modification
git stash push

# update only if fast forward can be used, saver than "git pull --rebase"
git pull --ff-only || {
    git stash pop
    echo "The local and remote branches have diverged. Please update manually."
    echo "Use\n  systemctl start searx-docker.service\nto restart searx"
    exit 1
}

# re-apply local modification
git stash pop

# update docker images
docker-compose pull

# update searx configuration
source ./.env
docker-compose run searx ${SEARX_COMMAND} -d

# let the user see
echo "Use\n  systemctl start searx-docker.service\nto restart searx"
