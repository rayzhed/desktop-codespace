#!/bin/bash

LOG=/var/log/cyber-setup.log
echo "[INFO] Background cyber setup starting..." > $LOG

apt-get update >> $LOG 2>&1

echo "[+] Installing SecLists..." >> $LOG
apt-get install -y seclists >> $LOG 2>&1

echo "[+] Extracting rockyou..." >> $LOG
gunzip -c /usr/share/wordlists/rockyou.txt.gz > /usr/share/wordlists/rockyou.txt

echo "[+] Installing Burp Suite..." >> $LOG
wget -q https://portswigger.net/burp/releases/download?product=community&version=2023.12.1&type=Linux -O /tmp/burp.sh
chmod +x /tmp/burp.sh
/tmp/burp.sh -q >> $LOG 2>&1

echo "[+] Installing OWASP ZAP..." >> $LOG
apt-get install -y zaproxy >> $LOG 2>&1

echo "[+] Installing Volatility 3..." >> $LOG
pip3 install volatility3 >> $LOG 2>&1

echo "[+] Downloading PrivEsc tools..." >> $LOG
mkdir -p /opt/privesc
cd /opt/privesc
wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe
wget -q https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64

echo "[+] Installing Cyber Tools launcher..." >> $LOG

cat << 'EOF' > /usr/share/applications/cyber-tools.desktop
[Desktop Entry]
Type=Application
Name=Cyber Tools
Exec=xfce4-appfinder
Icon=utilities-terminal
Categories=Utility;Security;
EOF

chmod +x /usr/share/applications/cyber-tools.desktop

echo "[INFO] Background cyber setup complete!" >> $LOG
