#!/bin/sh

READLINK="$(which readlink greadlink | tail -n1)"
BASE_DIR="$(dirname -- "`$READLINK -f -- "$0"`")"
cd -- "$BASE_DIR"

. ./util.sh

$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE down
