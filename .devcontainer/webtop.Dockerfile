FROM lscr.io/linuxserver/webtop:ubuntu-xfce

ENV DEBIAN_FRONTEND=noninteractive

# ============================================================
#  Layer 1: System packages
# ============================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Browser
    firefox \
    # Recon
    nmap masscan dnsutils whois dnsrecon dnsenum dirb gobuster \
    # Web
    sqlmap nikto wfuzz \
    # Cracking
    hydra john hashcat \
    # Network
    netcat-openbsd tcpdump wireshark-common socat proxychains4 \
    openvpn wireguard-tools \
    # Reversing
    gdb binwalk ltrace strace radare2 \
    # Dev
    curl wget git unzip jq tmux zsh \
    python3 python3-pip python3-venv python3-dev \
    golang-go \
    # Desktop
    xfce4-whiskermenu-plugin xfce4-goodies xfce4-terminal \
    # Misc
    sshfs ftp rlwrap tree file dos2unix xxd \
    && rm -rf /var/lib/apt/lists/*

# ============================================================
#  Layer 2: Go tools
# ============================================================
ENV GOPATH=/opt/go PATH="/opt/go/bin:/usr/local/go/bin:${PATH}"

RUN go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/ffuf/ffuf/v2@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install github.com/tomnomnom/gf@latest && \
    go install github.com/lc/gau/v2/cmd/gau@latest && \
    go install github.com/hakluke/hakrawler@latest && \
    rm -rf /root/go/pkg /root/go/src /tmp/* 2>/dev/null; true

# ============================================================
#  Layer 3: Python tools (venv)
# ============================================================
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir \
        impacket pwntools volatility3 \
        bloodhound certipy-ad crackmapexec git-dumper \
    && rm -rf /root/.cache; true

ENV PATH="/opt/venv/bin:${PATH}"

# ============================================================
#  Layer 4: Wordlists & privesc (biggest layer, cached last)
# ============================================================
RUN mkdir -p /opt/wordlists /opt/privesc /opt/tools && \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git /opt/wordlists/SecLists && \
    wget -q -P /opt/privesc \
      https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh \
      https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe \
      https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 && \
    chmod +x /opt/privesc/*; true

# ============================================================
#  Layer 5: Config files (changes often, keep last)
# ============================================================
COPY scripts/  /opt/setup-scripts/
COPY config/   /opt/default-config/

RUN chmod +x /opt/setup-scripts/*.sh

EXPOSE 3000
