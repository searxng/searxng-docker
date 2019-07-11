#!/bin/sh

BASE_DIR="$(dirname -- "`readlink -f -- "$0"`")"
cd -- "$BASE_DIR"

. ./util.sh

$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE down -v
