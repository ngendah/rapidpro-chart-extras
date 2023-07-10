#!/usr/bin/env sh

. ./common.sh

export CELERY_REDIS_SCHEDULER_URL="$REDIS_URL/10"
export CELERY_REDIS_SCHEDULER_KEY_PREFIX="tasks:meta:"

check_db_conn

poetry run celery -A temba worker --beat -l debug -Q flows,msgs,handler,celery -c 2 -S celerybeatredis.schedulers.RedisScheduler
