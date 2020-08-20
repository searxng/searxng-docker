#!/bin/sh
#
# Disclaimer: this is more a documentation than code to execute
#

# change if require
SERVICE_NAME="searx-docker.service"

# change if require :
# fastforward : only fast-forward
# rebase : rebase with autostash, at your own risk
UPDATE_TYPE="fastforward"

READLINK="$(which readlink greadlink | tail -n1)"
BASE_DIR="$(dirname -- "`$READLINK -f -- "$0"`")"
cd -- "$BASE_DIR"

# check if git presence
if [ ! -x "$(which git)" ]; then
    echo "git not found" 1>&2
    exit 1
fi

# check if the current user owns the local git repository
git_owner=$(stat -c '%U' .git)
if [ "$git_owner" != "$(whoami)" ]; then
    echo "The .git repository is own by $git_owner" 1>&2
    exit 1
fi

# warning if the current branch is not master
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "master" ]; then
    echo "Warning: master won't be updated, only $current_branch"
fi

# git fetch first
git fetch origin master

# is everything already up-to-date ?
current_commit=$(git rev-parse $current_branch)
origin_master_commit=$(git rev-parse origin/master)
if [ "$current_commit" = "$origin_master_commit" ]; then
    echo "Already up-to-date, commit $current_commit"
    exit 0
fi

# docker stuff
SEARX_DOCKERCOMPOSE=$(grep "Environment=SEARX_DOCKERCOMPOSEFILE=" "$SERVICE_NAME" | awk -F\= '{ print $3 }')
. ./util.sh

if [ ! -x "$(which systemctl)" ]; then
    echo "systemctl not found" 1>&2
    exit 1
fi

# stop the systemd service now, because after the update
# the code might be out of sync with the current running services
systemctl stop "${SERVICE_NAME}"

# update
case "$UPDATE_TYPE" in
    "fastforward")
	git pull --ff-only origin master
	;;
    "rebase")
	git pull --rebase --autostash origin master
	;;
esac

# Check conflicts
if [ $(git ls-files -u | wc -l) -gt 0 ]; then
    echo "There are git conflicts"
else
    # update docker images
    docker-compose -f $DOCKERCOMPOSEFILE pull

    # remove dangling images
    docker rmi $(docker images -f "dangling=true" -q)

    # display searx version
    SEARX_IMAGE=$(cat $DOCKERCOMPOSEFILE | grep "searx/searx" | grep -v "searx-checker" | awk '{ print $2 }')
    SEARX_VERSION=$(docker inspect -f '{{index .Config.Labels "org.label-schema.version"}}' $SEARX_IMAGE)
    echo "Searx version: $SEARX_VERSION"
    docker images --digests "searx/*:latest"

    # update searx configuration
    source ./.env
    docker-compose -f $DOCKERCOMPOSEFILE run searx ${SEARX_COMMAND} -d

    # let the user see
    echo "Use\nsystemctl start \"${SERVICE_NAME}\"\nto restart searx"
fi
