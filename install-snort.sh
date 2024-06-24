#!/bin/bash

# Installation steps for Snort
echo "Installing Snort..."

# Update package lists
sudo apt-get update

# Install Snort
sudo apt-get install -y snort

# Confirm installation
snort_version=$(snort -V)
if [[ $snort_version == *"Version"* ]]; then
    echo "Snort installed successfully!"
else
    echo "Failed to install Snort."
    exit 1
fi
