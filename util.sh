set -e

DOCKERCOMPOSE=$(which docker-compose || echo "/usr/local/bin/docker-compose")
DOCKERCOMPOSEFILE="${DOCKERCOMPOSEFILE:-docker-compose.yaml}"

echo "use ${DOCKERCOMPOSEFILE}"

if [ ! -x "$(which docker)" ]; then
    echo "docker not found" 1>&2
    exit 1
fi

if ! docker version > /dev/null 2>&1; then
    echo "can't execute docker (current user: $(whoami))" 1>&2
    exit 1
fi

if [ ! -x "${DOCKERCOMPOSE}" ]; then
    echo "docker-compose not found" 1>&2
    exit 1
fi

if [ ! -f "${DOCKERCOMPOSEFILE}" ]; then
    echo "${DOCKERCOMPOSEFILE} not found" 1>&2
    exit 1
fi
