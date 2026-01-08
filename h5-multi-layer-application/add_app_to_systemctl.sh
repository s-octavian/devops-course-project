#!/usr/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    local type="$1"
    local message="$2"
    local color="$GREEN"
    if [[ "$type" == "ERROR" ]]; then
        color="$RED"
    fi
    echo -e "${color}$(date '+%Y-%m-%d %H:%M:%S') [$type] - $message${NC}"
}

APP_DIR="$(pwd)/layered_application"

if [[ ! -d "$APP_DIR" ]]; then
    log ERROR " NO folder $APP_DIR "
    exit 1
fi

log INFO "backend systemd service..."
sudo tee /etc/systemd/system/backend.service > /dev/null <<EOF
[Unit]
Description=Layered App Backend
After=network.target

[Service]
Type=simple
WorkingDirectory=$APP_DIR/backend
ExecStart=/usr/bin/node index.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

log INFO "frontend systemd service..."
sudo tee /etc/systemd/system/frontend.service > /dev/null <<EOF
[Unit]
Description=Layered App Frontend
After=network.target

[Service]
Type=simple
WorkingDirectory=$APP_DIR/frontend
ExecStart=/usr/bin/npm run dev
Restart=on-failure
Environment=NODE_ENV=development

[Install]
WantedBy=multi-user.target
EOF

log INFO "Reload systemd"
sudo systemctl daemon-reload

#log INFO "Enable services"
#sudo systemctl enable backend
#sudo systemctl enable frontend

log INFO "Start services"
sudo systemctl start backend
sudo systemctl start frontend

log INFO "Status"
sudo systemctl status backend --no-pager
sudo systemctl status frontend --no-pager

log INFO "SYSTEMD SERVICES SETUP COMPLETED"
