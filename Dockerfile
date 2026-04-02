FROM lscr.io/linuxserver/webtop:ubuntu-xfce

RUN apt-get update && apt-get install -y \
    firefox \
    nmap sqlmap nikto gobuster wfuzz hydra john hashcat \
    netcat-openbsd tcpdump wireshark-common dirb dnsutils whois \
    openvpn curl wget git python3 python3-pip python3-dev \
    gdb binwalk binutils ltrace strace radare2 \
    xfce4-whiskermenu-plugin xfce4-goodies xfce4-genmon-plugin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    
COPY .devcontainer/background-install.sh /config/
COPY .devcontainer/xfce-theme-setup.sh /config/
COPY .devcontainer/firefox-extensions.sh /config/
