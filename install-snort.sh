#!/bin/bash

# Installation steps for Snort
echo "Installing Snort..."

# Update package lists
sudo apt-get update

# Add Snort repository for Debian
if [ ! -f /etc/apt/sources.list.d/snort.list ]; then
    echo "deb http://http.debian.net/debian bullseye-backports main" | sudo tee /etc/apt/sources.list.d/snort.list
    sudo apt-get update
fi

# Install Snort
sudo apt-get install -y -t bullseye-backports snort

# Create default rules directory if it doesn't exist
sudo mkdir -p /etc/snort/rules

# Download community rules if they don't exist
if [ ! -f /etc/snort/rules/community.rules ]; then
    sudo wget https://www.snort.org/downloads/community/community-rules.tar.gz -O /tmp/community-rules.tar.gz
    sudo tar -xzf /tmp/community-rules.tar.gz -C /etc/snort/rules/
    sudo rm /tmp/community-rules.tar.gz
fi

# Confirm installation
if snort -V >/dev/null 2>&1; then
    echo "Snort installed successfully!"
else
    echo "Failed to install Snort."
    exit 1
fi
