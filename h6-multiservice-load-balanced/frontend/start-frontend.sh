#!/bin/sh

docker run -d \
  --name frontend \
  -p 8080:80 \
  --rm \
  frontend-nginx:v1