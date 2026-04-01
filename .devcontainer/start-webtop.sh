#!/bin/bash

echo "=============================================="
echo "        Cyber Desktop Initial Setup"
echo "=============================================="
echo "1) Use recommended defaults (fast)"
echo "2) Customize settings"
read -p "Choose an option [1/2]: " CHOICE

if [ "$CHOICE" = "2" ]; then
    read -p "Enter your timezone (e.g. Europe/Paris): " USER_TZ
    read -p "Enter your keyboard layout (e.g. fr, us, de): " USER_KB
    read -p "Enter your preferred screen resolution (e.g. 1920x1080): " USER_RES
else
    USER_TZ="Europe/Paris"
    USER_KB="fr"
    USER_RES="1920x1080"
fi

echo ""
echo "Using configuration:"
echo "Timezone: $USER_TZ"
echo "Keyboard: $USER_KB"
echo "Resolution: $USER_RES"
echo ""

export USER_TZ
export USER_KB
export USER_RES

docker rm -f webtop 2>/dev/null || true

docker build -t webtop-custom -f .devcontainer/webtop.Dockerfile .

docker run -d \
  --name webtop \
  -p 3000:3000 \
  --shm-size="2gb" \
  -e TZ="$USER_TZ" \
  -e KEYBOARD="$USER_KB" \
  -e SCREEN_RES="$USER_RES" \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -v /var/log/cyber-setup.log:/var/log/cyber-setup.log \
  webtop-custom

docker exec -d webtop bash /config/background-install.sh
docker exec -d webtop bash /config/xfce-theme-setup.sh "$USER_RES" "$USER_KB"
docker exec -d webtop bash /config/firefox-extensions.sh

echo ""
echo "=============================================="
echo "   Your Cyber Offensive Desktop is Ready!"
echo "=============================================="
echo "If the browser does not open automatically:"
echo "https://<your-codespace>-3000.app.github.dev"
