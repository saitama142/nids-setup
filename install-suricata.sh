#!/bin/bash

echo "Installing Suricata..."

# Update package lists
sudo apt-get update

# Install Suricata with minimal output
sudo apt-get install -y suricata suricata-update

# Create minimal configuration
sudo tee /etc/suricata/suricata.yaml > /dev/null << EOF
%YAML 1.1
---
vars:
  address-groups:
    HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
    EXTERNAL_NET: "!HOME_NET" 
    HTTP_SERVERS: "\$HOME_NET"
    SQL_SERVERS: "\$HOME_NET"
    DNS_SERVERS: "\$HOME_NET"
  port-groups:
    HTTP_PORTS: "[80,8080]"

default-log-dir: /var/log/suricata/
EOF

# Create required directories
sudo mkdir -p /var/log/suricata
sudo chown -R suricata:suricata /var/log/suricata 2>/dev/null || true

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
