#!/usr/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    local type="$1"
    local message="$2"
    local color="$GREEN"
    [[ "$type" == "ERROR" ]] && color="$RED"
    echo -e "${color}$(date '+%Y-%m-%d %H:%M:%S') [$type] - $message${NC}"
}

APP_DIR="layered_application"
ENV_FILE="${APP_DIR}/backend/.env"

if [[ ! -f "$ENV_FILE" ]]; then
    log ERROR ".env not found in $ENV_FILE"
    exit 1
fi

export $(grep -v '^#' "$ENV_FILE" | xargs)

if [[ -z "$1" ]]; then
    log ERROR "Usage: $0 <dump_file.sql>"
    exit 1
fi

DUMP_FILE="$1"

if [[ ! -f "$DUMP_FILE" ]]; then
    log ERROR "Dump file not found: $DUMP_FILE"
    exit 1
fi

log INFO "Restoring DB from $DUMP_FILE"

mysql \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    "$DB_NAME" < "$DUMP_FILE"

if [[ $? -eq 0 ]]; then
    log INFO "Restore completed successfully"
else
    log ERROR "Restore failed"
    exit 1
fi

