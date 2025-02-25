#!/bin/bash

# Configuration steps for Suricata
echo "Configuring Suricata..."

# Define the interface to listen on
read -p "Enter the network interface Suricata should listen on (e.g., eth0): " interface

# Edit Suricata configuration file
sudo sed -i "s/^\(\s*interface:\s*\).*/\1$interface/" /etc/suricata/suricata.yaml

# Download and install default rules
echo "Downloading default rules..."
sudo suricata-update

# Test Suricata configuration
sudo suricata -T -c /etc/suricata/suricata.yaml -i $interface

# Enable and start Suricata service
sudo systemctl enable suricata
sudo systemctl start suricata

echo "Suricata configured successfully!"
