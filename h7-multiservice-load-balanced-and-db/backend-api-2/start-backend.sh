#!/bin/sh

docker run -d \
  --name backend-2 \
  --network app-net \
  -e SERVICE_ID=Backend-2 \
  -e FLASK_RUN_PORT=5000 \
  -e DATABASE_URL="postgresql://postgres:GG-dev-26@postgres-db:5432/mydb" \
  -p 5001:5000 \
  --rm \
  backend-flask:v1
