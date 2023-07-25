#!/usr/bin/env sh

export ARCHIVER_DB="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@$POSTGRES_HOST:$POSTGRES_PORT/${POSTGRES_DB}?sslmode=disable"

exec ./rp-achiver
