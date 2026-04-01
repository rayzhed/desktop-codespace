#!/bin/bash
set -e

# Prevent ALL interactive prompts
export DEBIAN_FRONTEND=noninteractive

# Preseed Wireshark to avoid the yes/no prompt
echo "wireshark-common wireshark-common/install-setuid boolean false" | sudo debconf-set-selections

# Fix Yarn repo
sudo rm -f /etc/apt/sources.list.d/yarn.list
sudo rm -f /etc/apt/sources.list.d/*yarn*

# Update system
sudo apt-get update -yq
sudo apt-get upgrade -yq

# Desktop + VNC
sudo apt-get install -yq --no-install-recommends \
    xfce4 xfce4-goodies tigervnc-standalone-server tigervnc-common dbus-x11 \
    novnc websockify falkon xterm git

# Pentest tools
sudo apt-get install -yq --no-install-recommends \
    nmap sqlmap nikto gobuster wfuzz hydra john hashcat \
    netcat-openbsd tcpdump wireshark-common dirb dnsutils whois \
    openvpn ssh curl wget python3 python3-pip

# VNC config
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# Generate secure random VNC password using tigervncpasswd -f
if [ ! -f ~/.vnc/passwd ]; then
    mkdir -p ~/.vnc

    # Generate random password
    VNC_PASS=$(openssl rand -base64 12)
    echo "$VNC_PASS" > ~/.vnc/vnc-password.txt

    # Generate encrypted password using TigerVNC's filter mode
    echo "$VNC_PASS" | tigervncpasswd -f > ~/.vnc/passwd

    chmod 600 ~/.vnc/passwd

    echo "----------------------------------------"
    echo "Your VNC password is:"
    echo "$VNC_PASS"
    echo "(also saved in ~/.vnc/vnc-password.txt)"
    echo "----------------------------------------"
fi

# Clean old sessions
vncserver -kill :1 2>/dev/null || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X* || true

# Reduce Codespace size
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
