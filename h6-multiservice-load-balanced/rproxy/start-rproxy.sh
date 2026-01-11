#!/bin/sh

docker run -d \
  --name rproxy \
  -p 443:443 \
  --link backend-1 \
  --link backend-2 \
  --link frontend \
  --rm \
  rproxy:v1