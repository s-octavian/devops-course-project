#!/bin/sh

for i in {1..10}; do curl -k https://localhost/api/status; echo; done