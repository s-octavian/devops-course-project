#!/bin/sh

cd rproxy/ || exit 1

mkdir -p certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048   -keyout certs/server.key   -out certs/server.crt   -subj "/CN=localhost"
