#!/bin/bash

# Check which NIDS is installed
if [ -f /etc/suricata/suricata.yaml ]; then
    NIDS="suricata"
    NIDS_STATUS=$(systemctl is-active suricata || echo "inactive")
    STATS_FILE="/var/log/suricata/stats.log"
    ALERT_FILE="/var/log/suricata/fast.log"
else
    echo "No NIDS installation detected"
    exit 1
fi

# Function to display stats
display_stats() {
    echo "=== NIDS Statistics ==="
    echo "NIDS Type: ${NIDS^}"
    echo "Status: ${NIDS_STATUS}"
    
    if [ "$NIDS_STATUS" = "active" ]; then
        # Show process info
        ps -p $(pidof suricata) -o %cpu,%mem,cmd=

        # Show alert count
        echo -e "\nAlert Statistics (last 24h):"
        if [ -f "$ALERT_FILE" ]; then
            sudo grep -c "Classification" "$ALERT_FILE" || echo "0"
        else
            echo "0 (no alerts file found)"
        fi

        # Show stats from stats.log if available
        if [ -f "$STATS_FILE" ]; then
            echo -e "\nPerformance Statistics:"
            tail -n 20 "$STATS_FILE"
        fi
    else
        echo "Warning: NIDS service is not running"
    fi
}

display_stats
