#!/bin/sh

. ./util.sh

$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE down -v
