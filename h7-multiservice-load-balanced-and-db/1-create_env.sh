#!/bin/bash

ENV_FILE=".env"
TARGET_DIR="db-postgres"
TARGET_FILE="$TARGET_DIR/.env"

read -s -p "ADD Password: " POSTGRES_PASSWORD
echo

echo "Creating $ENV_FILE"

cat > "$ENV_FILE" <<EOF
POSTGRES_DB=mydb
POSTGRES_USER=postgres
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_PORT=5432
EOF

echo ".env created."

# Copy .env to test & debugging
cp "$ENV_FILE" "$TARGET_FILE"

echo ".env copied to $TARGET_FILE"
