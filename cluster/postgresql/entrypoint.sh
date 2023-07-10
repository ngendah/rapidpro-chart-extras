#!/bin/bash

set -e

mkdir -p /etc/postgresql/conf.d
rm -f /etc/postgresql/conf.d/*

# get host ip
HOSTIP=$(grep -e $HOSTNAME /etc/hosts | sed -r 's|('"$HOSTNAME"')||g')

POSTGRES_PORT=5432

echo $HOSTIP > /etc/postgresql/conf.d/hostip
echo $HOSTNAME > /etc/postgresql/conf.d/hostname
echo $POSTGRES_USER > /etc/postgresql/conf.d/username
echo $POSTGRES_PASSWORD > /etc/postgresql/conf.d/passwd
echo $POSTGRES_DB > /etc/postgresql/conf.d/database
echo $POSTGRES_PORT > /etc/postgresql/conf.d/hostport

exec su-exec "$(id -u)" "docker-entrypoint.sh" "$@"
