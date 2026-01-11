#!/bin/sh

docker run -d \
  --name backend-2 \
  -p 5001:5000 \
  -e SERVICE_ID="Backend-2" \
  --rm \
  backend-flask:v1