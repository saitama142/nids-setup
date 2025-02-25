#!/bin/bash

echo "Installing Suricata..."

# Update package lists
sudo apt-get update

# Install dependencies
sudo apt-get install -y software-properties-common
sudo apt-get install -y suricata suricata-update

# Create Suricata user and group if they don't exist
if ! getent group suricata >/dev/null; then
    sudo groupadd suricata
fi
if ! getent passwd suricata >/dev/null; then
    sudo useradd -r -g suricata -c "Suricata IDS" -s /sbin/nologin suricata
fi

# Create necessary directories
sudo mkdir -p /var/lib/suricata
sudo mkdir -p /etc/suricata/rules
sudo mkdir -p /var/log/suricata

# Set proper permissions
sudo chown -R suricata:suricata /var/lib/suricata || true
sudo chown -R suricata:suricata /var/log/suricata || true
sudo chown -R suricata:suricata /etc/suricata/rules || true

# Initialize Suricata update with error handling
if ! sudo suricata-update update-sources; then
    echo "Warning: Error updating sources, continuing anyway..."
fi

if ! sudo suricata-update --no-reload; then
    echo "Warning: Error updating rules, continuing anyway..."
fi

# Verify installation
if suricata -V &> /dev/null; then
    echo "Suricata installed successfully!"
else
    echo "Failed to install Suricata."
    exit 1
fi
