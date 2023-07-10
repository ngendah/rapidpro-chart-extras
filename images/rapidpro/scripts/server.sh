#!/usr/bin/env sh

. ./common.sh

check_db_conn

echo "Starting Rapidpro server user=$(id -u) ..."

poetry run ./manage.py runserver 0.0.0.0:8000
