#!/bin/bash
set -e

# Fix Yarn repo
sudo rm -f /etc/apt/sources.list.d/yarn.list
sudo rm -f /etc/apt/sources.list.d/*yarn*

sudo apt update -y
sudo apt upgrade -y

# Desktop + VNC
sudo apt install -y xfce4 xfce4-goodies tigervnc-standalone-server dbus-x11 \
                    novnc websockify falkon xterm git

# Pentest tools
sudo apt install -y nmap sqlmap nikto gobuster wfuzz hydra john hashcat \
                    netcat-openbsd tcpdump wireshark dirb dnsutils whois \
                    openvpn ssh curl wget python3 python3-pip

# Optional: SecLists (commenté pour éviter 3GB)
# git clone https://github.com/danielmiessler/SecLists.git ~/SecLists

# VNC config
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# Create VNC password if missing
if [ ! -f ~/.vnc/passwd ]; then
    echo "pentest" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
fi

# Clean old sessions
vncserver -kill :1 2>/dev/null || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* || true
