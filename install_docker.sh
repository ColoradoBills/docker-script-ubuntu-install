#!/bin/bash
set -e

# Docker Installer Script
# For: Debian/Ubuntu systems (incl. Ubuntu 24.04 via noble fallback)
# Usage: sudo ./install_docker.sh

echo "==> [1/7] Updating package index..."
apt-get update -qq

echo "==> [2/7] Installing required packages..."
apt-get install -y -qq \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "==> [3/7] Creating keyrings directory..."
install -m 0755 -d /etc/apt/keyrings

echo "==> [4/7] Adding Docker's official GPG key (dearmored)..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "==> [5/7] Setting up Docker repository..."

ARCH=$(dpkg --print-architecture)
. /etc/os-release

# Fallback to 'noble' for unsupported Ubuntu 24.04 ("plucky")
CODENAME="${VERSION_CODENAME:-$(lsb_release -cs)}"
if [ "$CODENAME" = "plucky" ]; then
  echo "!! 'plucky' not yet supported by Docker. Using 'noble' instead."
  CODENAME="noble"
fi

echo \
  "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $CODENAME stable" \
  > /etc/apt/sources.list.d/docker.list

echo "==> [6/7] Updating package index with Docker packages..."
apt-get update -qq

echo "==> [7/7] Installing Docker Engine and plugins..."
apt-get install -y -qq \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "==> Adding current user ($SUDO_USER) to docker group..."
usermod -aG docker "${SUDO_USER:-$USER}"

echo
echo "✅ Docker installation complete!"
echo "   • Log out and back in (or run 'newgrp docker') to use Docker as non-root user."
echo "   • Test with: docker --version && docker compose version"
