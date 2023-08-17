#!/bin/sh

##
## Copyright (c) 2023 Ngenda Henry
##
## For the license information refer to LICENSE.
##

set -e

# variable definations
#
SCRIPT_DIR=$(dirname "$0")
POSTGRESQL_CONF_DIR=$(realpath "$SCRIPT_DIR/postgresql.conf.d")

POSTGRES_USER="$(cat $POSTGRESQL_CONF_DIR/username)"
POSTGRES_PASSWORD="$(cat $POSTGRESQL_CONF_DIR/passwd)"
POSTGRES_DB="$(cat $POSTGRESQL_CONF_DIR/database)"
POSTGRES_HOST="$(cat $POSTGRESQL_CONF_DIR/hostip)"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"

DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:$POSTGRES_PORT/${POSTGRES_DB}"

echo $DATABASE_URL




