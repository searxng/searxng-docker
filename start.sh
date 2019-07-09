#!/bin/sh

. ./util.sh

if grep -q "MORTY_KEY=RemplaceWithARealKey!" .env; then
    echo "In the .env file, you must configure MORTY_KEY" 1>&2
    CANT_START=1
fi

if grep -q "FILTRON_PASSWORD=password" .env; then
    echo "In the .env file, you must configure FILTRON_PASSWORD" 1>&2
    CANT_START=1
fi

if [ $CANT_START ]; then
    exit 1
fi

$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE down -v
$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE rm -fv
$DOCKERCOMPOSE -f $DOCKERCOMPOSEFILE up
