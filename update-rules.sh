#!/bin/bash

# Set variables
TEMP_DIR="/tmp/nids-rules"

# Make sure the directory exists
mkdir -p "$TEMP_DIR"

# Function to update Suricata rules
update_suricata_rules() {
    echo "Updating Suricata rules..."
    
    # First make sure all required variables are in the config
    echo "Ensuring required variables are defined..."
    sudo grep -q "HTTP_SERVERS" /etc/suricata/suricata.yaml || {
        echo "Adding missing variables to configuration..."
        sudo tee -a /etc/suricata/suricata.yaml > /dev/null << EOF

vars:
  address-groups:
    HTTP_SERVERS: "HOME_NET"
    SQL_SERVERS: "HOME_NET"
  port-groups:
    HTTP_PORTS: "[80,8080]"
EOF
    }
    
    # Use suricata-update for rules
    echo "Running suricata-update..."
    sudo suricata-update --verbose
    
    # Reload Suricata if running
    if systemctl is-active --quiet suricata || pgrep -x suricata > /dev/null; then
        echo "Reloading Suricata..."
        sudo systemctl reload suricata || sudo systemctl restart suricata
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
