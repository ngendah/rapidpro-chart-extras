#!/usr/bin/env sh

export COURIER_REDIS="${REDIS_URL}/13"
export COURIER_ADDRESS=0.0.0.0
export COURIER_DB="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@$POSTGRES_HOST:$POSTGRES_PORT/${POSTGRES_DB}?sslmode=disable"

exec ./courier
