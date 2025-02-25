#!/bin/bash

echo "Configuring Suricata..."

# Verify Suricata installation
if ! command -v suricata &> /dev/null; then
    echo "Error: Suricata is not installed"
    exit 1
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

# Create a proper variables configuration file
sudo tee /etc/suricata/suricata.yaml > /dev/null << EOF
%YAML 1.1
---
vars:
  address-groups:
    HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
    EXTERNAL_NET: "!HOME_NET"
    HTTP_SERVERS: "HOME_NET"
    SQL_SERVERS: "HOME_NET"
    DNS_SERVERS: "HOME_NET"
    SMTP_SERVERS: "HOME_NET"
    FTP_SERVERS: "HOME_NET"
    SSH_SERVERS: "HOME_NET"
    AIM_SERVERS: "HOME_NET"
  port-groups:
    HTTP_PORTS: "[80,8080]"
    SHELLCODE_PORTS: "!80"
    ORACLE_PORTS: 1521
    SSH_PORTS: 22
    DNP3_PORTS: 20000
    MODBUS_PORTS: 502

default-log-dir: /var/log/suricata/

af-packet:
  - interface: $interface
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes

# Enable stats logging
stats:
  enabled: yes
  filename: stats.log
  interval: 60

detect-engine:
  profile: medium
  sgh-mpm-context: auto

outputs:
  - fast:
      enabled: yes
      filename: fast.log
      append: yes
  - eve-log:
      enabled: yes
      filetype: regular
      filename: eve.json
      types:
        - alert
  - stats:
      enabled: yes
      filename: stats.log
      interval: 60

app-layer:
  protocols:
    tls:
      enabled: yes

# Configuration for optimal performance
max-pending-packets: 1024
EOF

# Create required directories
sudo mkdir -p /var/log/suricata
sudo chown -R suricata:suricata /var/log/suricata 2>/dev/null || true

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
