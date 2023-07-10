#!/bin/sh

##
## Copyright (c) 2023 Ngenda Henry
##
## For the license information refer to LICENSE.
##

set -e

# variable definations
#
RETRIES=10
CLUSTER_NAME=rapidpro-cluster
SCRIPT_DIR=$(dirname "$0")
KUBECONFIG_DIR=$(realpath "$SCRIPT_DIR")
REGISTRY_CONF_DIR=$(realpath "$SCRIPT_DIR/registry.conf.d")
POSTGRESQL_CONF_DIR=$(realpath "$SCRIPT_DIR/postgresql.conf.d")

# functions
#
stop_services(){
  sudo docker compose -f $SCRIPT_DIR/docker-compose.yaml stop || true
  sudo k3d cluster delete $CLUSTER_NAME || true
}

clean_up(){
  sudo rm -f $KUBECONFIG_DIR/kubeconfig 
  sudo rm -rf $REGISTRY_CONF_DIR/*
  sudo rm -rf $POSTGRESQL_CONF_DIR/*
  if [ ! -f "$SCRIPT_DIR/run.clean" ]; then
    return 0
  fi
  for dir in $(cat $SCRIPT_DIR/run.clean); do
    sudo rm -rf $dir
  done
  sudo rm -f $SCRIPT_DIR/run.clean
}

# Main program
#
if [ ! -d $REGISTRY_CONF_DIR ]; then
  mkdir $REGISTRY_CONF_DIR
fi

if [ ! -d $POSTGRESQL_CONF_DIR ]; then
  mkdir $POSTGRESQL_CONF_DIR
fi

stop_services
clean_up

if [ "$1" = "stop" ]; then
  exit 0
fi

sudo docker compose -f $SCRIPT_DIR/docker-compose.yaml up --detach --build

until [ -f "$REGISTRY_CONF_DIR/ca.crt" ] || [ $RETRIES -eq 0 ]; do
  echo "waiting for compose to be up ...$RETRIES";
  RETRIES=$((RETRIES-=1));
  sleep 5
done

if [ $RETRIES -eq 0 ] && [ ! -f "$REGISTRY_CONF_DIR/ca.crt" ]; then
  echo "compose failed to create TLS CA file, exiting"
  stop_services
  exit 1
fi

POSTGRES_HOSTNAME=$(cat $POSTGRESQL_CONF_DIR/hostname)
POSTGRES_IP=$(cat $POSTGRESQL_CONF_DIR/hostip)
POSTGRES_PORT=$(cat $POSTGRESQL_CONF_DIR/hostport)
POSTGRES_USERNAME=$(cat $POSTGRESQL_CONF_DIR/username)
POSTGRES_DB=$(cat $POSTGRESQL_CONF_DIR/database)
POSTGRES_PASSWD=$(cat $POSTGRESQL_CONF_DIR/passwd)

REGISTRY_HOSTNAME=$(cat $REGISTRY_CONF_DIR/hostname)
REGISTRY_IP=$(cat $REGISTRY_CONF_DIR/hostip)
REGISTRY_USERNAME=$(cat $REGISTRY_CONF_DIR/username)
REGISTRY_PASSWD=$(cat $REGISTRY_CONF_DIR/passwd)
REGISTRY_AUTH=$(echo -n "$REGISTRY_USERNAME:$REGISTRY_PASSWD" | base64)
REGISTRY_NETWORK=$(sudo docker inspect $REGISTRY_HOSTNAME | jq -r '.[].NetworkSettings.Networks | keys[0]')

cat<<EOF | sudo tee "$REGISTRY_CONF_DIR/registry.yaml" > /dev/null
mirrors:
  $REGISTRY_IP:
    endpoint:
      - $REGISTRY_IP

configs:
  $REGISTRY_IP:
    auth:
      username: $REGISTRY_USERNAME
      password: $REGISTRY_PASSWD
    tls:
      ca_file: "/etc/ssl/certs/ca.crt"
EOF

sudo k3d cluster create $CLUSTER_NAME --servers=1 --agents=2 --network=$REGISTRY_NETWORK \
  --volume="$REGISTRY_CONF_DIR/registry.yaml:/etc/rancher/k3s/registries.yaml" \
  --volume="$REGISTRY_CONF_DIR/ca.crt:/etc/ssl/certs/ca.crt"

cat<<EOF | sudo tee "$REGISTRY_CONF_DIR/dockerconfig.json" > /dev/null
{
  "auths":
  {
    "$REGISTRY_IP":
    {
      "username": "$REGISTRY_USERNAME",
      "password": "$REGISTRY_PASSWD",
      "email": "",
      "auth": "$REGISTRY_AUTH"
    }
  }
}
EOF

cat<<EOF | sudo tee "$REGISTRY_CONF_DIR/cluster-config.yaml" > /dev/null
---
apiVersion: v1
kind: Secret
metadata:
  name: database-credentials
stringData:
  POSTGRES_USER: $POSTGRES_USERNAME
  POSTGRES_PASSWORD: $POSTGRES_PASSWD
  POSTGRES_DB: $POSTGRES_DB
---
apiVersion: v1
kind: Secret
metadata:
  name: admin-credentials
stringData:
  ADMIN_USERNAME: temba
  ADMIN_PASSWORD: $(openssl rand -hex 12)
  ADMIN_EMAIL: temba@nw.net
---
apiVersion: v1
kind: Secret
metadata:
  name: registry
data:
  .dockerconfigjson: $(base64 -w0 "$REGISTRY_CONF_DIR/dockerconfig.json")
type: kubernetes.io/dockerconfigjson
---
EOF

sudo k3d kubeconfig get $CLUSTER_NAME > $KUBECONFIG_DIR/kubeconfig
kubectl --kubeconfig=$KUBECONFIG_DIR/kubeconfig apply -f "$REGISTRY_CONF_DIR/cluster-config.yaml"

if [ "$1" = "install" ]; then
  sudo mkdir -p /etc/docker/certs.d/$REGISTRY_IP
  sudo cp $REGISTRY_CONF_DIR/ca.crt /etc/docker/certs.d/$REGISTRY_IP/
  echo "/etc/docker/certs.d/$REGISTRY_IP" >> $SCRIPT_DIR/run.clean
fi
