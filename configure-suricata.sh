#!/bin/bash

echo "Configuring Suricata..."

# Define the interface to listen on
read -p "Enter the network interface Suricata should listen on (e.g., eth0): " interface

# Verify interface exists
if ! ip link show "$interface" &> /dev/null; then
    echo "Error: Interface $interface does not exist"
    exit 1
fi

# Backup original config
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.bak

# Create a simple but functional configuration
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
    SMTP_SERVERS: "\$HOME_NET"
    FTP_SERVERS: "\$HOME_NET"
    SIP_SERVERS: "\$HOME_NET"
    SSH_SERVERS: "\$HOME_NET"
    AIM_SERVERS: "\$HOME_NET"
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

outputs:
  - eve-log:
      enabled: yes
      filetype: regular
      filename: eve.json
  - fast:
      enabled: yes
      filename: fast.log
  - stats:
      enabled: yes
      filename: stats.log
      interval: 30

app-layer:
  protocols:
    tls:
      enabled: yes
EOF

# Test configuration
echo "Testing Suricata configuration..."
if sudo suricata -T -c /etc/suricata/suricata.yaml; then
    echo "Configuration test successful"
    
    # Stop existing service if running
    sudo systemctl stop suricata 2>/dev/null || true
    
    # Enable and start service
    sudo systemctl enable suricata
    sudo systemctl start suricata
    
    echo "Suricata configured and started successfully!"
else
    echo "Configuration test failed. Restoring backup..."
    sudo mv /etc/suricata/suricata.yaml.bak /etc/suricata/suricata.yaml
    exit 1
fi
