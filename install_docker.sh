#!/bin/bash
set -e  # Exit immediately if any command fails

# Update the apt package index
echo "Updating package index..."
sudo apt-get update

# Install required packages
echo "Installing ca-certificates and curl..."
sudo apt-get install -y ca-certificates curl

# Create the directory for apt keyrings
echo "Creating directory /etc/apt/keyrings..."
sudo install -m 0755 -d /etc/apt/keyrings

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker Engine and related packages
echo "Installing Docker Engine and related packages..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the current user to the docker group
echo "Adding $USER to the docker group..."
sudo usermod -aG docker $USER
newgrp docker

# Enable Docker services to start on boot
echo "Enabling Docker and containerd services..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Docker installation complete!"
