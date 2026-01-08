#!/usr/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    local type="$1"    # "INFO" & "ERROR"
    local message="$2"
    local color="$GREEN"

    if [[ "$type" == "ERROR" ]]; then
        color="$RED"
    fi

    echo -e "${color}$(date '+%Y-%m-%d %H:%M:%S') [$type] - $message${NC}"
}

REPO_URL="https://github.com/s-octavian/layered_application.git"
APP_DIR="$(basename -s .git "$REPO_URL")"


#Prompt
read -s -p "MariaDB root: " DB_PASSWORD
echo
read -s -p "MariaDB appuser: " DB_PASSWORD_APPUSER
echo

# Var DB
DB_NAME="mydb"
DB_USER="appuser"


log INFO "Install MariaDB..."
sudo dnf install -y mariadb-server mariadb
if [[ $? -ne 0 ]]; then
    log ERROR "Eroare MariaDB!"
    exit 1
fi

log INFO "Start MariaDB..."
sudo systemctl enable --now mariadb
if [[ $? -ne 0 ]]; then
    log ERROR "Not started MariaDB!"
    exit 1
fi

# Config root
log INFO "Config MariaDB root"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD'; FLUSH PRIVILEGES;" 2>/dev/null

# Config appuser & db for app
log INFO "Config appuser & db for app"
sudo mysql -u root -p"$DB_PASSWORD" -e "
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD_APPUSER';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
"

# Create data tb
log INFO "Create TB 'data'..."
sudo mysql -u "$DB_USER" -p"$DB_PASSWORD_APPUSER" "$DB_NAME" -e "
CREATE TABLE IF NOT EXISTS data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
"

# Install Node.js + NPM
log INFO "Install Node.js + NPM"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo dnf install -y nodejs
if [[ $? -ne 0 ]]; then
    log ERROR "Eroare install Node.js + NPM!"
    exit 1
fi

# Log -version
log INFO "Node.js version: $(node -v)"
log INFO "NPM version: $(npm -v)"

log INFO "Clone repo"
if git clone "$REPO_URL" "$APP_DIR"; then
    log INFO "Repo cloned into $APP_DIR"
else
    log ERROR "Failed to clone repo!"
    exit 1
fi

log INFO "Add .env to .gitignore"
if echo ".env" >> "$APP_DIR/.gitignore"; then
    log INFO ".env added to .gitignore"
else
    log ERROR "Failed to update .gitignore"
fi

log INFO "Setup backend"
cd "$APP_DIR/backend" || { log ERROR "Backend directory not found!"; exit 1; }

log INFO "Install backend dependencies"
if npm install express cors mysql dotenv; then
    log INFO "Backend dependencies installed"
else
    log ERROR "Failed to install backend dependencies"
    exit 1
fi

log INFO "Create .env file"
if cat > .env <<EOF
DB_HOST=localhost
DB_PORT=3306
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD_APPUSER}
DB_ROOT_PASSWORD=${DB_PASSWORD}
EOF
then
    log INFO ".env created"
else
    log ERROR "Failed to create .env"
    exit 1
fi

chmod 600 .env

nohup node index.js > backend.log 2>&1 &
if [[ $? -eq 0 ]]; then
    log INFO "Backend started in background"
else
    log ERROR "Failed to start backend"
fi


log INFO "Setup frontend"
cd ../frontend || { log ERROR "Frontend directory not found!"; exit 1; }

log INFO "Install frontend dependencies"
if npm install; then
    log INFO "Frontend dependencies installed"
else
    log ERROR "Failed to install frontend dependencies"
    exit 1
fi

nohup npm run dev > frontend.log 2>&1 &
if [[ $? -eq 0 ]]; then
    log INFO "Frontend started in background"
else
    log ERROR "Failed to start frontend"
fi


sleep 5

log INFO "Test backend"
if curl -s http://localhost:5000 > /dev/null; then
    log INFO "Backend is reachable"
else
    log ERROR "Backend test failed"
fi

log INFO "Test frontend"
if curl -s http://localhost:3000 > /dev/null; then
    log INFO "Frontend is reachable"
else
    log ERROR "Frontend test failed"
fi

log INFO "INSTALL COMPLETED"
log INFO "Open ME @ http://localhost:3000"
log INFO "use  -- ps aux | grep -E 'index.js|next-server' -- to find PID "
