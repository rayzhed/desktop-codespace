#!/bin/bash
# bootstrap.sh - Runs ONCE at codespace creation (postCreateCommand)
# This is where we pull or build the heavy image so attach is instant

set -e

IMAGE_NAME="webtop-cyber"
GHCR_IMAGE="${GHCR_IMAGE:-}"

echo "=============================================="
echo "     Cyber Desktop - Initial Setup"
echo "=============================================="

# Strategy 1: Try pulling prebuilt image from GHCR (fastest)
if [ -n "$GHCR_IMAGE" ]; then
    echo "[*] Pulling prebuilt image from GHCR..."
    if docker pull "$GHCR_IMAGE" 2>/dev/null; then
        docker tag "$GHCR_IMAGE" "$IMAGE_NAME"
        echo "[+] Prebuilt image ready! Attach will be instant."
        exit 0
    fi
    echo "[!] GHCR pull failed, falling back to local build..."
fi

# Strategy 2: Build locally (first time only, then cached)
echo "[*] Building image locally (first time ~8min, cached after)..."
docker build -t "$IMAGE_NAME" -f .devcontainer/webtop.Dockerfile .devcontainer/

echo "[+] Image built and cached. Attach will be fast."
