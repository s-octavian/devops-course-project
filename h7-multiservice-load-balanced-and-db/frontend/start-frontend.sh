#!/bin/sh

docker run -d \
  --name frontend \
  --network app-net \
  -p 8080:80 \
  --rm \
  frontend-nginx:v1
