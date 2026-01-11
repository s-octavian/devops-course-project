#!/bin/sh

docker run -d \
  --name rproxy \
  -p 443:443 \
  --network app-net \
  --rm \
  rproxy:v1
