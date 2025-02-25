#!/bin/bash

# Set variables
TEMP_DIR="/tmp/nids-rules"
LOG_FILE="/tmp/suricata-update.log"

# Make sure the directory exists
mkdir -p "$TEMP_DIR"

# Function to update Suricata rules
update_suricata_rules() {
    echo "Updating Suricata rules..."
    
    # Create minimal temporary configuration with all required variables
    TEMP_CONFIG="$TEMP_DIR/suricata-temp.yaml"
    cat > "$TEMP_CONFIG" << EOF
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
EOF

    # Update Suricata rules quietly
    echo "Downloading and updating rules..."
    sudo suricata-update --quiet --config "$TEMP_CONFIG" > "$LOG_FILE" 2>&1
    
    # Stop and disable Suricata to prevent future issues
    sudo systemctl stop suricata 2>/dev/null || true
    
    # Verify configuration
    if sudo suricata -T -c /etc/suricata/suricata.yaml &>/dev/null; then
        echo "Configuration verified successfully"
        sudo systemctl enable suricata
        sudo systemctl start suricata
        echo "Suricata restarted with new rules"
    else
        echo "Configuration has errors - please run the configure option"
    fi
}

# Main execution
if [ -f /etc/suricata/suricata.yaml ]; then
    update_suricata_rules
else
    echo "No supported NIDS installation detected"
    exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"
echo "Update completed"
