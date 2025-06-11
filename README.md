# Docker Installer Script for Ubuntu

This script installs Docker Engine and Docker Compose (via plugin) on Ubuntu.

## 📋 Features
- Installs required dependencies
- Adds official Docker APT repository
- Installs Docker components
- Adds current user to `docker` group
- Enables Docker services on boot

## 📦 Requirements
- Ubuntu 20.04 or newer
- `bash`, `curl`, and `sudo` installed

## 🛠 Usage

1. Clone this repository or download the script:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install-docker.sh -o install-docker.sh
   chmod +x install-docker.sh
   ./install-docker.sh
