#!/bin/sh

docker run -d \
  --name backend-1 \
  -p 5000:5000 \
  -e SERVICE_ID="Backend-1" \
  --rm \
  backend-flask:v1