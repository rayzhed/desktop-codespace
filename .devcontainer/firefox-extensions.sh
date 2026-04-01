#!/bin/bash

EXT_DIR="/config/firefox-ext"
mkdir -p $EXT_DIR

declare -A EXTENSIONS=(
  ["wappalyzer"]="https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/addon-0-latest.xpi"
  ["hacktools"]="https://addons.mozilla.org/firefox/downloads/latest/hacktools/addon-0-latest.xpi"
  ["foxyproxy"]="https://addons.mozilla.org/firefox/downloads/latest/foxyproxy-standard/addon-0-latest.xpi"
  ["cookie-editor"]="https://addons.mozilla.org/firefox/downloads/latest/cookie-editor/addon-0-latest.xpi"
  ["uaswitcher"]="https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/addon-0-latest.xpi"
  ["cors-unblock"]="https://addons.mozilla.org/firefox/downloads/latest/cors-everywhere/addon-0-latest.xpi"
)

for name in "${!EXTENSIONS[@]}"; do
  wget -q "${EXTENSIONS[$name]}" -O "$EXT_DIR/$name.xpi"
done
