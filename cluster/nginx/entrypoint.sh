#!/bin/sh
set -e

rm -f /etc/nginx/conf.d/*

htpasswd -cBb /etc/nginx/conf.d/nginx.htpasswd ${REGISTRY_USERNAME} ${REGISTRY_PASSWORD}

# get host ip
HOSTIP=$(grep -e $HOSTNAME /etc/hosts | sed -r 's|('"$HOSTNAME"')||g')

echo $HOSTIP > /etc/nginx/conf.d/hostip
echo $HOSTNAME > /etc/nginx/conf.d/hostname
echo $REGISTRY_USERNAME > /etc/nginx/conf.d/username
echo $REGISTRY_PASSWORD > /etc/nginx/conf.d/passwd

# generate CA
openssl req -newkey rsa:4096 -nodes -sha256 \
  -keyout /etc/nginx/conf.d/ca.key \
  -x509 -days 365 \
  -subj "/O=rapidpro/CN=rapidpro" \
  -addext "subjectAltName=IP:$HOSTIP" \
  -out /etc/nginx/conf.d/ca.crt

. /docker-entrypoint.sh
