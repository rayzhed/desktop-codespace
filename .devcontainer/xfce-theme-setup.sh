#!/bin/bash

USER_RES="$1"
USER_KB="$2"

localectl set-x11-keymap "$USER_KB"

xfconf-query -c xsettings -p /Net/ThemeName -s "Greybird-dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"

if [ -n "$USER_RES" ]; then
    xrandr --output VNC-0 --mode "$USER_RES" 2>/dev/null
fi

xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 32
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=6;x=0;y=0"

mkdir -p ~/.config/genmon
echo '#!/bin/bash
echo -n "IP: "
hostname -I | awk "{print \$1}"' > ~/.config/genmon/ip.sh
chmod +x ~/.config/genmon/ip.sh

xfconf-query -c xfce4-panel -p /plugins/plugin-20 -t string -s genmon -n
xfconf-query -c xfce4-panel -p /plugins/plugin-20/command -s "~/.config/genmon/ip.sh"
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -t int -s 20 -a
