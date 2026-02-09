#!/bin/bash

# ===============================
#     Apollo Theme Installer
#     by Muhammad Ali Usman
# ===============================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Variables
GIT_RAW="https://raw.githubusercontent.com/MuhammadAliUsman/theme/main/apolloInstallerAmd64"
INSTALLER_NAME="apolloInstallerAmd64"
PANEL_DIR="/var/www/pterodactyl"

echo -e "${CYAN}"
echo "======================================"
echo "      Apollo Theme Installer"
echo "======================================"
echo -e "${NC}"

# Root check
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ Please run this script as root${NC}"
  exit 1
fi

# Check panel directory
if [ ! -d "$PANEL_DIR" ]; then
  echo -e "${RED}❌ Pterodactyl panel not found at $PANEL_DIR${NC}"
  echo -e "${YELLOW}Edit PANEL_DIR in script if your panel is installed elsewhere.${NC}"
  exit 1
fi

echo -e "${GREEN}✔ Pterodactyl panel detected${NC}"

cd /tmp

# Download installer
echo -e "${CYAN}⬇ Downloading Apollo Theme Installer...${NC}"
curl -fsSL "$GIT_RAW" -o "$INSTALLER_NAME"

# Permission
chmod +x "$INSTALLER_NAME"

echo -e "${CYAN}🚀 Running Apollo Installer...${NC}"
./"$INSTALLER_NAME"

# Fix permissions (just in case)
echo -e "${CYAN}🔧 Fixing permissions...${NC}"
cd "$PANEL_DIR"
chown -R www-data:www-data .
chmod -R 755 storage bootstrap/cache

# Restart services
echo -e "${CYAN}🔄 Restarting services...${NC}"
systemctl restart nginx
systemctl restart php*-fpm || true

echo -e "${GREEN}"
echo "======================================"
echo "   Apollo Theme Installed Successfully"
echo "======================================"
echo -e "${NC}"
