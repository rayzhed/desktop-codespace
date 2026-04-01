#!/bin/bash
set -e

echo "========================================"
echo "  Codespace Desktop Installer Starting"
echo "========================================"
sleep 1

export DEBIAN_FRONTEND=noninteractive

echo "[1/8] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[2/8] Installing XFCE + TigerVNC..."
sudo apt-get install -y \
    xfce4 xfce4-goodies tigervnc-standalone-server tigervnc-common \
    dbus-x11 novnc websockify falkon xterm git

echo "[3/8] Installing pentest tools..."
sudo apt-get install -y \
    nmap sqlmap nikto gobuster wfuzz hydra john hashcat \
    netcat-openbsd tcpdump wireshark-common dirb dnsutils whois \
    openvpn ssh curl wget

echo "[4/8] Creating xstartup..."
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[5/8] Generating VNC password..."
VNC_PASS=$(openssl rand -base64 12)
echo "$VNC_PASS" > ~/.vnc/vnc-password.txt

python3 - <<EOF
import os, crypt
password = "$VNC_PASS"
encrypted = crypt.crypt(password, "vt")
with open(os.path.expanduser("~/.vnc/passwd"), "w") as f:
    f.write(encrypted)
EOF
chmod 600 ~/.vnc/passwd

echo "Your VNC password is: $VNC_PASS"
echo "(saved in ~/.vnc/vnc-password.txt)"

echo "[6/8] Cleaning old VNC sessions..."
vncserver -kill :1 2>/dev/null || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* || true

echo "[7/8] Cleaning system..."
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

echo "[8/8] Installation complete!"
echo "Run: .devcontainer/start-vnc.sh"
