#!/bin/bash

# Set variables
TEMP_DIR="/tmp/nids-rules"
LOG_FILE="/tmp/suricata-update.log"

# Make sure the directory exists
mkdir -p "$TEMP_DIR"

# Function to update Suricata rules
update_suricata_rules() {
    echo "Updating Suricata rules..."
    
    # Fix configuration to prevent variable errors
    echo "Ensuring required variables are defined..."
    
    # Check if the variables section exists and is properly formatted
    if ! grep -q "^vars:" /etc/suricata/suricata.yaml; then
        echo "Adding missing 'vars' section to configuration..."
        sudo sed -i '1s/^/%YAML 1.1\n---\nvars:\n  address-groups:\n    HOME_NET: "[192.168.0.0\/16,10.0.0.0\/8,172.16.0.0\/12]"\n    EXTERNAL_NET: "!HOME_NET"\n    HTTP_SERVERS: "HOME_NET"\n    SQL_SERVERS: "HOME_NET"\n    DNS_SERVERS: "HOME_NET"\n  port-groups:\n    HTTP_PORTS: "[80,8080]"\n\n/' /etc/suricata/suricata.yaml
    fi
    
    # Use suricata-update with reduced verbosity
    echo "Running suricata-update (please wait, this may take a minute)..."
    sudo suricata-update --quiet > "$LOG_FILE" 2>&1
    
    # Show summary instead of all warnings
    WARNING_COUNT=$(grep -c "Warning" "$LOG_FILE")
    echo "Rule update completed with $WARNING_COUNT warnings (details in $LOG_FILE)"
    
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
