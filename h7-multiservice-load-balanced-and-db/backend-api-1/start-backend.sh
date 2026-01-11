#!/bin/sh

docker run -d \
  --name backend-1 \
  --network app-net \
  -e SERVICE_ID=Backend-1 \
  -e FLASK_RUN_PORT=5000 \
  -e DATABASE_URL="postgresql://postgres:GG-dev-26@postgres-db:5432/mydb" \
  -p 5000:5000 \
  --rm \
  backend-flask:v1
