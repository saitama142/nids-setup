#!/bin/bash

echo "Configuring Suricata..."

# Verify Suricata installation and user
if ! command -v suricata &> /dev/null; then
    echo "Error: Suricata is not installed"
    exit 1
fi

# Ensure Suricata user exists
if ! getent passwd suricata >/dev/null; then
    echo "Creating Suricata user..."
    sudo useradd -r -g suricata -c "Suricata IDS" -s /sbin/nologin suricata || true
fi

# Backup original config
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.bak

# Define the interface to listen on
read -p "Enter the network interface Suricata should listen on (e.g., eth0): " interface

# Verify interface exists
if ! ip link show "$interface" &> /dev/null; then
    echo "Error: Interface $interface does not exist"
    exit 1
fi

# Load variables configuration
VARS_CONFIG=""
if [ -f "./suricata-vars-config.conf" ]; then
    VARS_CONFIG=$(cat ./suricata-vars-config.conf)
else
    echo "Warning: Variables configuration file not found, using basic variables"
    VARS_CONFIG="vars:
  address-groups:
    HOME_NET: \"[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]\"
    EXTERNAL_NET: \"!\$HOME_NET\"
    HTTP_SERVERS: \"\$HOME_NET\"
    SMTP_SERVERS: \"\$HOME_NET\"
    SQL_SERVERS: \"\$HOME_NET\"
    DNS_SERVERS: \"\$HOME_NET\"
  port-groups:
    HTTP_PORTS: \"[80,8080]\"
    SHELLCODE_PORTS: \"!80\""
fi

# Configure basic settings
sudo tee /etc/suricata/suricata.yaml > /dev/null << EOF
%YAML 1.1
---
# Basic configuration

${VARS_CONFIG}

default-log-dir: /var/log/suricata/

af-packet:
  - interface: $interface
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    tpacket-v3: yes

# Enable stats logging
stats:
  enabled: yes
  file: stats.log
  interval: 60

detect-engine:
  - profile: medium
  - custom-values:
      toclient-groups: 3
      toserver-groups: 3

outputs:
  - fast:
      enabled: yes
      filename: fast.log
      append: yes
  - stats:
      enabled: yes
      filename: stats.log
      interval: 60

app-layer:
  protocols:
    tls:
      enabled: yes

# Basic configuration for optimal performance
max-pending-packets: 1024
EOF

# Create log directory with proper permissions
sudo mkdir -p /var/log/suricata
if getent passwd suricata >/dev/null; then
    sudo chown -R suricata:suricata /var/log/suricata || true
else
    echo "Warning: Suricata user not found, using current user for permissions"
    sudo chown -R $(whoami):$(whoami) /var/log/suricata
fi

# Test configuration
echo "Testing Suricata configuration..."
if sudo suricata -T -c /etc/suricata/suricata.yaml -i "$interface"; then
    echo "Configuration test successful"
    
    # Update rules
    echo "Updating Suricata rules..."
    sudo suricata-update --no-reload
    
    # Enable and restart service
    sudo systemctl enable suricata
    sudo systemctl restart suricata
    
    echo "Suricata configured successfully!"
else
    echo "Configuration test failed. Restoring backup..."
    sudo mv /etc/suricata/suricata.yaml.bak /etc/suricata/suricata.yaml
    exit 1
fi
