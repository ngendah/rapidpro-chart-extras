#!/usr/bin/env sh

. ./common.sh

check_db_conn

if [ "$(db_exists)" != "$POSTGRES_DB" ]; then
  echo "Creating database $POSTGRES_DB"
  PGPASSFILE=$PASSFILE psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -c "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;"
fi

if [ -z "$ADMIN_USERNAME" ] && [ -z "$ADMIN_PASSWORD" ] && [ -z "$ADMIN_EMAIL" ]; then
  echo "creating admin user ..."
  poetry run ./manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser(\"$ADMIN_USERNAME\", \"$ADMIN_EMAIL\", \"$ADMIN_PASSWORD\")"
else
  echo "admin user credentials not available, skipping create admin ..."
fi

echo "running migrations, might take a while ..."
poetry run ./manage.py migrate
