#!/bin/sh

docker run -d \
  --network app-net \
  --name postgres-db \
  --env-file .env \
  -p 5432:5432 \
  -v $(pwd)/db-data:/var/lib/postgresql/data \
  --rm \
  db-postgres:v1
