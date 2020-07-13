#!/bin/sh

BASE_DIR="$(dirname -- "`readlink -f -- "$0"`")"
cd -- "$BASE_DIR"

. ./util.sh

$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE down
$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE rm -fv
$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE up
