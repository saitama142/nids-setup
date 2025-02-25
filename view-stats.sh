#!/bin/bash

# Check which NIDS is installed
if [ -f /etc/snort/snort.conf ]; then
    NIDS="snort"
elif [ -f /etc/suricata/suricata.yaml ]; then
    NIDS="suricata"
else
    echo "No NIDS installation detected"
    exit 1
fi

# Function to display stats
display_stats() {
    echo "=== NIDS Statistics ==="
    echo "NIDS Type: ${NIDS^}"
    
    # Show process status
    if [ "$NIDS" = "snort" ]; then
        systemctl status snort --no-pager
        echo -e "\nAlert Statistics (last 24h):"
        sudo grep -c "Priority: [0-9]" /var/log/snort/alert.log
    else
        systemctl status suricata --no-pager
        echo -e "\nAlert Statistics (last 24h):"
        sudo grep -c "Classification" /var/log/suricata/fast.log
    fi

    # Show resource usage
    echo -e "\nResource Usage:"
    ps aux | grep "$NIDS" | grep -v grep
}

display_stats
