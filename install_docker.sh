#!/bin/bash
set -e
#
# install_docker.sh
# -----------------
# Installs Docker Engine, Docker CLI, and the Docker Compose plugin
# on a Debian/Ubuntu host.  Must be run as root (or via sudo).
#

echo "=> Updating package index..."
apt-get update

echo "=> Installing prerequisites (ca-certificates, curl, gnupg)..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg

echo "=> Creating /etc/apt/keyrings (if it doesn't already exist)..."
install -m 0755 -d /etc/apt/keyrings

echo "=> Downloading Docker’s official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo "=> Adding Docker’s APT repository..."
# This uses the correct UBUNTU_CODENAME (e.g. "focal", "jammy", etc.)
ARCH="$(dpkg --print-architecture)"
. /etc/os-release
DISTRO_CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}"

echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $DISTRO_CODENAME stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=> Updating package index after adding Docker repository..."
apt-get update

echo "=> Installing Docker Engine, CLI, containerd, buildx, and the Docker Compose plugin..."
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "=> Adding the current user ($SUDO_USER) to the docker group..."
# If $SUDO_USER is empty (script run as root directly), fallback to $USER.
TARGET_USER="${SUDO_USER:-$USER}"
usermod -aG docker "$TARGET_USER"

echo "=> Enabling Docker services at boot..."
systemctl enable docker.service
systemctl enable containerd.service

echo
echo "Docker installation is complete!"
echo "  • If you added yourself to the 'docker' group, log out and log back in"
echo "    (or run 'newgrp docker') so that 'docker' commands work without sudo."
echo "  • Verify with:   docker --version   and   docker compose version"
