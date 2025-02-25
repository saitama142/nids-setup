#!/bin/bash

echo "Installing Suricata..."

# Update package lists
sudo apt-get update

# Install dependencies
sudo apt-get install -y software-properties-common
sudo apt-get install -y suricata suricata-update

# Create necessary directories
sudo mkdir -p /var/lib/suricata
sudo mkdir -p /etc/suricata/rules
sudo mkdir -p /var/log/suricata

# Set proper permissions
sudo chown -R suricata:suricata /var/lib/suricata
sudo chown -R suricata:suricata /var/log/suricata

# Initialize Suricata update
sudo suricata-update update-sources
sudo suricata-update --no-reload

# Verify installation
if suricata -V &> /dev/null; then
    echo "Suricata installed successfully!"
else
    echo "Failed to install Suricata."
    exit 1
fi
