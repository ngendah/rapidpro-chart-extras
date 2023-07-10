#!/usr/bin/env sh

export POSTGRES_PORT="${POSTGRES_PORT:-5432}"
export DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:$POSTGRES_PORT/${POSTGRES_DB}"

_create_pass_file(){
  PASSFILE=$HOME/.pgpass
  echo "*:*:*:$POSTGRES_USER:$POSTGRES_PASSWORD" > $PASSFILE
  chmod 0600 $PASSFILE
}

_check_conn(){
  RETRIES=10
  
  until PGPASSFILE=$PASSFILE psql -lqt -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB > /dev/null 2>&1 || [ $RETRIES -eq 0 ]; do
    echo "Waiting for postgres server, $RETRIES remaining attempts ..."
    RETRIES=$((RETRIES-=1))
    sleep 5
  done
  
  PGPASSFILE=$PASSFILE psql -lqt -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB > /dev/null 2>&1
  DB_CONN_STATUS=$?
  if [ "$DB_CONN_STATUS" -ne 0 ]; then
    echo "unable to connect to the database"
    exit 1
  fi
}

check_db_conn(){
  _create_pass_file
  _check_conn
}

db_exists(){
  local result="$(PGPASSFILE=$PASSFILE psql -lqt -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER | cut -d\| -f1 | grep -w "\b$POSTGRES_DB\b")"
  echo $result
}
