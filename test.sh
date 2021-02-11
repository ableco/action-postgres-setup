#!/bin/bash
POSTGRES_VERSION=$1
MAX_CONNECTIONS=$2

if [ -z "$var" ]; then
  echo "s/^max_connections = 100.*$/max_connections = $MAX_CONNECTIONS/"
fi

