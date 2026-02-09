#!/bin/bash
# ===============================
# Apollo Theme Universal Installer
# by Muhammad Ali Usman
# ===============================
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# GitHub raw
GIT_RAW="https://raw.githubusercontent.com/MuhammadAliUsman/theme/main/apolloInstallerAmd64"
INSTALLER="apolloInstallerAmd64"

echo -e "${CYAN}"
echo "======================================"
echo "   Apollo Universal Theme Installer"
echo "======================================"
echo -e "${NC}"

# Must be root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ Run this as root!${NC}"
  exit 1
fi

# Try to find panel directory
PANEL_DIRS=(
  "/var/www/pterodactyl"
  "/usr/share/pterodactyl"
  "/srv/pterodactyl"
)

FOUND=""
for d in "${PANEL_DIRS[@]}"; do
  if [ -d "$d" ]; then
    PANEL_DIR="$d"
    FOUND="yes"
    break
  fi
done

if [ -z "$FOUND" ]; then
  read -p "Panel path not found automatically. Enter your panel path: " PANEL_DIR
  if [ ! -d "$PANEL_DIR" ]; then
    echo -e "${RED}❌ Invalid path.${NC}"
    exit 1
  fi
fi

echo -e "${GREEN}✔ Using panel path: $PANEL_DIR${NC}"

cd /tmp

echo -e "${CYAN}⬇ Downloading Apollo binary...${NC}"
curl -fsSL "$GIT_RAW" -o "$INSTALLER"
chmod +x "$INSTALLER"

echo -e "${CYAN}🚀 Running installer...${NC}"
./"$INSTALLER"

echo -e "${CYAN}🔧 Setting permissions...${NC}"
cd "$PANEL_DIR"
chown -R www-data:www-data .
chmod -R 755 storage bootstrap/cache

echo -e "${CYAN}🔄 Restarting services...${NC}"
systemctl restart nginx
systemctl restart php*-fpm || true

echo -e "${GREEN}"
echo "======================================"
echo " Apollo Theme Installed Successfully"
echo "======================================"
echo -e "${NC}"
