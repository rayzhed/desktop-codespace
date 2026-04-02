#!/bin/bash

# bootstrap.sh - Runs ONCE at codespace creation (postCreateCommand)

IMAGE_NAME="webtop-cyber"

# Auto-detect from Codespaces environment

GITHUB_USER="${GITHUB_REPOSITORY_OWNER:-$(echo "$GITHUB_REPOSITORY" | cut -d'/' -f1)}"

REPO_NAME="$(echo "$GITHUB_REPOSITORY" | cut -d'/' -f2)"

GHCR_IMAGE="ghcr.io/${GITHUB_USER}/${REPO_NAME}/webtop-cyber:latest"

echo ""

echo "=============================================="

echo "     Cyber Desktop - Setting Up"

echo "=============================================="

echo "  Pulling: $GHCR_IMAGE"

echo "=============================================="

echo ""

if docker pull "$GHCR_IMAGE" 2>&1; then

    docker tag "$GHCR_IMAGE" "$IMAGE_NAME"

    echo ""

    echo "[+] Image ready."

    exit 0

fi

echo ""

echo "[!] Pull failed, building locally (~10min)..."

echo ""

docker build \

    --progress=plain \

    -t "$IMAGE_NAME" \

    -f .devcontainer/webtop.Dockerfile \

    .devcontainer/ 2>&1

if [ $? -ne 0 ]; then

    echo "[ERROR] Build failed."

    exit 1

fi

echo "[+] Build complete."
