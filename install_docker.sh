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

# Download Docker’s official GPG key
echo "Downloading Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Set proper permissions on the key
echo "Setting permissions on Docker GPG key..."
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "Adding Docker repository..."
VERSION_CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
ARCH=$(dpkg --print-architecture)
echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index again with the new repository
echo "Updating package index after adding Docker repository..."
sudo apt-get update

# Install Docker Engine and related packages
echo "Installing Docker Engine and related packages..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the current user to the docker group
echo "Adding $USER to the docker group..."
sudo usermod -aG docker $USER
newgrp docker

# Enable Docker services to start on boot
echo "Enabling Docker and containerd services..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

echo "Docker installation complete!"