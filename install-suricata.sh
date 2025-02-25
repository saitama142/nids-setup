#!/bin/bash

echo "Installing Suricata..."

# Update package lists
sudo apt-get update

# Install Suricata and dependencies
sudo apt-get install -y \
    suricata \
    suricata-update

# Create required directories
sudo mkdir -p /var/lib/suricata
sudo mkdir -p /var/log/suricata
sudo chown -R suricata:suricata /var/lib/suricata /var/log/suricata

# Initialize Suricata update
sudo suricata-update update-sources || true
sudo suricata-update --no-reload || true

# Confirm installation
if suricata -V &> /dev/null; then
    echo "Suricata installed successfully!"
    read -p "Do you want to configure Suricata now? (y/n): " configure
    if [[ "$configure" =~ ^[Yy]$ ]]; then
        ./configure-suricata.sh
    fi
else
    echo "Failed to install Suricata."
    exit 1
fi
