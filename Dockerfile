FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Utiliser les mods Webtop pour installer les paquets de manière persistante
ENV DOCKER_MODS=linuxserver/mods:universal-package-install
ENV INSTALL_PACKAGES=nmap|sqlmap|nikto|gobuster|wfuzz|hydra|john|hashcat|netcat-openbsd|tcpdump|wireshark-common|dirb|dnsutils|whois|openvpn|curl|wget|git|python3|python3-pip|python3-dev|gdb|binwalk|binutils|ltrace|strace|radare2|seclists|zaproxy|firefox

RUN apt-get update && apt-get install -y \
    xfce4-whiskermenu-plugin \
    xfce4-goodies \
    xfce4-genmon-plugin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Installer les outils supplémentaires
RUN gunzip -c /usr/share/wordlists/rockyou.txt.gz > /usr/share/wordlists/rockyou.txt && \
    wget -q https://portswigger.net/burp/releases/download?product=community&version=2023.12.1&type=Linux -O /tmp/burp.sh && \
    chmod +x /tmp/burp.sh && /tmp/burp.sh -q && \
    pip3 install volatility3 && \
    mkdir -p /opt/privesc && cd /opt/privesc && \
    wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh && \
    wget -q https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe && \
    wget -q https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64
