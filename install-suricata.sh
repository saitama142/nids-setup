#!/bin/bash

# Installation steps for Suricata
echo "Installing Suricata..."

# Update package lists
sudo apt-get update

# Install Suricata
sudo apt-get install -y suricata

# Confirm installation
suricata_version=$(suricata -V)
if [[ $suricata_version == *"Suricata"* ]]; then
    echo "Suricata installed successfully!"
else
    echo "Failed to install Suricata."
    exit 1
fi
