#!/bin/bash

set -e

echo "=== Updating system packages ==="
sudo apt-get update

echo "=== Installing required dependencies ==="
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo "=== Creating keyring directory ==="
sudo install -m 0755 -d /etc/apt/keyrings

echo "=== Downloading Docker GPG key ==="
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

echo "=== Setting permissions for the GPG key ==="
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "=== Adding Docker repository to APT sources ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Updating package list ==="
sudo apt-get update

echo "=== Installing Docker and Docker Compose ==="
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Adding current user to 'docker' group ==="
sudo groupadd -f docker
sudo usermod -aG docker "$USER"

echo "=== Enabling Docker services ==="
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo ""
echo "✅ Docker installation complete."
echo "🚀 You may need to log out and back in (or run 'newgrp docker') to use Docker without sudo."
