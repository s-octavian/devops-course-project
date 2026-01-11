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

# Load env vars
export $(grep -v '^#' "$ENV_FILE" | xargs)

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
DUMP_FILE="./${DB_NAME}_${TIMESTAMP}.sql"

log INFO "Creating DB dump in current directory"

mysqldump \
    -h "$DB_HOST" \
    -P "$DB_PORT" \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    "$DB_NAME" > "$DUMP_FILE"

if [[ $? -eq 0 ]]; then
    log INFO "Dump created: $DUMP_FILE"
else
    log ERROR "Dump failed"
    exit 1
fi
